#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <math.h>
#include <time.h>
#include "./fpga_dot_font.h"
#include <iostream>
#include <sys/mman.h>
#include <cstring>
#include <linux/fb.h>
#include <opencv2/core/core_c.h>
#include <opencv2/imgproc/imgproc_c.h>
#include <opencv2/highgui/highgui_c.h>

//cv
#define  FBDEV                      "/dev/fb0"
#define  CAMERA_COUNT    100
#define  CAM_WIDTH             640
#define  CAM_HEIGHT           480


#define MAX_DIGIT 4
#define FND_DEVICE "/dev/fpga_fnd"
#define FPGA_DOT_DEVICE "/dev/fpga_dot"
#define MAX_BUTTON 9
#define BUZZER_DEVICE "/dev/fpga_buzzer"
#define MOTOR_ATTRIBUTE_ERROR_RANGE 4
#define FPGA_STEP_MOTOR_DEVICE "/dev/fpga_step_motor"
#define LED_DEVICE "/dev/fpga_led"
#define MAX_BUFF 32
#define LINE_BUFF 16
#define FPGA_TEXT_LCD_DEVICE "/dev/fpga_text_lcd"


char string[32];
unsigned char quit = 0;
char *M_W = "Machine Working!";
char *M_S = "Machine Stop!";
char *End = "Bye Bye!!";
char *blank = " ";
char *M = "Machine";
char *speedup = "Speed Up";
char *speeddown = "Speed Down";
char *waring = "Waring!!";
char *H_D = "Human Detected!";
char *fire = "Fire!!";
char *F_T = "Fire Time";
char *D_T = "Detected Time";
char D_time[16];
char F_time[16];
int count=0;
int dev_lcd_top;
int dev_lcd_bottom;
int step_motor_button;
unsigned char motor_state[3];
int led_control;
unsigned char led_data;
int end;
int dev_fnd;
char data[4];

void swaptime(time_t, char *);


void swaptime(time_t org_time, char *time_str){		//시간정보
   struct tm *tm_ptr;
   tm_ptr = gmtime(&org_time);
   sprintf(time_str, "  %02d-%02d %02d:%02d:%02d",
      tm_ptr->tm_mon + 1,
      tm_ptr->tm_mday,
      tm_ptr->tm_hour,
      tm_ptr->tm_min,
      tm_ptr->tm_sec);
}

      
void user_signal1(int sig)
{
    quit = 1;
}



void lcd_print_top(char *str1) {		//LCD 윗줄 출력
   int str_size;   
   str_size = strlen(str1);
   if (str_size>0) {
      strncat(string, str1, str_size);
      memset(string + str_size, ' ', LINE_BUFF - str_size);
   }
}
void lcd_print_bottom(char *str2) {		//LCD 밑줄 출력
   int str_size;
   str_size = strlen(str2);
   if (str_size>0) {
      strncat(string, str2, str_size);
      memset(string + LINE_BUFF + str_size, ' ', LINE_BUFF - str_size);
   }
}
void waring_human(){		//인체감지 경보 및 알림
   int i;
   int dev_dot;
   int dev_buzzer;
   int str_size;
   unsigned char buzzer_state=0;
   unsigned char buzzer_retval;
   unsigned char buzzer_data1=1;
   unsigned char buzzer_data2=0;

   dev_dot = open(FPGA_DOT_DEVICE, O_WRONLY);
   dev_buzzer = open(BUZZER_DEVICE, O_RDWR);
   str_size=sizeof(fpga_human);
   (void)signal(SIGINT, user_signal1);
       for(i=0; i<3; i++){
      buzzer_retval=write(dev_buzzer,&buzzer_data1,1);
      write(dev_dot,fpga_human,str_size);
      usleep(500000);
      buzzer_retval=write(dev_buzzer,&buzzer_data2,1);
      write(dev_dot,fpga_set_blank,sizeof(fpga_set_blank));
      usleep(500000);
       }
   close(dev_dot);
   close(dev_buzzer);
}
void waring_fire(){		 //화재감지 경보 및 알림
   int i;
   int dev_dot;
   int dev_buzzer;
   int str_size;
   unsigned char buzzer_state=0;
   unsigned char buzzer_retval;
   unsigned char buzzer_data1=1;
   unsigned char buzzer_data2=0;

   dev_dot = open(FPGA_DOT_DEVICE, O_WRONLY);
   dev_buzzer = open(BUZZER_DEVICE, O_RDWR);
   str_size=sizeof(fpga_fire);
   (void)signal(SIGINT, user_signal1);
       for(i=0; i<3; i++){
      buzzer_retval=write(dev_buzzer,&buzzer_data1,1);
      write(dev_dot,fpga_fire,str_size);
      usleep(500000);
      buzzer_retval=write(dev_buzzer,&buzzer_data2,1);
      write(dev_dot,fpga_set_blank,sizeof(fpga_set_blank));
      usleep(500000);
       }
   close(dev_dot);
   close(dev_buzzer);
}

