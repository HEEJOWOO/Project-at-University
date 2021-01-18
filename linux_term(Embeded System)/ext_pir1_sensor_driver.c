/* Achro-i.MX6Q ext_pir1ernal Sensor GPIO Control
FILE : ext_pir1_sensor_driver.c
AUTH : gmlee@huins.com */
#include <linux/gpio.h>
#include <linux/uaccess.h>
#include <linux/input.h>
#include <linux/kdev_t.h>
#include <linux/cdev.h>
#define GPIO_DATA IMX_GPIO_NR(2,0)


static int ext_pir1_sensor_open(struct inode *inode, struct file *file);
static int ext_pir1_sensor_release(struct inode *inode, struct file *file);
static int ext_pir1_sensor_read(struct file *filp, char *buf, size_t count, loff_t *f_pos);
static int ext_pir1_sensor_init(void);
static void ext_pir1_sensor_exit(void);
static int ext_pir1_sensor_register_cdev(void);
static int ext_pir1_major = 0, ext_pir1_minor = 0;
static dev_t ext_pir1_sensor_dev;
static struct cdev ext_pir1_sensor_cdev;
static int ext_pir1_sensor_open(struct inode *inode, struct file *file)
{
printk(KERN_ALERT "< pir1_Device has been opened > \n");
return 0;
}
static int ext_pir1_sensor_release(struct inode *inode, struct file *file)
{
printk(KERN_ALERT "< pir1_Device has been closed > \n");
return 0;
}
static int ext_pir1_sensor_read(struct file *filp, char *buf, size_t count, loff_t *f_pos)
{
int res;
char data[10] = {0};
res = gpio_get_value(GPIO_DATA);
sprintf(data,"%d",res);
res = copy_to_user(buf,&data,count);
return 0;
}
struct file_operations ext_pir1_sensor_fops = {
.open = ext_pir1_sensor_open,
.release = ext_pir1_sensor_release,
.read = ext_pir1_sensor_read,
};
static int ext_pir1_sensor_init(void)
{
int result = 0;
printk(KERN_ALERT "< ext_pir1 Sensor Module is up > \n");
if((result = ext_pir1_sensor_register_cdev())<0){
printk(KERN_ALERT "< ext_pir1 Sensor Register Fail > \n");
return result;
}

result = gpio_request(GPIO_DATA,"DATA_PIN");
if(result != 0 ){
	printk(KERN_ALERT "< DATA_PIN Request Fail > \n");
	return -1;
}
result = gpio_direction_input(GPIO_DATA);
 if (result != 0) {
 	printk(KERN_ALERT "< DATA_PIN Configure set Fail > \n");
 	return -1;
}



return 0;
}
static void ext_pir1_sensor_exit(void)
{
printk(KERN_ALERT "< ext_pir1 Sensor Module is down > \n");
gpio_free(GPIO_DATA);
cdev_del(&ext_pir1_sensor_cdev);
unregister_chrdev_region(ext_pir1_sensor_dev,1);
}
static int ext_pir1_sensor_register_cdev(void)
{
int error;
if(ext_pir1_major){
ext_pir1_sensor_dev = MKDEV(ext_pir1_major, ext_pir1_minor);
error = register_chrdev_region(ext_pir1_sensor_dev,1,"ext_pir1_sensor");
}else{
error = alloc_chrdev_region(&ext_pir1_sensor_dev,ext_pir1_minor,1,"ext_pir1_sensor");
ext_pir1_major = MAJOR(ext_pir1_sensor_dev);
}
if(error<0){
printk(KERN_WARNING "ext_pir1_sensor : can't get major %d\n", ext_pir1_major);
return -1;
}
printk(KERN_ALERT "major number = %d\n", ext_pir1_major);
cdev_init(&ext_pir1_sensor_cdev, &ext_pir1_sensor_fops);
ext_pir1_sensor_cdev.owner = THIS_MODULE;
ext_pir1_sensor_cdev.ops = &ext_pir1_sensor_fops;
error = cdev_add(&ext_pir1_sensor_cdev, ext_pir1_sensor_dev,1);
if(error){
printk(KERN_NOTICE "ext_pir1 sensor Register Error %d\n", error);
}
return 0;
}
MODULE_AUTHOR("gunmin, lee <gmlee@huins.com>");
MODULE_DESCRIPTION("HUINS ext_pir1 sensor Device Driver");
MODULE_LICENSE("GPL");
module_init(ext_pir1_sensor_init);
module_exit(ext_pir1_sensor_exit);
