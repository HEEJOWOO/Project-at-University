#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <signal.h>
#define MOTOR_ATTRIBUTE_ERROR_RANGE 4
#define FPGA_STEP_MOTOR_DEVICE "/dev/fpga_step_motor"
#define BUZZER_DEVICE "/dev/fpga_buzzer"
void usage(char* dev_info);
unsigned char quit = 0;
void user_signal1(int sig)
{
	quit = 1;
}
int main(int argc, char **argv)
{
	int i;
	int dev3;
	int str_size;
	int motor_action;
	int motor_direction;
	int motor_speed;
	int dev1;
	unsigned char state=0;
	unsigned char motor_state[3];
	unsigned char retval;
	unsigned char data;
	memset(motor_state,0,sizeof(motor_state));
	if(argc!=4) {
	printf("Please input the parameter! \n");
	usage(argv[0]);
	return -1;
	}
	motor_action = atoi(argv[1]);
	if(motor_action<0||motor_action>1) {
		printf("Invalid motor action!\n");
		usage(argv[0]);
		return -1;
	}
	motor_direction = atoi(argv[2]);
	if(motor_direction<0||motor_direction>1) {
		printf("Invalid motor direction!\n");
		usage(argv[0]);
		return -1;
	}
	motor_speed = atoi(argv[3]);
	if(motor_speed<0||motor_speed>255) {
		printf("Invalid motor speed!\n");
		usage(argv[0]);
		return -1;
	}
	motor_state[0]=(unsigned char)motor_action;
	motor_state[1]=(unsigned char)motor_direction;
	if(motor_state[1]==1){
	dev1=1;
	}
	if(motor_state[1]==0){
	dev1=0;
	}
	motor_state[2]=(unsigned char)motor_speed;
	dev3 = open(FPGA_STEP_MOTOR_DEVICE, O_WRONLY);
	if (dev3<0) {
		printf("Device open error : %s\n",FPGA_STEP_MOTOR_DEVICE);
	exit(1);
	}
	write(dev3,motor_state,3);
	close(dev3);
	if(dev1==1){
	dev1 = open(BUZZER_DEVICE, O_RDWR);
	if (dev1<0) {
	printf("Device open error : %s\n",BUZZER_DEVICE);
	exit(1);
	}
	(void)signal(SIGINT, user_signal1);
	printf("Press <ctrl+c> to exit.\n");
	while(!quit) {
	if(state!=0) {
	state=0;
	data=1;
	retval=write(dev3,&data,1);
	if(retval<0) {
	printf("Write Error!\n");
	return -1;
	}
	} else {
	state=1;
	data=0;
	retval=write(dev1,&data,1);
	if(retval<0) {
	printf("Write Error!\n");
	return -1;
	}
	}
	sleep(1);
	}
	printf("Current Buzzer Value : %d\n",data);
	close(dev1);
	
	}
	return 0;
	}
void usage(char* dev_info)
{
printf("<Usage> %s [Motor Action] [Motor Diretion] [Speed]\n",dev_info);
printf("Motor Action : 0 - Stop / 1 - Start\n");
printf("Motor Direction : 0 - Left / 1 - Right\n");
printf("Motor Speed : 0(Fast) ~ 250(Slow)\n");
printf("ex) %s 1 0 10\n",dev_info);
}