void write_every(){
   write(led_control,&led_data,1);    
   write(dev_lcd_top, string, MAX_BUFF);
   write(dev_lcd_bottom, string, MAX_BUFF);
   write(step_motor_button,motor_state,3);
   
   write(dev_fnd,&data,4);
}
int main()
{
   
   int i;
   int fd_us;   
   int fd_pir1;
   int fd_pir2;
   int fd_fire;
    char buf_pir1[10] = {0};
   char buf_pir2[10] = {0};
    char buf_fire[10] = {0};
   char buf_us[10] = {0};
   int dev_push;
   int a=0;
   int b=0;
   int buff_size;
   int f_count=0;
   int d_count=0;
   int chk_size;
   int motor_action;
   int motor_direction;
   int motor_speed;
   char buf_time[255];
   
   memset(motor_state,0,sizeof(motor_state));
   unsigned char state=0;
   unsigned char push_sw_buff[MAX_BUTTON];


   int fbfd;
    /* 프레임버퍼 정보 처리를 위한 구조체 */
    struct fb_var_screeninfo vinfo;
    struct fb_fix_screeninfo finfo;

    unsigned char *buffer, rr, gg, bb;
    unsigned int xx, yy, tt, ii, screensize;
    unsigned short *pfbmap, *pOutdata, pixel;
    CvCapture* capture;                                       /* 카메라를 위한 변수 */ 
    IplImage *frame; 






   dev_fnd=open(FND_DEVICE,O_RDWR);
   data[0]=0;
   data[1]=0;
   data[2]=0;
   data[3]=0;
   write(dev_fnd,&data,4);
   motor_action = 0;
   motor_direction = 0;
   motor_speed = 5;
   motor_state[0]=(unsigned char)motor_action;
   motor_state[1]=(unsigned char)motor_direction;
   motor_state[2]=(unsigned char)motor_speed;
   dev_push = open("/dev/fpga_push_switch", O_RDWR);
   dev_lcd_top = open(FPGA_TEXT_LCD_DEVICE, O_WRONLY);
   dev_lcd_bottom = open(FPGA_TEXT_LCD_DEVICE, O_WRONLY);
   led_control=open(LED_DEVICE,O_RDWR);
   step_motor_button = open(FPGA_STEP_MOTOR_DEVICE, O_WRONLY);
   fd_pir1 = open("/dev/ext_pir1_sens", O_RDWR);
   fd_pir2 = open("/dev/ext_pir2_sens", O_RDWR);
   fd_fire = open("/dev/ext_fire_sens", O_RDWR);
   fd_us = open("/dev/us", O_RDWR);
   
   buff_size=sizeof(push_sw_buff);
   for(i=0;i<sizeof(data);i++)   
      printf("%c",data[i]);
   printf("Press <ctrl+c> to quit. \n");

   pid_t pid;
   pid = fork();
   if(pid==-1){
      perror("fork error\n");
      exit(0);
   }
    else if (pid ==0){
      while (!quit) {
         capture = cvCaptureFromCAM(2);
         cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH, CAM_WIDTH);
         cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT, CAM_HEIGHT);
         fbfd = open(FBDEV, O_RDWR);

         if (ioctl(fbfd, FBIOGET_VSCREENINFO, &vinfo) == -1) {
            perror("Error reading variable information.");
            exit(EXIT_FAILURE);
         }

         screensize = vinfo.xres * vinfo.yres * 2;
         pfbmap = (unsigned short *)mmap(NULL, screensize, PROT_READ | PROT_WRITE,
            MAP_SHARED, fbfd, 0);
         if ((int)pfbmap == -1) {
            perror("mmap() : framebuffer device to memory");
            return EXIT_FAILURE;
         }
         memset(pfbmap, 0, screensize);

         /* 출력할 영상을 위한 공간 확보 */
         pOutdata = (unsigned short*)malloc(screensize);
         memset(pOutdata, 0, screensize);
         while (1) {
            cvGrabFrame(capture);                          /* 카메라로 부터 한장의 영상을 가져온다. */
            frame = cvRetrieveFrame(capture);        /* 카메라 영상에서 이미지 데이터를 획득 */
            buffer = (uchar*)frame->imageData;       /* IplImage 클래스의 영상 데이터 획득 */

                                           /* 프레임 버퍼로 출력 */
            for (xx = 0; xx < frame->height; xx++) {
               tt = xx * frame->width;
               for (yy = 0; yy < frame->width; yy++) {
                  rr = *(buffer + (tt + yy) * 3 + 2);
                  gg = *(buffer + (tt + yy) * 3 + 1);
                  bb = *(buffer + (tt + yy) * 3 + 0);
                  pixel = ((rr >> 3) << 11) | ((gg >> 2) << 5) | (bb >> 3);

                  pOutdata[yy + tt + (vinfo.xres - frame->width)*xx] = pixel;
               }
            }

            memcpy(pfbmap, pOutdata, screensize);
         };

      }
      munmap(pfbmap, frame->width*frame->height * 2);
      free(pOutdata);

      close(fbfd);
   }
   else{
      while(!quit){
         usleep(400000);
         read(fd_pir1,buf_pir1,10);
         read(fd_pir2,buf_pir2,10);
         read(fd_fire, buf_fire, 10);
         read(dev_push, &push_sw_buff, buff_size);
         read(fd_us,buf_us,2);
         memset(string,0,sizeof(string));   
         //write_every();
         time_t the_time;
         time(&the_time);
         memset(buf_time, 0x00, 255);
         swaptime(the_time, buf_time);
         lcd_print_top(blank);
         lcd_print_bottom(buf_time);
         write(dev_lcd_top, string, MAX_BUFF);
         write(dev_lcd_bottom, string, MAX_BUFF);
	 if (((buf_pir1[0] == '1') || (buf_pir2[0] == '1')) && (buf_us[0]<20)) {       // PIR센서 두개 중 하나가 감지되고 초음파 측정거리가 20센치 미만이어야 인체감지로 판별
            if (motor_state[0] == 0) {
            }
            else {
               memset(string, 0, sizeof(string));
               lcd_print_top(waring);
               lcd_print_bottom(H_D);
               motor_state[0] = 0;
               led_data = 0;
               strcpy(D_time, buf_time);
               d_count++;
               data[0] = d_count;
               data[2] = 0;
               data[3] = 0;
               write_every();
               waring_human();
               count = 0;
            }
         }

         if (buf_fire[0] == '0') {         // 화재감지
            memset(string, 0, sizeof(string));
            lcd_print_top(waring);
            lcd_print_bottom(fire);
            motor_state[0] = 0;
            led_data = 0;
            strcpy(F_time, buf_time);
            f_count++;
            data[1] = f_count;
            data[2] = 0;
            data[3] = 0;
            write_every();
            waring_fire();
            count = 0;
         }
         if ((push_sw_buff[3] ==1) && (push_sw_buff[8] == 1)) {// 3번 버튼과 8번 버튼 두개를 동시에 눌러서 종료
            memset(data,0,sizeof(data));
            memset(string,0,sizeof(string));         
            lcd_print_top(End);
            lcd_print_bottom(blank);
            motor_state[0]=0;
            led_data=0;
            write_every();
            sleep(3);
            memset(string,0,sizeof(string));
            lcd_print_top("I LOVE");
            lcd_print_bottom("      JSM");
            write_every();
            usleep(100000);      
            memset(string,0,sizeof(string));            
            write_every();
            exit(0);      
         }         
         if ( push_sw_buff[1] == 1) {	// 1번 버튼을 눌러서 기계 작동
            memset(string,0,sizeof(string));
            lcd_print_top(M_W);
            lcd_print_top(buf_time);   
            motor_state[0]=1;
            motor_state[1]=0;
            motor_state[2]=10;
            led_data=15;
            count=4;
            data[3]=1;
            data[2]=count;
            write_every();
            
         }
         
         if(push_sw_buff[2]==1){    // 2번 버튼을 눌러서 기계 정지
            memset(string,0,sizeof(string));
            lcd_print_top(M_S);
            lcd_print_top(buf_time);
            motor_state[0]=0;
            led_data=0;
            data[2]=0;
            data[3]=0;
            write_every();
            count=0;
         }
         
        
         if (push_sw_buff[4] == 1) { // 4번 버튼을 누르면 속도 증가
            memset(string,0,sizeof(string));
            if(count==8){
               lcd_print_top("Top Speed!");
               lcd_print_bottom(blank);            
            }else if(count==0){
               lcd_print_top("Machine");            
               lcd_print_bottom("Not Working!!");
            }else{ 
               lcd_print_top(M);
               lcd_print_bottom(speedup);
               led_data=led_data + pow(2,count++);
               if(count>8) count=8;
               if(led_data>=255) led_data=255;    
               data[2]=count;
            }   
            motor_state[2]-=2;
            if(motor_state[2]<=2) motor_state[2]=2;
            write_every();
            sleep(1);
         }   
         if (push_sw_buff[6] == 1) {// 6번 버튼을 누르면 최근 인체감지 시간 확인
            memset(string,0,sizeof(string));
            lcd_print_top(D_T);   
            if(d_count==0) lcd_print_bottom("No data");
            else lcd_print_bottom(D_time);         
            write(dev_lcd_top, string, MAX_BUFF);
            write(dev_lcd_bottom, string, MAX_BUFF);
            
            sleep(5);
         }
         if (push_sw_buff[7] == 1) {// 7번 버튼을 누르면 최근 화재감지 시간 확인
            memset(string,0,sizeof(string));
            lcd_print_top(F_T);   
            if(f_count==0) lcd_print_bottom("No data");
            else lcd_print_bottom(F_time);      
            write(dev_lcd_top, string, MAX_BUFF);
            write(dev_lcd_bottom, string, MAX_BUFF);   
            sleep(5);
               
         }
         if (push_sw_buff[5] == 1) {// 5번 버튼을 누르면 속도 감소
            memset(string,0,sizeof(string));
            if(count>1){
               lcd_print_top(M);
               lcd_print_bottom(speeddown);
               led_data=led_data - pow(2,--count);
               if(count<2) count=1;
               if(led_data<=0) led_data=1;   
               data[2]=count;            
            }else if(count==0){
               lcd_print_top("Machine");            
               lcd_print_bottom("Not Working!!");
               
            }else{
               lcd_print_top("Lowest Speed!");
               lcd_print_bottom(blank);
            }
            motor_state[2]+=2;   
            if(motor_state[2]>=16) motor_state[2]=16;
            write_every();
            sleep(1);
         }
         
         
      }
      close(fd_pir1);
      close(fd_pir2);
      close(fd_fire);
      close(dev_push);
      close(dev_lcd_top);
      close(dev_lcd_bottom);
   }
return 0;
}
