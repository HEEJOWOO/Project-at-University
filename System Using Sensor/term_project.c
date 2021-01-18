#include <mega128.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>
#define SRF02_ERR_MAX_CNT 2000
#define SRF02_Return_inch 80
#define SRF02_Return_Cm 81
#define SRF02_Return_microSecond 82
#define ADC_VREF_TYPE 0x00  // A/D ������ ��� ���� ����,AREF ���� ���, ���� VREF ���� ���� 
#define ADC_AVCC_TYPE 0x40 // A/D ������ ��� ���� ����,AVcc���ڿ� ARRE�� ����� Ŀ�н��� ��� 
#define ADC_RES_TYPE  0x80  // A/D ������ ��� ���� ����,reserved 
#define ADC_2_56_TYPE 0xC0  // A/D ������ ��� ���� ����,���� 2.56V�� AREF�� ����� Ŀ�н��� ��� 
#define LCD_WDATA PORTA // LCD ������ ��Ʈ ����
#define LCD_WINST PORTA
#define LCD_CTRL PORTG // LCD ������Ʈ ����
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
unsigned char ti_Cnt_1ms; // 1ms ���� �ð� ��� ���� ���� ��������
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
    tim = 50000/time; //���踶�� ���� �ð����� �︮���� tim ���� ��� 
    for(i=0; i<tim; i++) 
    { 
        PORTG |= 1<<4; //buzzer on, PORTG�� 4�� �� on(out 1) 
        myDelay_us(time); 
        PORTG &= ~(1<<4); //buzzer off, PORTG�� 4�� �� off(out 0) 
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
ADCSRA  = 0x00;        // ADC ������ ���� ��Ȱ��ȭ
ADMUX   = ADC_AVCC_TYPE | (0<ADLAR) | (0<<MUX0); 
// REFS1��0='11', ADLAR=0, MUX=0(ADC0 ����) 
ADCSRA  = (1<<ADEN) | (3<<ADPS0)| (1<<ADFR);      
// 1<<ADEN  : AD��ȯ Ȱ��ȭ 
// 1<<ADFR  : Free Running ��� Ȱ��ȭ 
// 3<<ADPS0 : AC��ȯ ���ֺ��� - 8����.
}

/**
* @brief  Differential ADC ��� �о���� �Լ� 
* @param  adc_input: ADC �ϰ��� �ϴ� ä���� ��ȣ (8 ~ 0x1F) 
* @retval AD ��ȯ ��( 0 ~ 1023),0v=0,5v=1023 2.5v=512
*/ 
unsigned int Read_ADC_Data_Diff(unsigned char adc_mux)   
{
unsigned int ADC_Data = 0; 
if(adc_mux < 8) return 0xFFFF;                     // ��ؽ�ȣ�� �ƴ� �ܱ� MUX �Է½� ����
// AD ��ȯ ä�� ���� 
ADMUX    &= ~(0x1F);                
ADMUX |= (adc_mux & 0x1F);   
ADCSRA |= (1<<ADSC);             // AD ��ȯ ����
while(!(ADCSRA & (1 << ADIF)));     // AD ��ȯ ���� ���
ADC_Data  = ADCL; 
ADC_Data  |= ADCH<<8;
flag+=1;
flag2+=1;
return ADC_Data;

}



int SRF02_I2C_Write(char address, char reg, char data)
{
unsigned int srf02_ErrCnt = 0;
// I2C ���ۺ�Ʈ ����
TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// ��� ���� ���
while(!(TWCR & (1<<TWINT) )){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// I2C ��� �ּ� �۽��� ���� ���� �� ���� ����
TWDR = address; // SLA + W
TWCR = (1<<TWINT) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// �������� ��ġ �۽��� ���� ���� �� ���� ����
TWDR = reg;
TWCR = (1<<TWINT) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// ���(command) �۽��� ���� ���� �� ���� ����
TWDR = data;
TWCR = (1<<TWINT) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
// I2C �����Ʈ ����
TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN); // stop bit
return 1;
}

unsigned char SRF02_I2C_Read(char address, char reg)
{
char read_data = 0;
unsigned int srf02_ErrCnt = 0;
// I2C ���ۺ�Ʈ ����
TWCR = 0xA4;//TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// ��� ���� ���
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C ��� �ּ�(SLA+W) �۽��� ���� ���� �� ���� ����
TWDR = address; // SLA + W
TWCR = 0x84;//TWCR = (1<<TWINT) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// �������� ��ġ �۽��� ���� ���� �� ���� ����
TWDR = reg;
TWCR = (1<<TWINT) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C ������� ���� ���� ��Ʈ ����
TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
// wait for confirmation of transmit
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// I2C ��� �ּ�(SLA+R) �۽��� ���� ���� �� ���� ����
TWDR = address +1; // SLA + R
TWCR = (1<<TWINT) | (1<<TWEA) | (1<<TWEN);
// �۽� �Ϸ� ���
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// ������ ������ ���� Ŭ�� ����
TWCR = (1<<TWINT) | (1<<TWEN);
// ���� �Ϸ� ���
while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
// ���ŵ� ������ ��ȯ ���Ͽ� ���� ����
read_data = TWDR;
// I2C �����Ʈ ����
TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN);
// ���ŵ� ������ ��ȯ
return read_data;
}

void I2C_Init(void)
{
TWBR = 0x40; // 100kHz I2C clock frequency TWI��żӵ� ��������
}

