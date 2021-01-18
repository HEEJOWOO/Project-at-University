#include <mega128.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>
#define SRF02_ERR_MAX_CNT 2000
#define SRF02_Return_inch 80
#define SRF02_Return_Cm 81
#define SRF02_Return_microSecond 82
#define ADC_VREF_TYPE 0x00  // A/D 컨버터 사용 기준 전압,AREF 단자 사용, 내부 VREF 끄기 설정 
#define ADC_AVCC_TYPE 0x40 // A/D 컨버터 사용 기준 전압,AVcc단자와 ARRE에 연결된 커패시터 사용 
#define ADC_RES_TYPE  0x80  // A/D 컨버터 사용 기준 전압,reserved 
#define ADC_2_56_TYPE 0xC0  // A/D 컨버터 사용 기준 전압,내부 2.56V와 AREF에 연결된 커패시터 사용 
#define LCD_WDATA PORTA // LCD 데이터 포트 정의
#define LCD_WINST PORTA
#define LCD_CTRL PORTG // LCD 제어포트 정의
#define LCD_EN 0
#define LCD_RW 1
#define LCD_RS 2
#define Do 4000 
#define HDo 300
#define PIR_sensor1 PINE.5
#define PIR_sensor2 PINE.7
#define servo_motor PORTE.6
#define num 10
char seg_pat[10]= {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
char seg_pat1[10]= {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
char match[10]={0,1,2,3,4,5,6,7,8,9};  
unsigned char key; 
int count1=0;
unsigned int PIR_Status=0;
char ii=0;
int count=0;
int i =0;
int flag,flag2=0;
int k,b,n=0;
int k1=0;
unsigned char ti_Cnt_1ms; // 1ms 단위 시간 계수 위한 전역 변수선언
unsigned char Com_Reg;
void FND_MATCH(int x)
{      

       for(ii=0 ; ii<11 ; ii++)
        {   
        if(x/10==match[ii])
        {
        PORTB = seg_pat[ii];
        }
        }
        for(ii=0 ; ii<11 ; ii++)
        {   
        if(x%10==match[ii])
        {
        PORTC = seg_pat1[ii];
        }       
        } 
}      
void FND_init()
{
PORTB = seg_pat[0];
PORTC = seg_pat1[0];
}
void Port_init(){
    DDRE.5=0;
    DDRE.6=1;
    DDRE.7=0;
    DDRB=0xff;
    DDRC=0xff;
    DDRD=0x00;
    PORTD=0xff;
}
void myDelay_us(unsigned int delay) 
{ 
    int i; 
    for(i=0; i<delay; i++) 
    { 
        delay_us(1); 
    } 
}
void SSound(int time) 
{ 
    int i, tim; 
    tim = 50000/time; //음계마다 같은 시간동안 울리도록 tim 변수 사용 
    for(i=0; i<tim; i++) 
    { 
        PORTG |= 1<<4; //buzzer on, PORTG의 4번 핀 on(out 1) 
        myDelay_us(time); 
        PORTG &= ~(1<<4); //buzzer off, PORTG의 4번 핀 off(out 0) 
        myDelay_us(time); 
    } 
}
void B_correct()   
{
     SSound(Do);
     delay_ms(30);
    
     SSound(HDo);
     delay_ms(30);
} 
void ADC_Init(void)                
{    
ADCSRA  = 0x00;        // ADC 설정을 위한 비활성화
ADMUX   = ADC_AVCC_TYPE | (0<ADLAR) | (0<<MUX0); 
// REFS1∼0='11', ADLAR=0, MUX=0(ADC0 선택) 
ADCSRA  = (1<<ADEN) | (3<<ADPS0)| (1<<ADFR);      
// 1<<ADEN  : AD변환 활성화 
// 1<<ADFR  : Free Running 모드 활성화 
// 3<<ADPS0 : AC변환 분주비성정 - 8분주.
}

/**
* @brief  Differential ADC 결과 읽어오는 함수 
* @param  adc_input: ADC 하고자 하는 채널의 번호 (8 ~ 0x1F) 
* @retval AD 변환 값( 0 ~ 1023),0v=0,5v=1023 2.5v=512
*/ 
unsigned int Read_ADC_Data_Diff(unsigned char adc_mux)   
{
unsigned int ADC_Data = 0; 
if(adc_mux < 8) return 0xFFFF;                     // 양극신호가 아닌 단극 MUX 입력시 종료
// AD 변환 채널 설정 
ADMUX    &= ~(0x1F);                
ADMUX |= (adc_mux & 0x1F);   
ADCSRA |= (1<<ADSC);             // AD 변환 시작
while(!(ADCSRA & (1 << ADIF)));     // AD 변환 종료 대기
ADC_Data  = ADCL; 
ADC_Data  |= ADCH<<8;
flag+=1;
flag2+=1;
return ADC_Data;

}



int SRF02_I2C_Write(char address, char reg, char data)
{
unsigned int srf02_ErrCnt = 0;
// I2C 시작비트 전송
TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// 통신 시작 대기
while(!(TWCR & (1<<TWINT) )){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// I2C 장비 주소 송신을 위한 적재 및 전송 시작
TWDR = address; // SLA + W
TWCR = (1<<TWINT) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// 레지스터 위치 송신을 위한 적재 및 전송 시작
TWDR = reg;
TWCR = (1<<TWINT) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// 명령(command) 송신을 위한 적재 및 전송 시작
TWDR = data;
TWCR = (1<<TWINT) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// I2C 종료비트 전송
TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN); // stop bit
return 1;
}

unsigned char SRF02_I2C_Read(char address, char reg)
{
char read_data = 0;
unsigned int srf02_ErrCnt = 0;
// I2C 시작비트 전송
TWCR = 0xA4;//TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// 통신 시작 대기
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C 장비 주소(SLA+W) 송신을 위한 적재 및 전송 시작
TWDR = address; // SLA + W
TWCR = 0x84;//TWCR = (1<<TWINT) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// 레지스터 위치 송신을 위한 적재 및 전송 시작
TWDR = reg;
TWCR = (1<<TWINT) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C 재시작을 위한 시작 비트 전송
TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// wait for confirmation of transmit
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C 장비 주소(SLA+R) 송신을 위한 적재 및 전송 시작
TWDR = address +1; // SLA + R
TWCR = (1<<TWINT) | (1<<TWEA) | (1<<TWEN);
// 송신 완료 대기
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// 데이터 수신을 위한 클럭 전송
TWCR = (1<<TWINT) | (1<<TWEN);
// 수신 완료 대기
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// 수신된 데이터 반환 위하여 변수 저장
read_data = TWDR;
// I2C 종료비트 전송
TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN);
// 수신된 데이터 반환
return read_data;
}

void I2C_Init(void)
{
TWBR = 0x40; // 100kHz I2C clock frequency TWI통신속도 레지스터
}

void change_Sonar_Addr(unsigned char ori, unsigned char des)// SFR02 모듈의 주소 바꾸는 함수
{
// ori-> 기존 주소 des-> 바꿀주소
// 어드레스는 아래의 16개만 허용됨
switch(des)
{
case 0xE0:
case 0xE2:
case 0xE4:
case 0xE6:
case 0xE8:
case 0xEA:
case 0xEC:
case 0xEE:
case 0xF0:
case 0xF2:
case 0xF4:
case 0xF6:
case 0xF8:
case 0xFA:
case 0xFC:
case 0xFE:
// ID변경 시퀀스에 따라 기존 센서에 변경명령을 전송
SRF02_I2C_Write(ori,Com_Reg,0xA0);
SRF02_I2C_Write(ori,Com_Reg,0xA5);
SRF02_I2C_Write(ori,Com_Reg,0xAA);
// ID변경 시퀀스에 따라 신규 ID 전달
SRF02_I2C_Write(ori,Com_Reg,des);
break;
}
}

void startRanging(char addr)
{
// Cm 단위로 측정 요청.
    SRF02_I2C_Write(addr, Com_Reg,SRF02_Return_Cm);
}

unsigned int getRange(char addr)
{
unsigned int x;
// Get high and then low bytes of the range
x = SRF02_I2C_Read(addr,2) << 8; // Get high Byte
x += SRF02_I2C_Read(addr,3); // Get low Byte
return (x);
}




void Timer0_Init(){
    TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02); //CTC모드, 1024분주
    TCNT0 = 0x00;
    OCR0 = 14; //14.7456Mhz / 1024분주 / 14단계 = 1.028kHz  //1ms마다 발생
    TIMSK = (1<<OCIE0);// 비교일치 인터럽트 허가
}

