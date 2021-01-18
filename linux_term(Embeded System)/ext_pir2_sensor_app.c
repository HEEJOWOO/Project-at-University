/* Achro-i.MX6Q External Sensor Test Application
File : ext_sensor_app.c
Auth : gmlee@huins.com */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
int main(void)
{
 int fd;
 int retn;
 char buf[10] = {0};
 int loop = 0;
 fd = open("/dev/ext_pir2_sens", O_RDWR);
 printf("fd = %d\n", fd);
 if(fd<0){
 perror("/dev/ext_pir2_sens error");
 exit(-1);
 }else{
 printf("< ext_pir2_sens device has been detected >\n");
 }
while(1){
	read(fd,buf,10);
	if(buf[0] == '1')
	{
		printf("< Detected >\n");
	}
 	sleep(1);
}
close(fd);
return 0;
}
