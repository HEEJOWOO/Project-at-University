obj-m := fpga_push_switch_driver.o fpga_buzzer_driver.o fpga_step_motor_driver.o fpga_led_driver.o fpga_text_lcd_driver.o fpga_fnd_driver.o fpga_dot_driver.o
obj-m += ext_pir1_sensor_driver.o ext_pir2_sensor_driver.o ext_fire_sensor_driver.o hc-sr04_driver.o

KDIR:=/root/work/achroimx6q/kernel
PWD:=$(shell pwd)
APP:=fpga_test_push
all: driver app
	make -C $(KDIR) SUBDIRS=$(PWD) modules	
driver:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
app:
	arm-none-linux-gnueabi-g++ -I/root/work/OPENCV/opencv-2.4.13/build/install/include -L/root/work/OPENCV/opencv-2.4.13/build/install/lib fpga_test_push.c -lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_gpu -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_nonfree -lopencv_objdetect -lopencv_ocl -lopencv_photo -lopencv_stitching -lopencv_superres -lopencv_ts -lopencv_video -lopencv_videostab -lrt -lpthread -lm -ldl -o fpga_test_push
	arm-none-linux-gnueabi-gcc ext_pir2_sensor_app.c -o ext_pir2_sens_test -static
	arm-none-linux-gnueabi-gcc ext_pir1_sensor_app.c -o ext_pir1_sens_test -static
	arm-none-linux-gnueabi-gcc ext_fire_sensor_app.c -o ext_fire_sens_test -static
install:
	cp -a fpga_push_switch_driver.ko /root/work
	cp -a fpga_test_push /root/work
	cp -a fpga_buzzer_driver.ko /root/work
	cp -a fpga_step_motor_driver.ko /root/work
	cp -a fpga_led_driver.ko /root/work
	cp -a fpga_text_lcd_driver.ko /root/work
	cp -a fpga_fnd_driver.ko /root/work
	cp -a fpga_dot_driver.ko /root/work
	cp -a ext_fire_sensor_driver.ko /root/work
	cp -a ext_pir1_sensor_driver.ko /root/work
	cp -a ext_pir2_sensor_driver.ko /root/work
	cp -a hc-sr04_driver.ko /root/work

clean:
	rm -rf *.ko
	rm -rf *.mod.*
	rm -rf *.o
	rm -rf $(APP)
	rm -rf .*.cmd
	rm -rf Module.symvers
	rm -rf modules.order
	rm -rf .tmp*
	rm -rf .fpga*
	rm -rf fpga_test_buzzer
	rm -rf .buzzer*
	rm -rf .fnd*
	rm -rf ext_pir1_sens_test
	rm -rf ext_pir2_sens_test
	rm -rf ext_fire_sens_test
	rm -rf us_test
