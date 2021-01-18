
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 14.745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _key=R5
	.DEF _count1=R6
	.DEF _PIR_Status=R8
	.DEF _ii=R4
	.DEF _count=R10
	.DEF _i=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0xC:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0xD:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0xE:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9
_0x71:
	.DB  0xE0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0
_0xCA:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x25,0x32,0x2E,0x32,0x66,0x0,0x43,0x65
	.DB  0x6C,0x73,0x69,0x75,0x73,0x20,0x43,0x68
	.DB  0x61,0x6E,0x67,0x65,0x0,0x4D,0x6F,0x74
	.DB  0x69,0x6F,0x6E,0x20,0x44,0x65,0x74,0x65
	.DB  0x63,0x74,0x0,0x25,0x30,0x33,0x64,0x20
	.DB  0x63,0x6D,0x0,0x4F,0x70,0x65,0x6E,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x4D,0x6F,0x74,0x69,0x6F,0x6E
	.DB  0x20,0x45,0x6E,0x64,0x65,0x64,0x0,0x43
	.DB  0x6C,0x6F,0x73,0x65,0x0,0x43,0x6F,0x6F
	.DB  0x6C,0x69,0x6E,0x67,0x20,0x68,0x65,0x61
	.DB  0x74,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _seg_pat
	.DW  _0xC*2

	.DW  0x0A
	.DW  _seg_pat1
	.DW  _0xD*2

	.DW  0x0A
	.DW  _match
	.DW  _0xE*2

	.DW  0x0F
	.DW  _0x8A
	.DW  _0x0*2+6

	.DW  0x0F
	.DW  _0x8A+15
	.DW  _0x0*2+6

	.DW  0x0F
	.DW  _0x8A+30
	.DW  _0x0*2+6

	.DW  0x0E
	.DW  _0x8A+45
	.DW  _0x0*2+21

	.DW  0x1F
	.DW  _0x8A+59
	.DW  _0x0*2+43

	.DW  0x0D
	.DW  _0x8A+90
	.DW  _0x0*2+74

	.DW  0x06
	.DW  _0x8A+103
	.DW  _0x0*2+87

	.DW  0x1E
	.DW  _0x8A+109
	.DW  _0x0*2+93

	.DW  0x0A
	.DW  0x04
	.DW  _0xCA*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>

	.CSEG
_LCD_Data:
;	ch -> Y+0
	LDS  R30,101
	ORI  R30,4
	CALL SUBOPT_0x0
	ANDI R30,0xFD
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	RJMP _0x20A0009
_LCD_Comm:
;	command -> Y+0
	LDS  R30,101
	ANDI R30,0xFB
	CALL SUBOPT_0x0
	ANDI R30,0xFD
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	RJMP _0x20A0009
_LCD_Delay:
;	ms -> Y+0
	LD   R30,Y
	LDI  R31,0
	CALL SUBOPT_0x2
	RJMP _0x20A0009
_LCD_Char:
;	ch -> Y+0
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LCD_Delay
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_Data
	RJMP _0x20A0009
_LCD_Str:
;	*str -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	ST   -Y,R30
	RCALL _LCD_Char
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x3
_0x5:
	RJMP _0x20A000B
_LCD_Pos:
;	x -> Y+1
;	y -> Y+0
	LDD  R30,Y+1
	LDI  R26,LOW(64)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LCD_Comm
	RJMP _0x20A000B
_LCD_Clear:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3
	RET
_LCD_PORT_Init:
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDS  R30,100
	ORI  R30,LOW(0xF)
	STS  100,R30
	RET
_LCD_Init:
	RCALL _LCD_PORT_Init
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	LDI  R30,LOW(14)
	CALL SUBOPT_0x3
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
	RCALL _LCD_Clear
	RET
;	p -> Y+0
;	p -> Y+0
;#include <stdio.h>
;#define SRF02_ERR_MAX_CNT 2000
;#define SRF02_Return_inch 80
;#define SRF02_Return_Cm 81
;#define SRF02_Return_microSecond 82
;#define ADC_VREF_TYPE 0x00  // A/D 컨버터 사용 기준 전압,AREF 단자 사용, 내부 VREF 끄기 설정
;#define ADC_AVCC_TYPE 0x40 // A/D 컨버터 사용 기준 전압,AVcc단자와 ARRE에 연결된 커패시터 사용
;#define ADC_RES_TYPE  0x80  // A/D 컨버터 사용 기준 전압,reserved
;#define ADC_2_56_TYPE 0xC0  // A/D 컨버터 사용 기준 전압,내부 2.56V와 AREF에 연결된 커패시터 사용
;#define LCD_WDATA PORTA // LCD 데이터 포트 정의
;#define LCD_WINST PORTA
;#define LCD_CTRL PORTG // LCD 제어포트 정의
;#define LCD_EN 0
;#define LCD_RW 1
;#define LCD_RS 2
;#define Do 4000
;#define HDo 300
;#define PIR_sensor1 PINE.5
;#define PIR_sensor2 PINE.7
;#define servo_motor PORTE.6
;#define num 10
;char seg_pat[10]= {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};

	.DSEG
;char seg_pat1[10]= {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
;char match[10]={0,1,2,3,4,5,6,7,8,9};
;unsigned char key;
;int count1=0;
;unsigned int PIR_Status=0;
;char ii=0;
;int count=0;
;int i =0;
;int flag,flag2=0;
;int k,b,n=0;
;int k1=0;
;unsigned char ti_Cnt_1ms; // 1ms 단위 시간 계수 위한 전역 변수선언
;unsigned char Com_Reg;
;void FND_MATCH(int x)
; 0000 0028 {

	.CSEG
_FND_MATCH:
; 0000 0029 
; 0000 002A        for(ii=0 ; ii<11 ; ii++)
;	x -> Y+0
	CLR  R4
_0x10:
	LDI  R30,LOW(11)
	CP   R4,R30
	BRSH _0x11
; 0000 002B         {
; 0000 002C         if(x/10==match[ii])
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL SUBOPT_0x5
	BRNE _0x12
; 0000 002D         {
; 0000 002E         PORTB = seg_pat[ii];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_seg_pat)
	SBCI R31,HIGH(-_seg_pat)
	LD   R30,Z
	OUT  0x18,R30
; 0000 002F         }
; 0000 0030         }
_0x12:
	INC  R4
	RJMP _0x10
_0x11:
; 0000 0031         for(ii=0 ; ii<11 ; ii++)
	CLR  R4
_0x14:
	LDI  R30,LOW(11)
	CP   R4,R30
	BRSH _0x15
; 0000 0032         {
; 0000 0033         if(x%10==match[ii])
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL SUBOPT_0x5
	BRNE _0x16
; 0000 0034         {
; 0000 0035         PORTC = seg_pat1[ii];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_seg_pat1)
	SBCI R31,HIGH(-_seg_pat1)
	LD   R30,Z
	OUT  0x15,R30
; 0000 0036         }
; 0000 0037         }
_0x16:
	INC  R4
	RJMP _0x14