/**
* @brief 타이머0 비교일치 인터럽트
*/
interrupt[TIM0_COMP] void timer0_comp(void){
    ti_Cnt_1ms++;
}



void main(void)
{   int adcRaw =0;             // ADC 데이터 저장용 
    float adcmilliVoltage =0;    // ADC 데이터를 전압으로 변환한 데이터 저장용 
    float Celsius = 0;          // 계산된 온도 저장용
    float Celsius_vec[num];//값튀는거 방지 10개 배열 변수 
    float Celsius_vec_temp;   
    float Celsius_median=0;//10개중 5번째 값 저장 하는 변수
    float open_close_Celsius=0;
    float control_celsius=0;//온도지정스위치를 위한 변수   
    int jk=0; 
    int jj=0;
    char Sonar_addr = 0xE0; // 측정하고자 하는 장치 주소
    unsigned int Sonar_range; // 측정 거리를 저장할 변수
    char Message[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수
    char Celsi[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수 
    char control_cel[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수                                                                 
    ADC_Init();  // ADC 초기화 
    LCD_Init(); // LCD 초기화 
    LCD_Clear();
    Timer0_Init(); // 1ms 계수 위한 타이머 초기화
    I2C_Init(); // I2C 통신 초기화( baudrate 설정)
    delay_ms(1000); // SRF02 전원 안정화 시간 대기
    SREG|=0x80; // 타이머 인터럽트 활성화 위한 전역 인터럽트 활성화
    startRanging(Sonar_addr); // 초음파 센서 거리 측정 시작 명령 ()는 0xE0측정하고자 하는 장치 주소
    ti_Cnt_1ms = 0; // 측정시간 대기를 위한 변수 초기화
    Port_init();
    FND_init();//fnd 초기값 00
    while(1)
    {   if(flag !=-1){
        adcRaw     = Read_ADC_Data_Diff(0b1101);    // MUX : 01101 변환 요청 
        // ADC3 : Positive Differential Input
        // ADC2 : Negative Differential Input      
        // 10x GAIN 
        adcmilliVoltage = ( (( (float)adcRaw * 5000) /512) / 10); 
        // 전압으로 변환, VREF = 5000 mV, 10배 증폭비, 차동계측 고려
        Celsius = adcmilliVoltage  / 10;
        if(flag==0){Celsius_vec[0]=Celsius;} //값 튀는거 잡기 위해 10개 배열에 넣고 내림차순 후 중간값 뽑아
        if(flag==1){Celsius_vec[1]=Celsius;}
        if(flag==2){Celsius_vec[2]=Celsius;}
        if(flag==3){Celsius_vec[3]=Celsius;}
        if(flag==4){Celsius_vec[4]=Celsius;}
        if(flag==5){Celsius_vec[5]=Celsius;}
        if(flag==6){Celsius_vec[6]=Celsius;}
        if(flag==7){Celsius_vec[7]=Celsius;}
        if(flag==8){Celsius_vec[8]=Celsius;}
        if(flag==9){Celsius_vec[9]=Celsius;}
        }
        
        for(jk=0;jk<num-1;jk++){       //내림차순 
            for(jj=jk+1;jj<num;jj++){
                if(Celsius_vec[jk]<Celsius_vec[jj]){
                    Celsius_vec_temp=Celsius_vec[jj];
                    Celsius_vec[jj]=Celsius_vec[jk];
                    Celsius_vec[jk]=Celsius_vec_temp;    
                }
            }
        }
        
        if(flag>10){
        Celsius_median=Celsius_vec[num/2];
            if(flag2==11){
            open_close_Celsius=Celsius_median;
            }                                 
        flag=0;
        }
        sprintf(Celsi,"%2.2f",Celsius_median);      //10번 중 5번쨰 디택트 내림차순 정리
        /////////////////////////////////////////////////////////////////
        //온도 지정 과정
         if(PIND.5 == 0) {
            delay_ms(20);
            control_celsius=adcmilliVoltage  / 10;
            delay_ms(500);
            FND_MATCH(control_celsius);
            LCD_Clear();       
            sprintf(control_cel,"%2.2f",control_celsius);
            LCD_Pos(0,0);
            LCD_Str("Celsius Change" );
            LCD_Pos(1,0);
            LCD_Str(control_cel);
            k1++; 
            while(1) {
                if(PIND.5 == 1) {
                  k++; 
                    if(k>=2)k = 0;
                    break;
                }    
           }
         }
       /////////////////////////////////////////////////////////////////  
       //온도 up
        if(k==1){
        
        while(1){
        
            if(PIND.3 == 0) {
                delay_ms(20);
                LCD_Clear();
                control_celsius+=1; 
                sprintf(control_cel,"%2.2f",control_celsius);
                FND_MATCH(control_celsius);
                LCD_Pos(0,0);
                LCD_Str("Celsius Change" );
                LCD_Pos(1,0);
                LCD_Str(control_cel);
                while(1) {
                    if(PIND.3 == 1) {
                    b++;
                        if(b>=2)b = 0;
                        break;
                    }  
                }
            }
           ////온도 down
            if(PIND.4 == 0) {
                delay_ms(20);
                LCD_Clear();                                 
                control_celsius-=1;
                sprintf(control_cel,"%2.2f",control_celsius);
                FND_MATCH(control_celsius);
                LCD_Pos(0,0);
                LCD_Str("Celsius Change" );
                LCD_Pos(1,0);
                LCD_Str(control_cel); 
                while(1) {
                    if(PIND.4 == 1) {
                       n++;    
                        if(n>=2)n = 0;
                        break;
                    }  
                }
            } 
           //온도변환과정 탈
            if(PIND.6==0){k=0;break;}        
        }
        
        } 
        /////////////////////////////////////////////////////////////////
        //인체 디택트+일정 거리 안에 들어오면 open
        if(flag2>12){
        if(Celsius_median< open_close_Celsius+1){ 
        if(PIR_sensor1==1 || PIR_sensor2==1)
        {   
            LCD_Clear();       
            LCD_Pos(0,0);
            LCD_Str("Motion Detect" );
            if(ti_Cnt_1ms > 66)       //0.066초마다 실행
            {    
            // 초음파 센서 거리 측정 데이터 얻기
                Sonar_range = getRange(Sonar_addr);
            // 측정된 거리 LCD 화면에 출력
                sprintf(Message, "%03d cm",Sonar_range);
                
                LCD_Pos(1,0);
                LCD_Str(Message);
                LCD_Pos(1,7);
                LCD_Str(Celsi);               
            // 초음파 센서 거리 측정 시작 명령
                startRanging(Sonar_addr);
            // 대기시간 초기화
                ti_Cnt_1ms = 0;
                delay_ms(100);
               
                if(Sonar_range<50){
                    for(i=0;i<25;i++){servo_motor=1;delay_us(600);servo_motor=0;delay_ms(20);
                    LCD_Pos(0,0);
                    LCD_Str("Open                          ");
                   }  
                    
                }
                      
             }
        }
        }
        }
        //거리 엔디드 문 close
       if(flag2>12){ 
       if(Celsius_median< open_close_Celsius+1){       
        if(PIR_sensor1==0 && PIR_sensor2==0) 
        {  
           LCD_Clear();                    
           LCD_Pos(0,0);
           LCD_Str("Motion Ended");
           LCD_Pos(1,0);
           LCD_Str("Close");
           LCD_Pos(1,7);
           LCD_Str(Celsi);                            
           LCD_Comm(0x0c);
           count++;
           delay_ms(100);    
           if(count>=1){
             for(i=0;i<25;i++){servo_motor=1;delay_us(3300);servo_motor=0;delay_ms(20);}count=0;   
           }  
        }
       }    
       }
    //온돈 변환 과정 실행    
        if(k1>=1){ 
            if(control_celsius> open_close_Celsius ){      
                if(Celsius_median>=control_celsius) {
    
                LCD_Clear();
                delay_ms(30);
                LCD_Pos(0,0);
                LCD_Str("Cooling heat                 ");
                LCD_Pos(1,0);
                LCD_Str(Celsi);
                LCD_Comm(0x0c);                          
                for(i=0;i<25;i++){servo_motor=1;delay_us(600);servo_motor=0;delay_ms(20);}
                delay_ms(30);
                if(PIND.7==0){Celsius_median=0;}
    
                }
            }  
        }
    }
    }
    
            
      
    
    
            

    
    
    
    
    
