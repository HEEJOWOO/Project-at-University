/* FPGA TEXT_LCD Ioremap Control
FILE : fpga_text_lcd_driver.c
AUTH : largest@huins.com */
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/platform_device.h>
#include <linux/delay.h>
#include <asm/io.h>
#include <asm/uaccess.h>
#include <linux/kernel.h>
#include <linux/ioport.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/version.h>
#define IOM_FPGA_TEXT_LCD_MAJOR 263
#define IOM_FPGA_TEXT_LCD_NAME "fpga_text_lcd"
#define IOM_FPGA_TEXT_LCD_ADDRESS 0x08000090
static int fpga_text_lcd_port_usage = 0;
static unsigned char *iom_fpga_text_lcd_addr;
ssize_t iom_fpga_text_lcd_write(struct file *inode, const char *gdata, size_t
length, loff_t *off_what);
int iom_fpga_text_lcd_open(struct inode *minode, struct file *mfile);
int iom_fpga_text_lcd_release(struct inode *minode, struct file *mfile);
struct file_operations iom_fpga_text_lcd_fops =
{
	owner: THIS_MODULE,
	open: iom_fpga_text_lcd_open,
	write: iom_fpga_text_lcd_write,
	release: iom_fpga_text_lcd_release,
};
int iom_fpga_text_lcd_open(struct inode *minode, struct file *mfile)
{
	if(fpga_text_lcd_port_usage != 0) return -EBUSY;
	fpga_text_lcd_port_usage = 1;
	return 0;
}
int iom_fpga_text_lcd_release(struct inode *minode, struct file *mfile)
{
	fpga_text_lcd_port_usage = 0;
	return 0;
}
ssize_t iom_fpga_text_lcd_write(struct file *inode, const char *gdata, size_t
length, loff_t *off_what)
{
	int i;
	unsigned short int _s_value = 0;
	unsigned char value[33];
	const char *tmp = gdata;
	if (copy_from_user(&value, tmp, length))
		return -EFAULT;
	//value[length]=0;
	printk("Get Size : %d / String : %s\n",length,value);
	for(i=0;i<length;i++)
 {
	 _s_value = (value[i] & 0xFF) << 8 | (value[i + 1] & 0xFF);
	outw(_s_value,(unsigned int)iom_fpga_text_lcd_addr+i);
	 i++;
 }
	return length;
}
int __init iom_fpga_text_lcd_init(void)
{
	int result;
	result = register_chrdev(IOM_FPGA_TEXT_LCD_MAJOR,IOM_FPGA_TEXT_LCD_NAME, &iom_fpga_text_lcd_fops);
	if(result < 0) {
		printk(KERN_WARNING"Can't get any major\n");
		return result;
}
	iom_fpga_text_lcd_addr = ioremap(IOM_FPGA_TEXT_LCD_ADDRESS, 0x32);
	printk(KERN_WARNING"init module, %s major number : %d\n",
IOM_FPGA_TEXT_LCD_NAME, IOM_FPGA_TEXT_LCD_MAJOR);
return 0;
}
void __exit iom_fpga_text_lcd_exit(void)
{
	iounmap(iom_fpga_text_lcd_addr);
	unregister_chrdev(IOM_FPGA_TEXT_LCD_MAJOR,IOM_FPGA_TEXT_LCD_NAME);
}
module_init(iom_fpga_text_lcd_init);
module_exit(iom_fpga_text_lcd_exit)