_0x15:
; 0000 0038 }
_0x20A000B:
	ADIW R28,2
	RET
;void FND_init()
; 0000 003A {
_FND_init:
; 0000 003B PORTB = seg_pat[0];
	LDS  R30,_seg_pat
	OUT  0x18,R30
; 0000 003C PORTC = seg_pat1[0];
	LDS  R30,_seg_pat1
	OUT  0x15,R30
; 0000 003D }
	RET
;void Port_init(){
; 0000 003E void Port_init(){
_Port_init:
; 0000 003F     DDRE.5=0;
	CBI  0x2,5
; 0000 0040     DDRE.6=1;
	SBI  0x2,6
; 0000 0041     DDRE.7=0;
	CBI  0x2,7
; 0000 0042     DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0043     DDRC=0xff;
	OUT  0x14,R30
; 0000 0044     DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0045     PORTD=0xff;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0046 }
	RET
;void myDelay_us(unsigned int delay)
; 0000 0048 {
; 0000 0049     int i;
; 0000 004A     for(i=0; i<delay; i++)
;	delay -> Y+2
;	i -> R16,R17
; 0000 004B     {
; 0000 004C         delay_us(1);
; 0000 004D     }
; 0000 004E }
;void SSound(int time)
; 0000 0050 {
; 0000 0051     int i, tim;
; 0000 0052     tim = 50000/time; //음계마다 같은 시간동안 울리도록 tim 변수 사용
;	time -> Y+4
;	i -> R16,R17
;	tim -> R18,R19
; 0000 0053     for(i=0; i<tim; i++)
; 0000 0054     {
; 0000 0055         PORTG |= 1<<4; //buzzer on, PORTG의 4번 핀 on(out 1)
; 0000 0056         myDelay_us(time);
; 0000 0057         PORTG &= ~(1<<4); //buzzer off, PORTG의 4번 핀 off(out 0)
; 0000 0058         myDelay_us(time);
; 0000 0059     }
; 0000 005A }
;void B_correct()
; 0000 005C {
; 0000 005D      SSound(Do);
; 0000 005E      delay_ms(30);
; 0000 005F 
; 0000 0060      SSound(HDo);
; 0000 0061      delay_ms(30);
; 0000 0062 }
;void ADC_Init(void)
; 0000 0064 {
_ADC_Init:
; 0000 0065 ADCSRA  = 0x00;        // ADC 설정을 위한 비활성화
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 0066 ADMUX   = ADC_AVCC_TYPE | (0<ADLAR) | (0<<MUX0);
	LDI  R30,LOW(65)
	OUT  0x7,R30
; 0000 0067 // REFS1∼0='11', ADLAR=0, MUX=0(ADC0 선택)
; 0000 0068 ADCSRA  = (1<<ADEN) | (3<<ADPS0)| (1<<ADFR);
	LDI  R30,LOW(163)
	OUT  0x6,R30
; 0000 0069 // 1<<ADEN  : AD변환 활성화
; 0000 006A // 1<<ADFR  : Free Running 모드 활성화
; 0000 006B // 3<<ADPS0 : AC변환 분주비성정 - 8분주.
; 0000 006C }
	RET
;
;/**
;* @brief  Differential ADC 결과 읽어오는 함수
;* @param  adc_input: ADC 하고자 하는 채널의 번호 (8 ~ 0x1F)
;* @retval AD 변환 값( 0 ~ 1023),0v=0,5v=1023 2.5v=512
;*/
;unsigned int Read_ADC_Data_Diff(unsigned char adc_mux)
; 0000 0074 {
_Read_ADC_Data_Diff:
; 0000 0075 unsigned int ADC_Data = 0;
; 0000 0076 if(adc_mux < 8) return 0xFFFF;                     // 양극신호가 아닌 단극 MUX 입력시 종료
	ST   -Y,R17
	ST   -Y,R16
;	adc_mux -> Y+2
;	ADC_Data -> R16,R17
	__GETWRN 16,17,0
	LDD  R26,Y+2
	CPI  R26,LOW(0x8)
	BRSH _0x23
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0008
; 0000 0077 // AD 변환 채널 설정
; 0000 0078 ADMUX    &= ~(0x1F);
_0x23:
	IN   R30,0x7
	ANDI R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 0079 ADMUX |= (adc_mux & 0x1F);
	IN   R30,0x7
	MOV  R26,R30
	LDD  R30,Y+2
	ANDI R30,LOW(0x1F)
	OR   R30,R26
	OUT  0x7,R30
; 0000 007A ADCSRA |= (1<<ADSC);             // AD 변환 시작
	SBI  0x6,6
; 0000 007B while(!(ADCSRA & (1 << ADIF)));     // AD 변환 종료 대기
_0x24:
	SBIS 0x6,4
	RJMP _0x24
; 0000 007C ADC_Data  = ADCL;
	IN   R16,4
	CLR  R17
; 0000 007D ADC_Data  |= ADCH<<8;
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
; 0000 007E flag+=1;
	LDS  R30,_flag
	LDS  R31,_flag+1
	ADIW R30,1
	STS  _flag,R30
	STS  _flag+1,R31
; 0000 007F flag2+=1;
	LDS  R30,_flag2
	LDS  R31,_flag2+1
	ADIW R30,1
	STS  _flag2,R30
	STS  _flag2+1,R31
; 0000 0080 return ADC_Data;
	RJMP _0x20A0007
; 0000 0081 
; 0000 0082 }
;
;
;
;int SRF02_I2C_Write(char address, char reg, char data)
; 0000 0087 {
_SRF02_I2C_Write:
; 0000 0088 unsigned int srf02_ErrCnt = 0;
; 0000 0089 // I2C 시작비트 전송
; 0000 008A TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
	ST   -Y,R17
	ST   -Y,R16
;	address -> Y+4
;	reg -> Y+3
;	data -> Y+2
;	srf02_ErrCnt -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(164)
	STS  116,R30
; 0000 008B // 통신 시작 대기
; 0000 008C while(!(TWCR & (1<<TWINT) )){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
_0x27:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x29
	CALL SUBOPT_0x6
	BRLO _0x2A
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20A0006
_0x2A:
	RJMP _0x27
_0x29:
; 0000 008D // I2C 장비 주소 송신을 위한 적재 및 전송 시작
; 0000 008E TWDR = address; // SLA + W
	CALL SUBOPT_0x7
; 0000 008F TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 0090 // 송신 완료 대기
; 0000 0091 while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
_0x2B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x2D
	CALL SUBOPT_0x6
	BRLO _0x2E
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20A0006
_0x2E:
	RJMP _0x2B
_0x2D:
; 0000 0092 // 레지스터 위치 송신을 위한 적재 및 전송 시작
; 0000 0093 TWDR = reg;
	LDD  R30,Y+3
	CALL SUBOPT_0x8
; 0000 0094 TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 0095 // 송신 완료 대기
; 0000 0096 while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
_0x2F:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x31
	CALL SUBOPT_0x6
	BRLO _0x32
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20A0006
_0x32:
	RJMP _0x2F
_0x31:
; 0000 0097 // 명령(command) 송신을 위한 적재 및 전송 시작
; 0000 0098 TWDR = data;
	LDD  R30,Y+2
	CALL SUBOPT_0x8
; 0000 0099 TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 009A // 송신 완료 대기
; 0000 009B while(!(TWCR & (1<<TWINT))){if(srf02_ErrCnt++ > SRF02_ERR_MAX_CNT){ return 0; } };
_0x33:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x35
	CALL SUBOPT_0x6
	BRLO _0x36
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x20A0006
_0x36:
	RJMP _0x33
_0x35:
; 0000 009C // I2C 종료비트 전송
; 0000 009D TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN); // stop bit
	LDI  R30,LOW(148)
	STS  116,R30
; 0000 009E return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	JMP  _0x20A0006
; 0000 009F }
;
;unsigned char SRF02_I2C_Read(char address, char reg)
; 0000 00A2 {
_SRF02_I2C_Read:
; 0000 00A3 char read_data = 0;
; 0000 00A4 unsigned int srf02_ErrCnt = 0;
; 0000 00A5 // I2C 시작비트 전송
; 0000 00A6 TWCR = 0xA4;//TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
	CALL __SAVELOCR4
;	address -> Y+5
;	reg -> Y+4
;	read_data -> R17
;	srf02_ErrCnt -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(164)
	STS  116,R30
; 0000 00A7 // 통신 시작 대기
; 0000 00A8 while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x37:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x39
	CALL SUBOPT_0x9
	BRLO _0x3A
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x3A:
	RJMP _0x37
_0x39:
; 0000 00A9 // I2C 장비 주소(SLA+W) 송신을 위한 적재 및 전송 시작
; 0000 00AA TWDR = address; // SLA + W
	LDD  R30,Y+5
	CALL SUBOPT_0x8
; 0000 00AB TWCR = 0x84;//TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 00AC // 송신 완료 대기
; 0000 00AD while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x3B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x3D
	CALL SUBOPT_0x9
	BRLO _0x3E
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x3E:
	RJMP _0x3B
_0x3D:
; 0000 00AE // 레지스터 위치 송신을 위한 적재 및 전송 시작
; 0000 00AF TWDR = reg;
	CALL SUBOPT_0x7
; 0000 00B0 TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 00B1 // 송신 완료 대기
; 0000 00B2 while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x3F:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x41
	CALL SUBOPT_0x9
	BRLO _0x42
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x42:
	RJMP _0x3F
_0x41:
; 0000 00B3 // I2C 재시작을 위한 시작 비트 전송
; 0000 00B4 TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
	LDI  R30,LOW(164)
	STS  116,R30
; 0000 00B5 // wait for confirmation of transmit
; 0000 00B6 while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x43:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x45
	CALL SUBOPT_0x9
	BRLO _0x46
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x46:
	RJMP _0x43
_0x45:
; 0000 00B7 // I2C 장비 주소(SLA+R) 송신을 위한 적재 및 전송 시작
; 0000 00B8 TWDR = address +1; // SLA + R
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STS  115,R30
; 0000 00B9 TWCR = (1<<TWINT) | (1<<TWEA) | (1<<TWEN);
	LDI  R30,LOW(196)
	STS  116,R30
; 0000 00BA // 송신 완료 대기
; 0000 00BB while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x47:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x49
	CALL SUBOPT_0x9
	BRLO _0x4A
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x4A:
	RJMP _0x47
_0x49:
; 0000 00BC // 데이터 수신을 위한 클럭 전송
; 0000 00BD TWCR = (1<<TWINT) | (1<<TWEN);
	LDI  R30,LOW(132)
	STS  116,R30
; 0000 00BE // 수신 완료 대기
; 0000 00BF while(!(TWCR & 0x80)){if(srf02_ErrCnt++>SRF02_ERR_MAX_CNT){ return 0; } };
_0x4B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x4D
	CALL SUBOPT_0x9
	BRLO _0x4E
	LDI  R30,LOW(0)
	RJMP _0x20A000A
_0x4E:
	RJMP _0x4B
_0x4D:
; 0000 00C0 // 수신된 데이터 반환 위하여 변수 저장
; 0000 00C1 read_data = TWDR;
	LDS  R17,115
; 0000 00C2 // I2C 종료비트 전송
; 0000 00C3 TWCR = (1<<TWINT) | (1<<TWSTO) | (1<<TWEN);
	LDI  R30,LOW(148)
	STS  116,R30
; 0000 00C4 // 수신된 데이터 반환
; 0000 00C5 return read_data;
	MOV  R30,R17
_0x20A000A:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 00C6 }
;
;void I2C_Init(void)
; 0000 00C9 {
_I2C_Init:
; 0000 00CA TWBR = 0x40; // 100kHz I2C clock frequency TWI통신속도 레지스터
	LDI  R30,LOW(64)
	STS  112,R30
; 0000 00CB }
	RET
;
;void change_Sonar_Addr(unsigned char ori, unsigned char des)// SFR02 모듈의 주소 바꾸는 함수
; 0000 00CE {
; 0000 00CF // ori-> 기존 주소 des-> 바꿀주소
; 0000 00D0 // 어드레스는 아래의 16개만 허용됨
; 0000 00D1 switch(des)
;	ori -> Y+1
;	des -> Y+0
; 0000 00D2 {
; 0000 00D3 case 0xE0:
; 0000 00D4 case 0xE2:
; 0000 00D5 case 0xE4:
; 0000 00D6 case 0xE6:
; 0000 00D7 case 0xE8:
; 0000 00D8 case 0xEA:
; 0000 00D9 case 0xEC:
; 0000 00DA case 0xEE:
; 0000 00DB case 0xF0:
; 0000 00DC case 0xF2:
; 0000 00DD case 0xF4:
; 0000 00DE case 0xF6:
; 0000 00DF case 0xF8:
; 0000 00E0 case 0xFA:
; 0000 00E1 case 0xFC:
; 0000 00E2 case 0xFE:
; 0000 00E3 // ID변경 시퀀스에 따라 기존 센서에 변경명령을 전송
; 0000 00E4 SRF02_I2C_Write(ori,Com_Reg,0xA0);
; 0000 00E5 SRF02_I2C_Write(ori,Com_Reg,0xA5);
; 0000 00E6 SRF02_I2C_Write(ori,Com_Reg,0xAA);
; 0000 00E7 // ID변경 시퀀스에 따라 신규 ID 전달
; 0000 00E8 SRF02_I2C_Write(ori,Com_Reg,des);
; 0000 00E9 break;
; 0000 00EA }
; 0000 00EB }
;
;void startRanging(char addr)
; 0000 00EE {
_startRanging:
; 0000 00EF // Cm 단위로 측정 요청.
; 0000 00F0     SRF02_I2C_Write(addr, Com_Reg,SRF02_Return_Cm);
;	addr -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDS  R30,_Com_Reg
	ST   -Y,R30
	LDI  R30,LOW(81)
	ST   -Y,R30
	RCALL _SRF02_I2C_Write
; 0000 00F1 }
_0x20A0009:
	ADIW R28,1
	RET
;
;unsigned int getRange(char addr)
; 0000 00F4 {
_getRange:
; 0000 00F5 unsigned int x;
; 0000 00F6 // Get high and then low bytes of the range
; 0000 00F7 x = SRF02_I2C_Read(addr,2) << 8; // Get high Byte
	ST   -Y,R17
	ST   -Y,R16
;	addr -> Y+2
;	x -> R16,R17
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SRF02_I2C_Read
	MOV  R31,R30
	LDI  R30,0
	MOVW R16,R30
; 0000 00F8 x += SRF02_I2C_Read(addr,3); // Get low Byte
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _SRF02_I2C_Read
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 00F9 return (x);
_0x20A0007:
	MOVW R30,R16
_0x20A0008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 0000 00FA }
;
;
;
;
;void Timer0_Init(){
; 0000 00FF void Timer0_Init(){
_Timer0_Init:
; 0000 0100     TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02); //CTC모드, 1024분주
	LDI  R30,LOW(15)
	OUT  0x33,R30
; 0000 0101     TCNT0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0102     OCR0 = 14; //14.7456Mhz / 1024분주 / 14단계 = 1.028kHz  //1ms마다 발생
	LDI  R30,LOW(14)
	OUT  0x31,R30
; 0000 0103     TIMSK = (1<<OCIE0);// 비교일치 인터럽트 허가
	LDI  R30,LOW(2)
	OUT  0x37,R30
; 0000 0104 }
	RET
;
;/**
;* @brief 타이머0 비교일치 인터럽트
;*/
;interrupt[TIM0_COMP] void timer0_comp(void){
; 0000 0109 interrupt[16] void timer0_comp(void){
_timer0_comp:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 010A     ti_Cnt_1ms++;
	LDS  R30,_ti_Cnt_1ms
	SUBI R30,-LOW(1)
	STS  _ti_Cnt_1ms,R30
; 0000 010B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;
;
;void main(void)
; 0000 0110 {   int adcRaw =0;             // ADC 데이터 저장용
_main:
; 0000 0111     float adcmilliVoltage =0;    // ADC 데이터를 전압으로 변환한 데이터 저장용
; 0000 0112     float Celsius = 0;          // 계산된 온도 저장용
; 0000 0113     float Celsius_vec[num];//값튀는거 방지 10개 배열 변수
; 0000 0114     float Celsius_vec_temp;
; 0000 0115     float Celsius_median=0;//10개중 5번째 값 저장 하는 변수
; 0000 0116     float open_close_Celsius=0;
; 0000 0117     float control_celsius=0;//온도지정스위치를 위한 변수
; 0000 0118     int jk=0;
; 0000 0119     int jj=0;
; 0000 011A     char Sonar_addr = 0xE0; // 측정하고자 하는 장치 주소
; 0000 011B     unsigned int Sonar_range; // 측정 거리를 저장할 변수
; 0000 011C     char Message[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수
; 0000 011D     char Celsi[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수
; 0000 011E     char control_cel[40]; // LCD 화면에 문자열 출력을 위한 문자열 변수
; 0000 011F     ADC_Init();  // ADC 초기화
	SBIW R28,63
	SBIW R28,63
	SBIW R28,61
	LDI  R24,65
	LDI  R26,LOW(122)
	LDI  R27,HIGH(122)
	LDI  R30,LOW(_0x71*2)
	LDI  R31,HIGH(_0x71*2)
	CALL __INITLOCB
;	adcRaw -> R16,R17
;	adcmilliVoltage -> Y+183
;	Celsius -> Y+179
;	Celsius_vec -> Y+139
;	Celsius_vec_temp -> Y+135
;	Celsius_median -> Y+131
;	open_close_Celsius -> Y+127
;	control_celsius -> Y+123
;	jk -> R18,R19
;	jj -> R20,R21
;	Sonar_addr -> Y+122
;	Sonar_range -> Y+120
;	Message -> Y+80
;	Celsi -> Y+40
;	control_cel -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL _ADC_Init
; 0000 0120     LCD_Init(); // LCD 초기화
	RCALL _LCD_Init
; 0000 0121     LCD_Clear();
	RCALL _LCD_Clear
; 0000 0122     Timer0_Init(); // 1ms 계수 위한 타이머 초기화
	RCALL _Timer0_Init
; 0000 0123     I2C_Init(); // I2C 통신 초기화( baudrate 설정)
	RCALL _I2C_Init
; 0000 0124     delay_ms(1000); // SRF02 전원 안정화 시간 대기
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x2
; 0000 0125     SREG|=0x80; // 타이머 인터럽트 활성화 위한 전역 인터럽트 활성화
	BSET 7
; 0000 0126     startRanging(Sonar_addr); // 초음파 센서 거리 측정 시작 명령 ()는 0xE0측정하고자 하는 장치 주소
	CALL SUBOPT_0xA
	RCALL _startRanging
; 0000 0127     ti_Cnt_1ms = 0; // 측정시간 대기를 위한 변수 초기화
	LDI  R30,LOW(0)
	STS  _ti_Cnt_1ms,R30
; 0000 0128     Port_init();
	RCALL _Port_init
; 0000 0129     FND_init();//fnd 초기값 00
	RCALL _FND_init
; 0000 012A     while(1)
_0x72:
; 0000 012B     {   if(flag !=-1){
	CALL SUBOPT_0xB
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE PC+3
	JMP _0x75
; 0000 012C         adcRaw     = Read_ADC_Data_Diff(0b1101);    // MUX : 01101 변환 요청
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _Read_ADC_Data_Diff
	MOVW R16,R30
; 0000 012D         // ADC3 : Positive Differential Input
; 0000 012E         // ADC2 : Negative Differential Input
; 0000 012F         // 10x GAIN
; 0000 0130         adcmilliVoltage = ( (( (float)adcRaw * 5000) /512) / 10);
	MOVW R30,R16
	CALL SUBOPT_0xC
	__GETD2N 0x459C4000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44000000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0xD
	__PUTD1SX 183
; 0000 0131         // 전압으로 변환, VREF = 5000 mV, 10배 증폭비, 차동계측 고려
; 0000 0132         Celsius = adcmilliVoltage  / 10;
	CALL SUBOPT_0xE
	__PUTD1SX 179
; 0000 0133         if(flag==0){Celsius_vec[0]=Celsius;} //값 튀는거 잡기 위해 10개 배열에 넣고 내림차순 후 중간값 뽑아
	LDS  R30,_flag
	LDS  R31,_flag+1
	SBIW R30,0
	BRNE _0x76
	__GETD1SX 179
	__PUTD1SX 139
; 0000 0134         if(flag==1){Celsius_vec[1]=Celsius;}
_0x76:
	CALL SUBOPT_0xB
	SBIW R26,1
	BRNE _0x77
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,4
	CALL SUBOPT_0xF
; 0000 0135         if(flag==2){Celsius_vec[2]=Celsius;}
_0x77:
	CALL SUBOPT_0xB
	SBIW R26,2
	BRNE _0x78
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,8
	CALL SUBOPT_0xF
; 0000 0136         if(flag==3){Celsius_vec[3]=Celsius;}
_0x78:
	CALL SUBOPT_0xB
	SBIW R26,3
	BRNE _0x79
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,12
	CALL SUBOPT_0xF
; 0000 0137         if(flag==4){Celsius_vec[4]=Celsius;}
_0x79:
	CALL SUBOPT_0xB
	SBIW R26,4
	BRNE _0x7A
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,16
	CALL SUBOPT_0xF
; 0000 0138         if(flag==5){Celsius_vec[5]=Celsius;}
_0x7A:
	CALL SUBOPT_0xB
	SBIW R26,5
	BRNE _0x7B
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,20
	CALL SUBOPT_0xF
; 0000 0139         if(flag==6){Celsius_vec[6]=Celsius;}
_0x7B:
	CALL SUBOPT_0xB
	SBIW R26,6
	BRNE _0x7C
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,24
	CALL SUBOPT_0xF
; 0000 013A         if(flag==7){Celsius_vec[7]=Celsius;}
_0x7C:
	CALL SUBOPT_0xB
	SBIW R26,7
	BRNE _0x7D
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,28
	CALL SUBOPT_0xF
; 0000 013B         if(flag==8){Celsius_vec[8]=Celsius;}
_0x7D:
	CALL SUBOPT_0xB
	SBIW R26,8
	BRNE _0x7E
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,32
	CALL SUBOPT_0xF
; 0000 013C         if(flag==9){Celsius_vec[9]=Celsius;}
_0x7E:
	CALL SUBOPT_0xB
	SBIW R26,9
	BRNE _0x7F
	MOVW R30,R28
	SUBI R30,LOW(-(139))
	SBCI R31,HIGH(-(139))
	ADIW R30,36
	CALL SUBOPT_0xF
; 0000 013D         }
_0x7F:
; 0000 013E 
; 0000 013F         for(jk=0;jk<num-1;jk++){       //내림차순
_0x75:
	__GETWRN 18,19,0
_0x81:
	__CPWRN 18,19,9
	BRGE _0x82
; 0000 0140             for(jj=jk+1;jj<num;jj++){
	MOVW R30,R18
	ADIW R30,1
	MOVW R20,R30
_0x84:
	__CPWRN 20,21,10
	BRGE _0x85
; 0000 0141                 if(Celsius_vec[jk]<Celsius_vec[jj]){
	CALL SUBOPT_0x10
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x11
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRSH _0x86
; 0000 0142                     Celsius_vec_temp=Celsius_vec[jj];
	CALL SUBOPT_0x11
	__PUTD1SX 135
; 0000 0143                     Celsius_vec[jj]=Celsius_vec[jk];
	MOVW R30,R20
	CALL SUBOPT_0x12
	MOVW R0,R30
	CALL SUBOPT_0x10
	MOVW R26,R0
	CALL __PUTDP1
; 0000 0144                     Celsius_vec[jk]=Celsius_vec_temp;
	MOVW R30,R18
	CALL SUBOPT_0x12
	__GETD2SX 135
	CALL __PUTDZ20
; 0000 0145                 }
; 0000 0146             }
_0x86:
	__ADDWRN 20,21,1
	RJMP _0x84
_0x85:
; 0000 0147         }
	__ADDWRN 18,19,1
	RJMP _0x81
_0x82:
; 0000 0148 
; 0000 0149         if(flag>10){
	CALL SUBOPT_0xB
	SBIW R26,11
	BRLT _0x87
; 0000 014A         Celsius_median=Celsius_vec[num/2];
	__GETD1SX 159
	__PUTD1SX 131
; 0000 014B             if(flag2==11){
	CALL SUBOPT_0x13
	SBIW R26,11
	BRNE _0x88
; 0000 014C             open_close_Celsius=Celsius_median;
	__GETD1SX 131
	__PUTD1SX 127
; 0000 014D             }
; 0000 014E         flag=0;
_0x88:
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 014F         }
; 0000 0150         sprintf(Celsi,"%2.2f",Celsius_median);      //10번 중 5번쨰 디택트 내림차순 정리
_0x87:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	__GETD1SX 135
	CALL SUBOPT_0x16
; 0000 0151         /////////////////////////////////////////////////////////////////
; 0000 0152         //온도 지정 과정
; 0000 0153          if(PIND.5 == 0) {
	SBIC 0x10,5
	RJMP _0x89
; 0000 0154             delay_ms(20);
	CALL SUBOPT_0x17
; 0000 0155             control_celsius=adcmilliVoltage  / 10;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x18
; 0000 0156             delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x2
; 0000 0157             FND_MATCH(control_celsius);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 0158             LCD_Clear();
	RCALL _LCD_Clear
; 0000 0159             sprintf(control_cel,"%2.2f",control_celsius);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1C
; 0000 015A             LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 015B             LCD_Str("Celsius Change" );
	__POINTW1MN _0x8A,0
	CALL SUBOPT_0x1E
; 0000 015C             LCD_Pos(1,0);
; 0000 015D             LCD_Str(control_cel);
	RCALL _LCD_Str
; 0000 015E             k1++;
	LDI  R26,LOW(_k1)
	LDI  R27,HIGH(_k1)
	CALL SUBOPT_0x1F
; 0000 015F             while(1) {
_0x8B:
; 0000 0160                 if(PIND.5 == 1) {
	SBIS 0x10,5
	RJMP _0x8E
; 0000 0161                   k++;
	LDI  R26,LOW(_k)
	LDI  R27,HIGH(_k)
	CALL SUBOPT_0x1F
	SBIW R30,1
; 0000 0162                     if(k>=2)k = 0;
	LDS  R26,_k
	LDS  R27,_k+1
	SBIW R26,2
	BRLT _0x8F
	LDI  R30,LOW(0)
	STS  _k,R30
	STS  _k+1,R30
; 0000 0163                     break;
_0x8F:
	RJMP _0x8D
; 0000 0164                 }
; 0000 0165            }
_0x8E:
	RJMP _0x8B
_0x8D:
; 0000 0166          }
; 0000 0167        /////////////////////////////////////////////////////////////////
; 0000 0168        //온도 up
; 0000 0169         if(k==1){
_0x89:
	LDS  R26,_k
	LDS  R27,_k+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x90
; 0000 016A 
; 0000 016B         while(1){
_0x91:
; 0000 016C 
; 0000 016D             if(PIND.3 == 0) {
	SBIC 0x10,3
	RJMP _0x94
; 0000 016E                 delay_ms(20);
	CALL SUBOPT_0x17
; 0000 016F                 LCD_Clear();
	CALL SUBOPT_0x20
; 0000 0170                 control_celsius+=1;
	CALL __ADDF12
	CALL SUBOPT_0x18
; 0000 0171                 sprintf(control_cel,"%2.2f",control_celsius);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1C
; 0000 0172                 FND_MATCH(control_celsius);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 0173                 LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 0174                 LCD_Str("Celsius Change" );
	__POINTW1MN _0x8A,15
	CALL SUBOPT_0x1E
; 0000 0175                 LCD_Pos(1,0);
; 0000 0176                 LCD_Str(control_cel);
	RCALL _LCD_Str
; 0000 0177                 while(1) {
_0x95:
; 0000 0178                     if(PIND.3 == 1) {
	SBIS 0x10,3
	RJMP _0x98
; 0000 0179                     b++;
	LDI  R26,LOW(_b)
	LDI  R27,HIGH(_b)
	CALL SUBOPT_0x1F
	SBIW R30,1
; 0000 017A                         if(b>=2)b = 0;
	LDS  R26,_b
	LDS  R27,_b+1
	SBIW R26,2
	BRLT _0x99
	LDI  R30,LOW(0)
	STS  _b,R30
	STS  _b+1,R30
; 0000 017B                         break;
_0x99:
	RJMP _0x97
; 0000 017C                     }
; 0000 017D                 }
_0x98:
	RJMP _0x95
_0x97:
; 0000 017E             }
; 0000 017F            ////온도 down
; 0000 0180             if(PIND.4 == 0) {
_0x94:
	SBIC 0x10,4
	RJMP _0x9A
; 0000 0181                 delay_ms(20);
	CALL SUBOPT_0x17
; 0000 0182                 LCD_Clear();
	CALL SUBOPT_0x20
; 0000 0183                 control_celsius-=1;
	CALL __SUBF12
	CALL SUBOPT_0x18
; 0000 0184                 sprintf(control_cel,"%2.2f",control_celsius);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1C
; 0000 0185                 FND_MATCH(control_celsius);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 0186                 LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 0187                 LCD_Str("Celsius Change" );
	__POINTW1MN _0x8A,30
	CALL SUBOPT_0x1E
; 0000 0188                 LCD_Pos(1,0);
; 0000 0189                 LCD_Str(control_cel);
	RCALL _LCD_Str
; 0000 018A                 while(1) {
_0x9B:
; 0000 018B                     if(PIND.4 == 1) {
	SBIS 0x10,4
	RJMP _0x9E
; 0000 018C                        n++;
	LDI  R26,LOW(_n)
	LDI  R27,HIGH(_n)
	CALL SUBOPT_0x1F
	SBIW R30,1
; 0000 018D                         if(n>=2)n = 0;
	LDS  R26,_n
	LDS  R27,_n+1
	SBIW R26,2
	BRLT _0x9F
	LDI  R30,LOW(0)
	STS  _n,R30
	STS  _n+1,R30
; 0000 018E                         break;
_0x9F:
	RJMP _0x9D
; 0000 018F                     }
; 0000 0190                 }
_0x9E:
	RJMP _0x9B
_0x9D:
; 0000 0191             }
; 0000 0192            //온도변환과정 탈
; 0000 0193             if(PIND.6==0){k=0;break;}
_0x9A:
	SBIC 0x10,6
	RJMP _0xA0
	LDI  R30,LOW(0)
	STS  _k,R30
	STS  _k+1,R30
	RJMP _0x93
; 0000 0194         }
_0xA0:
	RJMP _0x91
_0x93:
; 0000 0195 
; 0000 0196         }
; 0000 0197         /////////////////////////////////////////////////////////////////
; 0000 0198         //인체 디택트+일정 거리 안에 들어오면 open
; 0000 0199         if(flag2>12){
_0x90:
	CALL SUBOPT_0x13
	SBIW R26,13
	BRGE PC+3
	JMP _0xA1
; 0000 019A         if(Celsius_median< open_close_Celsius+1){
	CALL SUBOPT_0x21
	BRLO PC+3
	JMP _0xA2
; 0000 019B         if(PIR_sensor1==1 || PIR_sensor2==1)
	SBIC 0x1,5
	RJMP _0xA4
	SBIS 0x1,7
	RJMP _0xA3
_0xA4:
; 0000 019C         {
; 0000 019D             LCD_Clear();
	RCALL _LCD_Clear
; 0000 019E             LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 019F             LCD_Str("Motion Detect" );
	__POINTW1MN _0x8A,45
	CALL SUBOPT_0x22
; 0000 01A0             if(ti_Cnt_1ms > 66)       //0.066초마다 실행
	LDS  R26,_ti_Cnt_1ms
	CPI  R26,LOW(0x43)
	BRSH PC+3
	JMP _0xA6
; 0000 01A1             {
; 0000 01A2             // 초음파 센서 거리 측정 데이터 얻기
; 0000 01A3                 Sonar_range = getRange(Sonar_addr);
	CALL SUBOPT_0xA
	RCALL _getRange
	__PUTW1SX 120
; 0000 01A4             // 측정된 거리 LCD 화면에 출력
; 0000 01A5                 sprintf(Message, "%03d cm",Sonar_range);
	MOVW R30,R28
	SUBI R30,LOW(-(80))
	SBCI R31,HIGH(-(80))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,35
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 124
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x16
; 0000 01A6 
; 0000 01A7                 LCD_Pos(1,0);
	CALL SUBOPT_0x23
; 0000 01A8                 LCD_Str(Message);
	MOVW R30,R28
	SUBI R30,LOW(-(80))
	SBCI R31,HIGH(-(80))
	CALL SUBOPT_0x22
; 0000 01A9                 LCD_Pos(1,7);
	CALL SUBOPT_0x24
; 0000 01AA                 LCD_Str(Celsi);
	RCALL _LCD_Str
; 0000 01AB             // 초음파 센서 거리 측정 시작 명령
; 0000 01AC                 startRanging(Sonar_addr);
	CALL SUBOPT_0xA
	RCALL _startRanging
; 0000 01AD             // 대기시간 초기화
; 0000 01AE                 ti_Cnt_1ms = 0;
	LDI  R30,LOW(0)
	STS  _ti_Cnt_1ms,R30
; 0000 01AF                 delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x2
; 0000 01B0 
; 0000 01B1                 if(Sonar_range<50){
	__GETW2SX 120
	SBIW R26,50
	BRSH _0xA7
; 0000 01B2                     for(i=0;i<25;i++){servo_motor=1;delay_us(600);servo_motor=0;delay_ms(20);
	CLR  R12
	CLR  R13
_0xA9:
	CALL SUBOPT_0x25
	BRGE _0xAA
	CALL SUBOPT_0x26
; 0000 01B3                     LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 01B4                     LCD_Str("Open                          ");
	__POINTW1MN _0x8A,59
	CALL SUBOPT_0x22
; 0000 01B5                    }
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xA9
_0xAA:
; 0000 01B6 
; 0000 01B7                 }
; 0000 01B8 
; 0000 01B9              }
_0xA7:
; 0000 01BA         }
_0xA6:
; 0000 01BB         }
_0xA3:
; 0000 01BC         }
_0xA2:
; 0000 01BD         //거리 엔디드 문 close
; 0000 01BE        if(flag2>12){
_0xA1:
	CALL SUBOPT_0x13
	SBIW R26,13
	BRLT _0xAF
; 0000 01BF        if(Celsius_median< open_close_Celsius+1){
	CALL SUBOPT_0x21
	BRSH _0xB0
; 0000 01C0         if(PIR_sensor1==0 && PIR_sensor2==0)
	LDI  R26,0
	SBIC 0x1,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB2
	LDI  R26,0
	SBIC 0x1,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 01C1         {
; 0000 01C2            LCD_Clear();
	RCALL _LCD_Clear
; 0000 01C3            LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 01C4            LCD_Str("Motion Ended");
	__POINTW1MN _0x8A,90
	CALL SUBOPT_0x22
; 0000 01C5            LCD_Pos(1,0);
	CALL SUBOPT_0x23
; 0000 01C6            LCD_Str("Close");
	__POINTW1MN _0x8A,103
	CALL SUBOPT_0x22
; 0000 01C7            LCD_Pos(1,7);
	CALL SUBOPT_0x24
; 0000 01C8            LCD_Str(Celsi);
	CALL SUBOPT_0x27
; 0000 01C9            LCD_Comm(0x0c);
; 0000 01CA            count++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 01CB            delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x2
; 0000 01CC            if(count>=1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0xB4
; 0000 01CD              for(i=0;i<25;i++){servo_motor=1;delay_us(3300);servo_motor=0;delay_ms(20);}count=0;
	CLR  R12
	CLR  R13
_0xB6:
	CALL SUBOPT_0x25
	BRGE _0xB7
	SBI  0x3,6
	__DELAY_USW 12165
	CBI  0x3,6
	CALL SUBOPT_0x17
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xB6
_0xB7:
	CLR  R10
	CLR  R11
; 0000 01CE            }
; 0000 01CF         }
_0xB4:
; 0000 01D0        }
_0xB1:
; 0000 01D1        }
_0xB0:
; 0000 01D2     //온돈 변환 과정 실행
; 0000 01D3         if(k1>=1){
_0xAF:
	LDS  R26,_k1
	LDS  R27,_k1+1
	SBIW R26,1
	BRGE PC+3
	JMP _0xBC
; 0000 01D4             if(control_celsius> open_close_Celsius ){
	__GETD1SX 127
	__GETD2SX 123
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xBD
; 0000 01D5                 if(Celsius_median>=control_celsius) {
	CALL SUBOPT_0x19
	__GETD2SX 131
	CALL __CMPF12
	BRLO _0xBE
; 0000 01D6 
; 0000 01D7                 LCD_Clear();
	RCALL _LCD_Clear
; 0000 01D8                 delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x2
; 0000 01D9                 LCD_Pos(0,0);
	CALL SUBOPT_0x1D
; 0000 01DA                 LCD_Str("Cooling heat                 ");
	__POINTW1MN _0x8A,109
	CALL SUBOPT_0x22
; 0000 01DB                 LCD_Pos(1,0);
	CALL SUBOPT_0x23
; 0000 01DC                 LCD_Str(Celsi);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x27
; 0000 01DD                 LCD_Comm(0x0c);
; 0000 01DE                 for(i=0;i<25;i++){servo_motor=1;delay_us(600);servo_motor=0;delay_ms(20);}
	CLR  R12
	CLR  R13
_0xC0:
	CALL SUBOPT_0x25
	BRGE _0xC1
	CALL SUBOPT_0x26
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xC0
_0xC1:
; 0000 01DF                 delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x2
; 0000 01E0                 if(PIND.7==0){Celsius_median=0;}
	SBIC 0x10,7
	RJMP _0xC6
	LDI  R30,LOW(0)
	__CLRD1SX 131
; 0000 01E1 
; 0000 01E2                 }
_0xC6:
; 0000 01E3             }
_0xBE:
; 0000 01E4         }
_0xBD:
; 0000 01E5     }
_0xBC:
	RJMP _0x72
; 0000 01E6     }
_0xC7:
	RJMP _0xC7

	.DSEG
_0x8A:
	.BYTE 0x8B
;
;
;
;
;
;
;
;
;
;
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1F
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x1F
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
_0x20A0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0x28
	RJMP _0x20A0005
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0x28
	RJMP _0x20A0005
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x29
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x29
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x2A
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x29
_0x2000022:
	CALL SUBOPT_0x2A
	BRLO _0x2000024
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x2A
	BRSH _0x2000028
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x29
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2A
	BRLO _0x2000029
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2F
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x2B
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x33
	CALL SUBOPT_0x2E
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x31
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x34
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200010E
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200010E:
	ST   X,R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x34
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1F
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x35
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x35
	RJMP _0x200010F
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL SUBOPT_0x36
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x38
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x39
	CALL __GETD1P
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	CALL SUBOPT_0x3C
	CALL __ANEGF1
	CALL SUBOPT_0x3A
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x38
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	CALL SUBOPT_0x3C
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	CALL SUBOPT_0x3C
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3D
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3D
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x3F
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	CALL SUBOPT_0x3F
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x3F
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x3F
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x39
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000110
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
	CALL __CWD1
	RJMP _0x2000110
_0x200007F:
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
	CLR  R22
	CLR  R23
_0x2000110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	CALL SUBOPT_0x3C
	CALL __ANEGD1
	CALL SUBOPT_0x3A
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	CALL SUBOPT_0x35
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	CALL SUBOPT_0x40
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	CALL SUBOPT_0x35
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	CALL SUBOPT_0x41
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000111
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000111:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	CALL SUBOPT_0x40
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	CALL SUBOPT_0x35
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x41
	CALL __MODD21U
	CALL SUBOPT_0x3A
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x3F
	__GETD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x38
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010F:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x42
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x42
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x43
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x43
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x43
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x44
	__POINTW1FN _0x2080000,0
	RCALL SUBOPT_0x28
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x44
	__POINTW1FN _0x2080000,1
	RCALL SUBOPT_0x28
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x48
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x49
	CALL __ADDF12
	RCALL SUBOPT_0x45
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x48
_0x2080014:
	RCALL SUBOPT_0x49
	CALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x48
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	RCALL SUBOPT_0x44
	__POINTW1FN _0x2080000,5
	RCALL SUBOPT_0x28
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	RCALL SUBOPT_0x46
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001C
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x2F
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x32
	LDI  R31,0
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0xC
	CALL __MULF12
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x45
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x46
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x45
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x32
	LDI  R31,0
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x45
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_seg_pat:
	.BYTE 0xA
_seg_pat1:
	.BYTE 0xA
_match:
	.BYTE 0xA
_flag:
	.BYTE 0x2
_flag2:
	.BYTE 0x2
_k:
	.BYTE 0x2
_b:
	.BYTE 0x2
_n:
	.BYTE 0x2
_k1:
	.BYTE 0x2
_ti_Cnt_1ms:
	.BYTE 0x1
_Com_Reg:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	ORI  R30,1
	STS  101,R30
	__DELAY_USB 246
	LD   R30,Y
	OUT  0x1B,R30
	__DELAY_USB 246
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	CALL _LCD_Comm
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _LCD_Delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(56)
	ST   -Y,R30
	CALL _LCD_Comm
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _LCD_Delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	MOVW R26,R30
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_match)
	SBCI R31,HIGH(-_match)
	LD   R30,Z
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	MOVW R26,R16
	__ADDWRN 16,17,1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDD  R30,Y+4
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	MOVW R26,R18
	__ADDWRN 18,19,1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__GETB1SX 122
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	LDS  R26,_flag
	LDS  R27,_flag+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	__GETD1N 0x41200000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__GETD2SX 183
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0xF:
	__GETD2SX 179
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	MOVW R30,R18
	MOVW R26,R28
	SUBI R26,LOW(-(139))
	SBCI R27,HIGH(-(139))
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	MOVW R30,R20
	MOVW R26,R28
	SUBI R26,LOW(-(139))
	SBCI R27,HIGH(-(139))
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOVW R26,R28
	SUBI R26,LOW(-(139))
	SBCI R27,HIGH(-(139))
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDS  R26,_flag2
	LDS  R27,_flag2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOVW R30,R28
	ADIW R30,40
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	__PUTD1SX 123
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x19:
	__GETD1SX 123
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _FND_MATCH

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	__GETD1SX 127
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _LCD_Str
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LCD_Pos
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1F:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	CALL _LCD_Clear
	RCALL SUBOPT_0x19
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x21:
	__GETD1SX 127
	__GETD2N 0x3F800000
	CALL __ADDF12
	__GETD2SX 131
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LCD_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _LCD_Pos
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	SBI  0x3,6
	__DELAY_USW 2212
	CBI  0x3,6
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL _LCD_Str
	LDI  R30,LOW(12)
	ST   -Y,R30
	JMP  _LCD_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x29:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x35:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x36:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x37:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x38:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x39:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x36
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x39
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x40:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x46:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