void change_Sonar_Addr(unsigned char ori, unsigned char des)// SFR02 ����� �ּ� �ٲٴ� �Լ�
{
// ori-> ���� �ּ� des-> �ٲ��ּ�
// ��巹���� �Ʒ��� 16���� ����
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
// ID���� �������� ���� ���� ������ �������� ����
SRF02_I2C_Write(ori,Com_Reg,0xA0);
SRF02_I2C_Write(ori,Com_Reg,0xA5);
SRF02_I2C_Write(ori,Com_Reg,0xAA);
// ID���� �������� ���� �ű� ID ����
SRF02_I2C_Write(ori,Com_Reg,des);
break;
}
}

void startRanging(char addr)
{
// Cm ������ ���� ��û.
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
    TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02); //CTC���, 1024����
    TCNT0 = 0x00;
    OCR0 = 14; //14.7456Mhz / 1024���� / 14�ܰ� = 1.028kHz  //1ms���� �߻�
    TIMSK = (1<<OCIE0);// ����ġ ���ͷ�Ʈ �㰡
}

/**
* @brief Ÿ�̸�0 ����ġ ���ͷ�Ʈ
*/
interrupt[TIM0_COMP] void timer0_comp(void){
    ti_Cnt_1ms++;
}



void main(void)
{   int adcRaw =0;             // ADC ������ ����� 
    float adcmilliVoltage =0;    // ADC �����͸� �������� ��ȯ�� ������ ����� 
    float Celsius = 0;          // ���� �µ� �����
    float Celsius_vec[num];//��Ƣ�°� ���� 10�� �迭 ���� 
    float Celsius_vec_temp;   
    float Celsius_median=0;//10���� 5��° �� ���� �ϴ� ����
    float open_close_Celsius=0;
    float control_celsius=0;//�µ���������ġ�� ���� ����   
    int jk=0; 
    int jj=0;
    char Sonar_addr = 0xE0; // �����ϰ��� �ϴ� ��ġ �ּ�
    unsigned int Sonar_range; // ���� �Ÿ��� ������ ����
    char Message[40]; // LCD ȭ�鿡 ���ڿ� ����� ���� ���ڿ� ����
    char Celsi[40]; // LCD ȭ�鿡 ���ڿ� ����� ���� ���ڿ� ���� 
    char control_cel[40]; // LCD ȭ�鿡 ���ڿ� ����� ���� ���ڿ� ����                                                                 
    ADC_Init();  // ADC �ʱ�ȭ 
    LCD_Init(); // LCD �ʱ�ȭ 
    LCD_Clear();
    Timer0_Init(); // 1ms ��� ���� Ÿ�̸� �ʱ�ȭ
    I2C_Init(); // I2C ��� �ʱ�ȭ( baudrate ����)
    delay_ms(1000); // SRF02 ���� ����ȭ �ð� ���
    SREG|=0x80; // Ÿ�̸� ���ͷ�Ʈ Ȱ��ȭ ���� ���� ���ͷ�Ʈ Ȱ��ȭ
    startRanging(Sonar_addr); // ������ ���� �Ÿ� ���� ���� ��� ()�� 0xE0�����ϰ��� �ϴ� ��ġ �ּ�
    ti_Cnt_1ms = 0; // �����ð� ��⸦ ���� ���� �ʱ�ȭ
    Port_init();
    FND_init();//fnd �ʱⰪ 00
    while(1)
    {   if(flag !=-1){
        adcRaw     = Read_ADC_Data_Diff(0b1101);    // MUX : 01101 ��ȯ ��û 
        // ADC3 : Positive Differential Input
        // ADC2 : Negative Differential Input      
        // 10x GAIN 
        adcmilliVoltage = ( (( (float)adcRaw * 5000) /512) / 10); 
        // �������� ��ȯ, VREF = 5000 mV, 10�� ������, �������� ���
        Celsius = adcmilliVoltage  / 10;
        if(flag==0){Celsius_vec[0]=Celsius;} //�� Ƣ�°� ��� ���� 10�� �迭�� �ְ� �������� �� �߰��� �̾�
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
        
        for(jk=0;jk<num-1;jk++){       //�������� 
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
        sprintf(Celsi,"%2.2f",Celsius_median);      //10�� �� 5���� ����Ʈ �������� ����
        /////////////////////////////////////////////////////////////////
        //�µ� ���� ����
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
       //�µ� up
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
           ////�µ� down
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
           //�µ���ȯ���� Ż
            if(PIND.6==0){k=0;break;}        
        }
        
        } 
        /////////////////////////////////////////////////////////////////
        //��ü ����Ʈ+���� �Ÿ� �ȿ� ������ open
        if(flag2>12){
        if(Celsius_median< open_close_Celsius+1){ 
        if(PIR_sensor1==1 || PIR_sensor2==1)
        {   
            LCD_Clear();       
            LCD_Pos(0,0);
            LCD_Str("Motion Detect" );
            if(ti_Cnt_1ms > 66)       //0.066�ʸ��� ����
            {    
            // ������ ���� �Ÿ� ���� ������ ���
                Sonar_range = getRange(Sonar_addr);
            // ������ �Ÿ� LCD ȭ�鿡 ���
                sprintf(Message, "%03d cm",Sonar_range);
                
                LCD_Pos(1,0);
                LCD_Str(Message);
                LCD_Pos(1,7);
                LCD_Str(Celsi);               
            // ������ ���� �Ÿ� ���� ���� ���
                startRanging(Sonar_addr);
            // ���ð� �ʱ�ȭ
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
        //�Ÿ� ����� �� close
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
    //�µ� ��ȯ ���� ����    
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
    
            
      
    
    
            

    
    
    
    
    
