
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _led_status=R4
	.DEF _led_status_msb=R5
	.DEF _blink_digit=R6
	.DEF _blink_digit_msb=R7
	.DEF _display_count=R8
	.DEF _display_count_msb=R9
	.DEF _ontime=R10
	.DEF _ontime_msb=R11
	.DEF _set_item=R12
	.DEF _set_item_msb=R13

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
	JMP  _timer1_ovf_isr
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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x00F0

_0x9:
	.DB  0x14,0xD7,0x4C,0x45,0x87,0x25,0x24,0x57
	.DB  0x4,0x5,0x6,0xA4,0x3C,0xC4,0x2C,0x2E
	.DB  0x34,0x86,0xD5,0x26,0xBC,0x66,0xE6,0xE4
	.DB  0xE,0xEE,0xAC,0xF4,0x74,0x85,0x10,0xFB
	.DB  0xEF,0xFF
_0xA:
	.DB  0x21,0x0,0x5,0x0,0xE,0x0,0x1A,0x0
	.DB  0x17,0x0,0x18,0x0,0x20,0x0,0x1,0x0
	.DB  0x17,0x0,0x18,0x0,0x20,0x0,0x2,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x2,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x2,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x3,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x3,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x4,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x4,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x5,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x5,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x6,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x6,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x7,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x7,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x8,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x8,0x0
	.DB  0x5,0x0,0x19,0x0,0x0,0x0,0x9,0x0
	.DB  0x1B,0x0,0x16,0x0,0x0,0x0,0x9,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x0,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x0,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x1,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x1,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x2,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x2,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x3,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x3,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x4,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x4,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x5,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x5,0x0
	.DB  0x5,0x0,0x19,0x0,0x1,0x0,0x6,0x0
	.DB  0x1B,0x0,0x16,0x0,0x1,0x0,0x6

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x22
	.DW  _segment_table
	.DW  _0x9*2

	.DW  0x107
	.DW  _message_set
	.DW  _0xA*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x160

	.CSEG
;/*******************************************************
;derived from cyclic1.c
;reason: to convert it to simple timer .
;jumper selection: PB0: on/off delay
;                  PB1: hr:min/min:sec
;todo: remove second set point
;add reset key to reset to zero
;
;
;
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/11/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;
;#define digit1() PORTC.5=1
;#define digit2() PORTC.6=1
;#define digit3() PORTC.7=1
;#define digit4() PORTC.4=1
;#define digit5() PORTC.2=1
;#define digit6() PORTC.3=1
;#define digit7() PORTC.1=1
;#define digit8() PORTC.0=1
;#define digit9() PORTD.7 = 1
;
;
;#define relay PORTD.1
;
;#define delaystatus PINB.0
;#define timestatus  PINB.1
;
;
;void clear_display(void)
; 0000 0037 {

	.CSEG
_clear_display:
; .FSTART _clear_display
; 0000 0038 PORTA =0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0039 PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 003A PORTD.7= 0;
	CBI  0x12,7
; 0000 003B 
; 0000 003C }
	RET
; .FEND
;
;unsigned short int led_status;
;
;#define all_led_off() led_status = 0xff;
;#define led1_on() led_status &= 0xfe
;#define led2_on() led_status &= 0xfd
;#define led3_on() led_status &= 0xfb
;#define led4_on() led_status &= 0xf7
;#define led5_on() led_status &= 0xef
;#define led6_on() led_status &= 0xdf
;#define led7_on() led_status &= 0xbf
;#define led8_on() led_status &= 0x7f
;#define led1_off() led_status |= 0x01
;#define led2_off() led_status |= 0x02
;#define led3_off() led_status |= 0x04
;#define led4_off() led_status |= 0x08
;#define led5_off() led_status |= 0x10
;#define led6_off() led_status |= 0x20
;#define led7_off() led_status |= 0x40
;#define led8_off() led_status |= 0x80
;
;#define key1 PIND.4
;#define key2 PIND.5
;#define key3 PIND.6
;#define key4 PIND.3
;#define key5 PIND.4
;#define key6 PIND.4
;#define rst_key  PIND.3
;
;
;
;void led_check(void)
; 0000 005D {
_led_check:
; .FSTART _led_check
; 0000 005E all_led_off();
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R4,R30
; 0000 005F if (relay) led1_off();
	SBIS 0x12,1
	RJMP _0x5
	LDI  R30,LOW(1)
	OR   R4,R30
; 0000 0060 else led1_on();
	RJMP _0x6
_0x5:
	LDI  R30,LOW(254)
	AND  R4,R30
	CLR  R5
; 0000 0061 if (!relay) led2_off();
_0x6:
	SBIC 0x12,1
	RJMP _0x7
	LDI  R30,LOW(2)
	OR   R4,R30
; 0000 0062 else led2_on();
	RJMP _0x8
_0x7:
	LDI  R30,LOW(253)
	AND  R4,R30
	CLR  R5
; 0000 0063 }
_0x8:
	RET
; .FEND
;
;
;// Declare your global variables here
;//                              0     1     2   3    4    5    6    7     8    9   10    11   12   13   14   15   16   1 ...
;//                              0     1     2   3    4    5    6    7     8    9    a    b    c    d    e    f    g    h ...
;unsigned char segment_table[]= {0x14,0xd7,0x4c,0x45,0x87,0x25,0x24,0x57,0x04,0x05,0x06,0xa4,0x3c,0xc4,0x2c,0x2e,0x34,0x8 ...

	.DSEG
;
;
;short int display_buffer[9];
;
;bit set_fl,sec_fl,blink_flag,blinking;
;int blink_digit;
;short int dummy[1] = {0};
;short int dummy2[1] = {0};
;unsigned int display_count;
;int ontime;
;short int message_set[]= {33,05,14,26,23,24,32,01,23,24,32,02,05,25,0,2,27,22,0,2,05,25,0,3,27,22,0,3,05,25,0,4,27,22,0, ...
;int set[10];
;short int set_item,key_count,key_rst_cnt,set_count;
;eeprom int ee_set[] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};    //uncomment for pt100 0.1 default
;bit key1_old=1,key2_old=1,key3_old=1,key4_old=1;
;bit on_fl;
;bit min_fl;
;int min_cnt;
;short int rst_count;
;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0082 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0083 // Reinitialize Timer1 value
; 0000 0084 TCNT1H=0x48E5 >> 8;
	LDI  R30,LOW(72)
	OUT  0x2D,R30
; 0000 0085 TCNT1L=0x48E5 & 0xff;
	LDI  R30,LOW(229)
	OUT  0x2C,R30
; 0000 0086 // Place your code here
; 0000 0087 sec_fl=1;
	SET
	BLD  R2,1
; 0000 0088 if (timestatus ==0)     min_fl =1;
	SBIC 0x16,1
	RJMP _0xB
	BLD  R3,1
; 0000 0089 
; 0000 008A blinking = ~blinking;
_0xB:
	LDI  R30,LOW(8)
	EOR  R2,R30
; 0000 008B min_cnt++;
	LDI  R26,LOW(_min_cnt)
	LDI  R27,HIGH(_min_cnt)
	RCALL SUBOPT_0x0
; 0000 008C if(min_cnt>=60)
	LDS  R26,_min_cnt
	LDS  R27,_min_cnt+1
	SBIW R26,60
	BRLT _0xC
; 0000 008D {
; 0000 008E min_cnt =0;
	LDI  R30,LOW(0)
	STS  _min_cnt,R30
	STS  _min_cnt+1,R30
; 0000 008F if (timestatus ==1) min_fl =1;
	SBIS 0x16,1
	RJMP _0xD
	SET
	BLD  R3,1
; 0000 0090 }
_0xD:
; 0000 0091 }
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;void display_put(int up_display, int low_display,int status,short int* message1,short int* message2)
; 0000 0095 {
_display_put:
; .FSTART _display_put
; 0000 0096 if (status ==0)
	ST   -Y,R27
	ST   -Y,R26
;	up_display -> Y+8
;	low_display -> Y+6
;	status -> Y+4
;	*message1 -> Y+2
;	*message2 -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0xE
; 0000 0097         {
; 0000 0098         if (up_display <0)
	LDD  R26,Y+9
	TST  R26
	BRPL _0xF
; 0000 0099         {
; 0000 009A         up_display = -up_display;
	RCALL SUBOPT_0x1
; 0000 009B         up_display%=1000;
; 0000 009C         display_buffer[0]= 31;
; 0000 009D         }
; 0000 009E         else
	RJMP _0x10
_0xF:
; 0000 009F         {
; 0000 00A0         display_buffer[0]=up_display/1000;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00A1         up_display%=1000;
	RCALL SUBOPT_0x4
; 0000 00A2         }
_0x10:
; 0000 00A3         display_buffer[1]=up_display/100;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00A4         up_display%=100;
	RCALL SUBOPT_0x4
; 0000 00A5         display_buffer[2]=up_display/10;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00A6         up_display%=10;
	RCALL SUBOPT_0x4
; 0000 00A7         display_buffer[3]=up_display;
	RCALL SUBOPT_0x9
; 0000 00A8 
; 0000 00A9         if (low_display <0)
	LDD  R26,Y+7
	TST  R26
	BRPL _0x11
; 0000 00AA         {
; 0000 00AB         low_display = -low_display;
	RCALL SUBOPT_0xA
; 0000 00AC         low_display%=1000;
; 0000 00AD         display_buffer[4]= 31;
; 0000 00AE         }
; 0000 00AF         else
	RJMP _0x12
_0x11:
; 0000 00B0         {
; 0000 00B1         display_buffer[4]=low_display/1000;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 00B2         low_display%=1000;
	RCALL SUBOPT_0xD
; 0000 00B3         }
_0x12:
; 0000 00B4         display_buffer[5]=low_display/100;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 00B5         low_display%=100;
	RCALL SUBOPT_0xD
; 0000 00B6         display_buffer[6]=low_display/10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 00B7         low_display%=10;
	RCALL SUBOPT_0xD
; 0000 00B8         display_buffer[7]=low_display;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0xAA
; 0000 00B9         }
; 0000 00BA else if (status ==1)
_0xE:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	BRNE _0x14
; 0000 00BB         {
; 0000 00BC         message1 = message1 + (up_display *4);
	RCALL SUBOPT_0x12
; 0000 00BD         display_buffer[0]=*message1;
; 0000 00BE         message1++;
; 0000 00BF         display_buffer[1]=*message1;
; 0000 00C0         message1++;
; 0000 00C1         display_buffer[2]=*message1;
; 0000 00C2         message1++;
; 0000 00C3         display_buffer[3]=*message1;
; 0000 00C4         if (low_display <0)
	LDD  R26,Y+7
	TST  R26
	BRPL _0x15
; 0000 00C5         {
; 0000 00C6         low_display = -low_display;
	RCALL SUBOPT_0xA
; 0000 00C7         low_display%=1000;
; 0000 00C8         display_buffer[4]= 31;
; 0000 00C9         }
; 0000 00CA         else
	RJMP _0x16
_0x15:
; 0000 00CB         {
; 0000 00CC         display_buffer[4]=low_display/1000;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 00CD         low_display%=1000;
	RCALL SUBOPT_0xD
; 0000 00CE         }
_0x16:
; 0000 00CF         display_buffer[5]=low_display/100;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 00D0         low_display%=100;
	RCALL SUBOPT_0xD
; 0000 00D1         display_buffer[6]=low_display/10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 00D2         low_display%=10;
	RCALL SUBOPT_0xD
; 0000 00D3         display_buffer[7]=low_display;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0xAA
; 0000 00D4         }
; 0000 00D5 else if (status ==2)
_0x14:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,2
	BRNE _0x18
; 0000 00D6         {
; 0000 00D7         message1 = message1 + (up_display *4);
	RCALL SUBOPT_0x12
; 0000 00D8         display_buffer[0]=*message1;
; 0000 00D9         message1++;
; 0000 00DA         display_buffer[1]=*message1;
; 0000 00DB         message1++;
; 0000 00DC         display_buffer[2]=*message1;
; 0000 00DD         message1++;
; 0000 00DE         display_buffer[3]=*message1;
; 0000 00DF         message2 = message2 + (low_display * 4);
	RCALL SUBOPT_0x13
; 0000 00E0         display_buffer[4]=*message2;
; 0000 00E1         message2++;
; 0000 00E2         display_buffer[5]=*message2;
; 0000 00E3         message2++;
; 0000 00E4         display_buffer[6]=*message2;
; 0000 00E5         message2++;
; 0000 00E6         display_buffer[7]=*message2;
_0xAA:
	__PUTW1MN _display_buffer,14
; 0000 00E7         }
; 0000 00E8 if (status ==3)
_0x18:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRNE _0x19
; 0000 00E9         {
; 0000 00EA         if (up_display <0)
	LDD  R26,Y+9
	TST  R26
	BRPL _0x1A
; 0000 00EB         {
; 0000 00EC         up_display = -up_display;
	RCALL SUBOPT_0x1
; 0000 00ED         up_display%=1000;
; 0000 00EE         display_buffer[0]= 31;
; 0000 00EF         }
; 0000 00F0         else
	RJMP _0x1B
_0x1A:
; 0000 00F1         {
; 0000 00F2         display_buffer[0]=up_display/1000;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00F3         up_display%=1000;
	RCALL SUBOPT_0x4
; 0000 00F4         }
_0x1B:
; 0000 00F5         display_buffer[1]=up_display/100;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00F6         up_display%=100;
	RCALL SUBOPT_0x4
; 0000 00F7         display_buffer[2]=up_display/10;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00F8         up_display%=10;
	RCALL SUBOPT_0x4
; 0000 00F9         display_buffer[3]=up_display;
	RCALL SUBOPT_0x9
; 0000 00FA 
; 0000 00FB         message2 = message2 + (low_display * 4);
	RCALL SUBOPT_0x13
; 0000 00FC         display_buffer[4]=*message2;
; 0000 00FD         message2++;
; 0000 00FE         display_buffer[5]=*message2;
; 0000 00FF         message2++;
; 0000 0100         display_buffer[6]=*message2;
; 0000 0101         message2++;
; 0000 0102         display_buffer[7]=*message2;
	__PUTW1MN _display_buffer,14
; 0000 0103         }
; 0000 0104 
; 0000 0105 // code added to blank the unused 0s
; 0000 0106 
; 0000 0107 
; 0000 0108 }
_0x19:
	ADIW R28,10
	RET
; .FEND
;
;
;void display_out(short int count2)
; 0000 010C {
_display_out:
; .FSTART _display_out
; 0000 010D int asa;
; 0000 010E clear_display();
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	count2 -> Y+2
;	asa -> R16,R17
	RCALL _clear_display
; 0000 010F asa = display_buffer[count2];
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RCALL SUBOPT_0x14
	LD   R16,X+
	LD   R17,X
; 0000 0110 asa = segment_table[asa];
	LDI  R26,LOW(_segment_table)
	LDI  R27,HIGH(_segment_table)
	ADD  R26,R16
	ADC  R27,R17
	LD   R16,X
	CLR  R17
; 0000 0111 if (count2 == (7-blink_digit))
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R6
	SBC  R31,R7
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1C
; 0000 0112 {
; 0000 0113 if (blink_flag && blinking)
	SBRS R2,2
	RJMP _0x1E
	SBRC R2,3
	RJMP _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0114 PORTA =0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0115 else
	RJMP _0x20
_0x1D:
; 0000 0116 PORTA = asa;
	OUT  0x1B,R16
; 0000 0117 }
_0x20:
; 0000 0118 else
	RJMP _0x21
_0x1C:
; 0000 0119 PORTA = asa;//decimal point for upper display
	OUT  0x1B,R16
; 0000 011A //if ((count2 == 6) && config_fl && (config[0]==0)&&((config_item==2)||(config_item==4)||(config_item==7)||(config_item= ...
; 0000 011B switch(count2)
_0x21:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0000 011C         {
; 0000 011D         case 0:  digit1();
	SBIW R30,0
	BRNE _0x25
	SBI  0x15,5
; 0000 011E         break;
	RJMP _0x24
; 0000 011F         case 1:  digit2();
_0x25:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x28
	SBI  0x15,6
; 0000 0120                 if (!set_fl) PORTA.2 =0;
	SBRS R2,0
	CBI  0x1B,2
; 0000 0121         break;
	RJMP _0x24
; 0000 0122         case 2:
_0x28:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2E
; 0000 0123                 digit3();
	SBI  0x15,7
; 0000 0124         break;
	RJMP _0x24
; 0000 0125         case 3:if (on_fl && !set_fl) PORTA.2 =blinking;
_0x2E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x31
	SBRS R3,0
	RJMP _0x33
	SBRS R2,0
	RJMP _0x34
_0x33:
	RJMP _0x32
_0x34:
	SBRC R2,3
	RJMP _0x35
	CBI  0x1B,2
	RJMP _0x36
_0x35:
	SBI  0x1B,2
_0x36:
; 0000 0126 
; 0000 0127          digit4();
_0x32:
	SBI  0x15,4
; 0000 0128         break;
	RJMP _0x24
; 0000 0129         case 4:  digit5();
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x39
	SBI  0x15,2
; 0000 012A         break;
	RJMP _0x24
; 0000 012B         case 5:  digit6();
_0x39:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3C
	SBI  0x15,3
; 0000 012C                 PORTA.2 =0;
	CBI  0x1B,2
; 0000 012D         break;
	RJMP _0x24
; 0000 012E         case 6: //if (!set_fl && !config_fl && (config[0] ==0)&& !toggle_fl) PORTC.0 =0;
_0x3C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x41
; 0000 012F                 //if (set_fl && !config_fl && (config[0]==0) && (set_item ==0)) PORTC.0 =0;
; 0000 0130                 //if (!set_fl && config_fl && (config[0]==0))
; 0000 0131                  //   {
; 0000 0132                   //  if ((config_item ==1)||(config_item ==3) || (config_item==6)||(config_item==7)) PORTC.0=0;
; 0000 0133                   //  }
; 0000 0134                 digit7();
	SBI  0x15,1
; 0000 0135 
; 0000 0136         break;
	RJMP _0x24
; 0000 0137         case 7: //if(!on_fl && !set_fl) PORTA.2 =blinking;
_0x41:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x44
; 0000 0138 
; 0000 0139                 digit8();
	SBI  0x15,0
; 0000 013A         break;
	RJMP _0x24
; 0000 013B         case 8: PORTA = led_status;
_0x44:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x24
	OUT  0x1B,R4
; 0000 013C                 digit9();
	SBI  0x12,7
; 0000 013D         break;
; 0000 013E         }
_0x24:
; 0000 013F 
; 0000 0140 //if (config_fl && !set_fl) display_put(config_item,config[config_item],1,message_config,dummy);
; 0000 0141 //if (!config_fl && set_fl && !calib) display_put(0,set[0],1,message_set,dummy);
; 0000 0142 
; 0000 0143 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void display_check(void)
; 0000 0146 {
_display_check:
; .FSTART _display_check
; 0000 0147     if (set_fl)
	SBRS R2,0
	RJMP _0x4A
; 0000 0148     {
; 0000 0149     display_put(set_item,set[set_item],1,message_set,dummy);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RJMP _0xAB
; 0000 014A     }
; 0000 014B     else
_0x4A:
; 0000 014C     {
; 0000 014D     display_put(ontime,set[0],0,dummy,dummy2);
	ST   -Y,R11
	ST   -Y,R10
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	LDI  R30,LOW(_dummy)
	LDI  R31,HIGH(_dummy)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_dummy2)
	LDI  R27,HIGH(_dummy2)
_0xAB:
	RCALL _display_put
; 0000 014E     }
; 0000 014F }
	RET
; .FEND
;
;void increment_value(int* value,int low_limit,int high_limit,short int power)
; 0000 0152 {
_increment_value:
; .FSTART _increment_value
; 0000 0153 int x,y;
; 0000 0154 int a;
; 0000 0155 int b=1;
; 0000 0156 for (a=0;a<power;a++) b = b*10;
	RCALL SUBOPT_0x19
;	*value -> Y+14
;	low_limit -> Y+12
;	high_limit -> Y+10
;	power -> Y+8
;	x -> R16,R17
;	y -> R18,R19
;	a -> R20,R21
;	b -> Y+6
_0x4D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRGE _0x4E
	RCALL SUBOPT_0x1A
	__ADDWRN 20,21,1
	RJMP _0x4D
_0x4E:
; 0000 0157 *value = *value + b;
	RCALL SUBOPT_0x1B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x1C
; 0000 0158 // added to increment 100th place if lower digits crosses 59(99:59)
; 0000 0159 x = *value /100; //higher digit
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
; 0000 015A y = *value%100; //lower digit
	RCALL SUBOPT_0x1E
; 0000 015B if (y >= 60)
	BRLT _0x4F
; 0000 015C {
; 0000 015D x++;
	__ADDWRN 16,17,1
; 0000 015E y=0;
	__GETWRN 18,19,0
; 0000 015F *value = (x *100)+y;
	RCALL SUBOPT_0x1F
; 0000 0160 }
; 0000 0161 //
; 0000 0162 if (*value < low_limit) *value = low_limit;
_0x4F:
	RCALL SUBOPT_0x1B
	MOVW R26,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x50
	RCALL SUBOPT_0x1C
; 0000 0163 if (*value >= high_limit) *value = high_limit;
_0x50:
	RCALL SUBOPT_0x1B
	MOVW R26,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x51
	RCALL SUBOPT_0x1C
; 0000 0164 }
_0x51:
	RJMP _0x2000001
; .FEND
;
;void decrement_value(int* value,int low_limit,int high_limit,short int power)
; 0000 0167 {
_decrement_value:
; .FSTART _decrement_value
; 0000 0168 int x,y;
; 0000 0169 int a;
; 0000 016A int b=1;
; 0000 016B for (a=0;a<power;a++) b = b*10;
	RCALL SUBOPT_0x19
;	*value -> Y+14
;	low_limit -> Y+12
;	high_limit -> Y+10
;	power -> Y+8
;	x -> R16,R17
;	y -> R18,R19
;	a -> R20,R21
;	b -> Y+6
_0x53:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRGE _0x54
	RCALL SUBOPT_0x1A
	__ADDWRN 20,21,1
	RJMP _0x53
_0x54:
; 0000 016C *value = *value- b;
	RCALL SUBOPT_0x1B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x1C
; 0000 016D x = *value /100;
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
; 0000 016E y = *value %100;
	RCALL SUBOPT_0x1E
; 0000 016F if (y >=60)
	BRLT _0x55
; 0000 0170 {
; 0000 0171 y=59;
	__GETWRN 18,19,59
; 0000 0172 *value = (x*100) +y;
	RCALL SUBOPT_0x1F
; 0000 0173 
; 0000 0174 }
; 0000 0175 
; 0000 0176 if (*value < low_limit) *value = low_limit;
_0x55:
	RCALL SUBOPT_0x1B
	MOVW R26,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x56
	RCALL SUBOPT_0x1C
; 0000 0177 if (*value >= high_limit) *value = high_limit;
_0x56:
	RCALL SUBOPT_0x1B
	MOVW R26,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x57
	RCALL SUBOPT_0x1C
; 0000 0178 }
_0x57:
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
; .FEND
;
;void ent_check(void)
; 0000 017B {
_ent_check:
; .FSTART _ent_check
; 0000 017C 
; 0000 017D     if (set_fl)
	SBRS R2,0
	RJMP _0x58
; 0000 017E     {
; 0000 017F     blink_digit =0;
	CLR  R6
	CLR  R7
; 0000 0180     ee_set[set_item] = set[set_item];
	RCALL SUBOPT_0x20
	CALL __GETW1P
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 0181     if(set_item >= 0)                   //changed from 1
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRLT _0x59
; 0000 0182             {
; 0000 0183             set_fl =0;
	CLT
	BLD  R2,0
; 0000 0184             set_item =0;
	CLR  R12
	CLR  R13
; 0000 0185             blink_digit =0;
	CLR  R6
	CLR  R7
; 0000 0186             blink_flag =0;
	BLD  R2,2
; 0000 0187             }
; 0000 0188             else
	RJMP _0x5A
_0x59:
; 0000 0189             {
; 0000 018A             ee_set[set_item] = set[set_item];
	RCALL SUBOPT_0x20
	CALL __GETW1P
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 018B             set_item++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 018C             if (set_item >1) set_item =0;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x5B
	CLR  R12
	CLR  R13
; 0000 018D             }
_0x5B:
_0x5A:
; 0000 018E         display_put(set_item,set[set_item],1,message_set,dummy);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL _display_put
; 0000 018F 
; 0000 0190     }
; 0000 0191 }
_0x58:
	RET
; .FEND
;
;void inc_check(void)
; 0000 0194 {
_inc_check:
; .FSTART _inc_check
; 0000 0195     if(set_fl)
	SBRS R2,0
	RJMP _0x5C
; 0000 0196     {
; 0000 0197     switch (set_item)
	MOVW R30,R12
; 0000 0198     {
; 0000 0199     case 0: increment_value(&set[0],1,9959,blink_digit);    //temp1
	SBIW R30,0
	BRNE _0x60
	LDI  R30,LOW(_set)
	LDI  R31,HIGH(_set)
	RJMP _0xAC
; 0000 019A                break;
; 0000 019B     case 1: increment_value(&set[1],1,9959,blink_digit);   //time
_0x60:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5F
	__POINTW1MN _set,2
_0xAC:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x21
	RCALL _increment_value
; 0000 019C             break;
; 0000 019D     }
_0x5F:
; 0000 019E     }
; 0000 019F 
; 0000 01A0 }
_0x5C:
	RET
; .FEND
;
;void dec_check(void)
; 0000 01A3 {
_dec_check:
; .FSTART _dec_check
; 0000 01A4     if(set_fl)
	SBRS R2,0
	RJMP _0x62
; 0000 01A5     {
; 0000 01A6     switch (set_item)
	MOVW R30,R12
; 0000 01A7     {
; 0000 01A8     case 0: decrement_value(&set[0],1,9959,blink_digit);    //temp1
	SBIW R30,0
	BRNE _0x66
	LDI  R30,LOW(_set)
	LDI  R31,HIGH(_set)
	RJMP _0xAD
; 0000 01A9 
; 0000 01AA             break;
; 0000 01AB     case 1: decrement_value(&set[1],1,9959,blink_digit);   //time
_0x66:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x65
	__POINTW1MN _set,2
_0xAD:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x21
	RCALL _decrement_value
; 0000 01AC             break;
; 0000 01AD     }
_0x65:
; 0000 01AE     }
; 0000 01AF 
; 0000 01B0 
; 0000 01B1 }
_0x62:
	RET
; .FEND
;
;void shf_check(void)
; 0000 01B4 {
_shf_check:
; .FSTART _shf_check
; 0000 01B5 
; 0000 01B6     if(set_fl)
	SBRS R2,0
	RJMP _0x68
; 0000 01B7     {
; 0000 01B8     if (blink_flag)
	SBRS R2,2
	RJMP _0x69
; 0000 01B9     blink_digit++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01BA     if (blink_digit > 3)
_0x69:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x6A
; 0000 01BB     blink_digit=0;
	CLR  R6
	CLR  R7
; 0000 01BC     }
_0x6A:
; 0000 01BD }
_0x68:
	RET
; .FEND
;
;
;
;void key_check()
; 0000 01C2 {
_key_check:
; .FSTART _key_check
; 0000 01C3      key1 = key2 = key3 = key4 = 1;
	SBI  0x10,3
	SBI  0x10,6
	SBI  0x10,5
	SBI  0x10,4
; 0000 01C4       key_count++;
	LDI  R26,LOW(_key_count)
	LDI  R27,HIGH(_key_count)
	RCALL SUBOPT_0x0
; 0000 01C5  if (key_count >=100)
	LDS  R26,_key_count
	LDS  R27,_key_count+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x73
; 0000 01C6     {
; 0000 01C7       key_count=0;
	LDI  R30,LOW(0)
	STS  _key_count,R30
	STS  _key_count+1,R30
; 0000 01C8       if (!key1 && key1_old)
	SBIC 0x10,4
	RJMP _0x75
	SBRC R2,4
	RJMP _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 01C9       {
; 0000 01CA       ent_check();
	RCALL _ent_check
; 0000 01CB       key_rst_cnt =0;
	RCALL SUBOPT_0x22
; 0000 01CC       }
; 0000 01CD       if (!key2 && key2_old)
_0x74:
	SBIC 0x10,5
	RJMP _0x78
	SBRC R2,5
	RJMP _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 01CE       {
; 0000 01CF       inc_check();
	RCALL _inc_check
; 0000 01D0       key_rst_cnt=0;
	RCALL SUBOPT_0x22
; 0000 01D1       }
; 0000 01D2       if (!key3 && key3_old)
_0x77:
	SBIC 0x10,6
	RJMP _0x7B
	SBRC R2,6
	RJMP _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 01D3       {
; 0000 01D4       dec_check();
	RCALL _dec_check
; 0000 01D5       key_rst_cnt =0;
	RCALL SUBOPT_0x22
; 0000 01D6       }
; 0000 01D7       if (!key4 && key4_old)
_0x7A:
	SBIC 0x10,3
	RJMP _0x7E
	SBRC R2,7
	RJMP _0x7F
_0x7E:
	RJMP _0x7D
_0x7F:
; 0000 01D8       {
; 0000 01D9       shf_check();
	RCALL _shf_check
; 0000 01DA       key_rst_cnt=0;
	RCALL SUBOPT_0x22
; 0000 01DB       }
; 0000 01DC       key1_old = key1;
_0x7D:
	CLT
	SBIC 0x10,4
	SET
	BLD  R2,4
; 0000 01DD       key2_old = key2;
	CLT
	SBIC 0x10,5
	SET
	BLD  R2,5
; 0000 01DE       key3_old = key3;
	CLT
	SBIC 0x10,6
	SET
	BLD  R2,6
; 0000 01DF       key4_old = key4;
	CLT
	SBIC 0x10,3
	SET
	BLD  R2,7
; 0000 01E0      }
; 0000 01E1 }
_0x73:
	RET
; .FEND
;
;void check_set(void)
; 0000 01E4 {
_check_set:
; .FSTART _check_set
; 0000 01E5 if (!key6)
	SBIC 0x10,4
	RJMP _0x80
; 0000 01E6 {
; 0000 01E7 set_count++;
	LDI  R26,LOW(_set_count)
	LDI  R27,HIGH(_set_count)
	RCALL SUBOPT_0x0
; 0000 01E8 if (set_count >=5000)
	LDS  R26,_set_count
	LDS  R27,_set_count+1
	CPI  R26,LOW(0x1388)
	LDI  R30,HIGH(0x1388)
	CPC  R27,R30
	BRLT _0x81
; 0000 01E9 {
; 0000 01EA set_count =0;
	LDI  R30,LOW(0)
	STS  _set_count,R30
	STS  _set_count+1,R30
; 0000 01EB if(!set_fl)
	SBRC R2,0
	RJMP _0x82
; 0000 01EC {
; 0000 01ED set[0] = ee_set[0];
	RCALL SUBOPT_0x23
; 0000 01EE display_put(0,set[0],1,message_set,dummy);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x17
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_message_set)
	LDI  R31,HIGH(_message_set)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_dummy)
	LDI  R27,HIGH(_dummy)
	RCALL _display_put
; 0000 01EF set_fl =1;
	SET
	BLD  R2,0
; 0000 01F0 blink_digit =0;
	CLR  R6
	CLR  R7
; 0000 01F1 blink_flag=1;
	BLD  R2,2
; 0000 01F2 }
; 0000 01F3 }
_0x82:
; 0000 01F4 
; 0000 01F5 }
_0x81:
; 0000 01F6 else
	RJMP _0x83
_0x80:
; 0000 01F7 set_count =0;
	LDI  R30,LOW(0)
	STS  _set_count,R30
	STS  _set_count+1,R30
; 0000 01F8 }
_0x83:
	RET
; .FEND
;
;void reset_timer(void)
; 0000 01FB {
_reset_timer:
; .FSTART _reset_timer
; 0000 01FC if (!rst_key && !set_fl)
	SBIC 0x10,3
	RJMP _0x85
	SBRS R2,0
	RJMP _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 01FD     {
; 0000 01FE     rst_count++;
	LDI  R26,LOW(_rst_count)
	LDI  R27,HIGH(_rst_count)
	RCALL SUBOPT_0x0
; 0000 01FF     if (rst_count >=3)
	LDS  R26,_rst_count
	LDS  R27,_rst_count+1
	SBIW R26,3
	BRLT _0x87
; 0000 0200         {
; 0000 0201         on_fl =1;
	SET
	BLD  R3,0
; 0000 0202         ontime =0;
	CLR  R10
	CLR  R11
; 0000 0203         min_cnt =0;
	LDI  R30,LOW(0)
	STS  _min_cnt,R30
	STS  _min_cnt+1,R30
; 0000 0204         if (delaystatus ==1)
	SBIS 0x16,0
	RJMP _0x88
; 0000 0205             {
; 0000 0206             relay =0;        //off delay
	CBI  0x12,1
; 0000 0207             }
; 0000 0208         else
	RJMP _0x8B
_0x88:
; 0000 0209             {
; 0000 020A             relay =1;       //on delay
	SBI  0x12,1
; 0000 020B             }
_0x8B:
; 0000 020C         }
; 0000 020D     }
_0x87:
; 0000 020E else
	RJMP _0x8E
_0x84:
; 0000 020F     {
; 0000 0210     rst_count =0;
	LDI  R30,LOW(0)
	STS  _rst_count,R30
	STS  _rst_count+1,R30
; 0000 0211     }
_0x8E:
; 0000 0212 }
	RET
; .FEND
;
;void process_check(void)
; 0000 0215 {
_process_check:
; .FSTART _process_check
; 0000 0216     if (on_fl)
	SBRS R3,0
	RJMP _0x8F
; 0000 0217     {
; 0000 0218     if (delaystatus ==1)
	SBIS 0x16,0
	RJMP _0x90
; 0000 0219         {
; 0000 021A         relay =0;        //off delay
	CBI  0x12,1
; 0000 021B         }
; 0000 021C     else
	RJMP _0x93
_0x90:
; 0000 021D         {
; 0000 021E         relay =1;       //on delay
	SBI  0x12,1
; 0000 021F         }
_0x93:
; 0000 0220     increment_value(&ontime,0,9959,0);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x18
	LDI  R30,LOW(9959)
	LDI  R31,HIGH(9959)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _increment_value
; 0000 0221         if (ontime >= set[0])
	LDS  R30,_set
	LDS  R31,_set+1
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x96
; 0000 0222         {
; 0000 0223         if (delaystatus ==1)
	SBIS 0x16,0
	RJMP _0x97
; 0000 0224             {
; 0000 0225             relay =1;  //off delay
	SBI  0x12,1
; 0000 0226             }
; 0000 0227         else
	RJMP _0x9A
_0x97:
; 0000 0228             {
; 0000 0229             relay=0;    //on_delay
	CBI  0x12,1
; 0000 022A             }
_0x9A:
; 0000 022B //        ontime=0;
; 0000 022C //        offtime =0;
; 0000 022D         on_fl=0;
	CLT
	BLD  R3,0
; 0000 022E         }
; 0000 022F     }
_0x96:
; 0000 0230 
; 0000 0231 
; 0000 0232 
; 0000 0233 }
_0x8F:
	RET
; .FEND
;
;void eeprom_transfer(void)
; 0000 0236 {
_eeprom_transfer:
; .FSTART _eeprom_transfer
; 0000 0237 set[0] = ee_set[0];
	RCALL SUBOPT_0x23
; 0000 0238 set[1] = ee_set[1];
	__POINTW2MN _ee_set,2
	CALL __EEPROMRDW
	__PUTW1MN _set,2
; 0000 0239 }
	RET
; .FEND
;
;void init(void)
; 0000 023C {
_init:
; .FSTART _init
; 0000 023D // Input/Output Ports initialization
; 0000 023E // Port A initialization
; 0000 023F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0240 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0241 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 0242 PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	OUT  0x1B,R30
; 0000 0243 
; 0000 0244 // Port B initialization
; 0000 0245 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0246 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0247 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0248 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0249 
; 0000 024A // Port C initialization
; 0000 024B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 024C DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x14,R30
; 0000 024D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 024E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 024F 
; 0000 0250 // Port D initialization
; 0000 0251 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0252 DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(135)
	OUT  0x11,R30
; 0000 0253 // State: Bit7=0 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=1 Bit1=1 Bit0=1
; 0000 0254 PORTD=(0<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(127)
	OUT  0x12,R30
; 0000 0255 
; 0000 0256 // Timer/Counter 0 initialization
; 0000 0257 // Clock source: System Clock
; 0000 0258 // Clock value: Timer 0 Stopped
; 0000 0259 // Mode: Normal top=0xFF
; 0000 025A // OC0 output: Disconnected
; 0000 025B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 025C TCNT0=0x00;
	OUT  0x32,R30
; 0000 025D OCR0=0x00;
	OUT  0x3C,R30
; 0000 025E 
; 0000 025F // Timer/Counter 1 initialization
; 0000 0260 // Clock source: System Clock
; 0000 0261 // Clock value: 46.875 kHz
; 0000 0262 // Mode: Normal top=0xFFFF
; 0000 0263 // OC1A output: Disconnected
; 0000 0264 // OC1B output: Disconnected
; 0000 0265 // Noise Canceler: Off
; 0000 0266 // Input Capture on Falling Edge
; 0000 0267 // Timer Period: 1 s
; 0000 0268 // Timer1 Overflow Interrupt: On
; 0000 0269 // Input Capture Interrupt: Off
; 0000 026A // Compare A Match Interrupt: Off
; 0000 026B // Compare B Match Interrupt: Off
; 0000 026C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 026D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 026E TCNT1H=0x48;
	LDI  R30,LOW(72)
	OUT  0x2D,R30
; 0000 026F TCNT1L=0xE5;
	LDI  R30,LOW(229)
	OUT  0x2C,R30
; 0000 0270 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0271 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0272 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0273 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0274 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0275 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0276 
; 0000 0277 // Timer/Counter 2 initialization
; 0000 0278 // Clock source: System Clock
; 0000 0279 // Clock value: Timer2 Stopped
; 0000 027A // Mode: Normal top=0xFF
; 0000 027B // OC2 output: Disconnected
; 0000 027C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 027D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 027E TCNT2=0x00;
	OUT  0x24,R30
; 0000 027F OCR2=0x00;
	OUT  0x23,R30
; 0000 0280 
; 0000 0281 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0282 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0283 
; 0000 0284 // External Interrupt(s) initialization
; 0000 0285 // INT0: Off
; 0000 0286 // INT1: Off
; 0000 0287 // INT2: Off
; 0000 0288 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0289 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 028A 
; 0000 028B // USART initialization
; 0000 028C // USART disabled
; 0000 028D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 028E 
; 0000 028F // Analog Comparator initialization
; 0000 0290 // Analog Comparator: Off
; 0000 0291 // The Analog Comparator's positive input is
; 0000 0292 // connected to the AIN0 pin
; 0000 0293 // The Analog Comparator's negative input is
; 0000 0294 // connected to the AIN1 pin
; 0000 0295 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0296 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0297 
; 0000 0298 // ADC initialization
; 0000 0299 // ADC disabled
; 0000 029A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 029B 
; 0000 029C // SPI initialization
; 0000 029D // SPI disabled
; 0000 029E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 029F 
; 0000 02A0 // TWI initialization
; 0000 02A1 // TWI disabled
; 0000 02A2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02A3 
; 0000 02A4 }
	RET
; .FEND
;
;void main(void)
; 0000 02A7 {
_main:
; .FSTART _main
; 0000 02A8 // Declare your local variables here
; 0000 02A9 init();
	RCALL _init
; 0000 02AA 
; 0000 02AB eeprom_transfer();
	RCALL _eeprom_transfer
; 0000 02AC // Global enable interrupts
; 0000 02AD #asm("sei")
	sei
; 0000 02AE on_fl =1;
	SET
	BLD  R3,0
; 0000 02AF     if (delaystatus ==1)
	SBIS 0x16,0
	RJMP _0x9D
; 0000 02B0         {
; 0000 02B1         relay =0;        //off delay
	CBI  0x12,1
; 0000 02B2         }
; 0000 02B3     else
	RJMP _0xA0
_0x9D:
; 0000 02B4         {
; 0000 02B5         relay =1;       //on delay
	SBI  0x12,1
; 0000 02B6         }
_0xA0:
; 0000 02B7 while (1)
_0xA3:
; 0000 02B8       {
; 0000 02B9       if (sec_fl)
	SBRS R2,1
	RJMP _0xA6
; 0000 02BA         {
; 0000 02BB         sec_fl =0;
	CLT
	BLD  R2,1
; 0000 02BC         reset_timer();
	RCALL _reset_timer
; 0000 02BD 
; 0000 02BE         }
; 0000 02BF       if (min_fl)
_0xA6:
	SBRS R3,1
	RJMP _0xA7
; 0000 02C0       {
; 0000 02C1       min_fl=0;
	CLT
	BLD  R3,1
; 0000 02C2       process_check();
	RCALL _process_check
; 0000 02C3       }
; 0000 02C4 
; 0000 02C5       // Place your code here
; 0000 02C6             display_check();
_0xA7:
	RCALL _display_check
; 0000 02C7         //display_put(timer1,timer2,0,dummy,dummy2);                       //**
; 0000 02C8       check_set();
	RCALL _check_set
; 0000 02C9       display_out(display_count);
	MOVW R26,R8
	RCALL _display_out
; 0000 02CA       display_count++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 02CB       led_check();
	RCALL _led_check
; 0000 02CC       if(display_count >=9)
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0xA8
; 0000 02CD       {
; 0000 02CE       display_count =0;
	CLR  R8
	CLR  R9
; 0000 02CF       key_check();
	RCALL _key_check
; 0000 02D0       }
; 0000 02D1       }
_0xA8:
	RJMP _0xA3
; 0000 02D2 }
_0xA9:
	RJMP _0xA9
; .FEND

	.DSEG
_segment_table:
	.BYTE 0x22
_display_buffer:
	.BYTE 0x12
_dummy:
	.BYTE 0x2
_dummy2:
	.BYTE 0x2
_message_set:
	.BYTE 0x108
_set:
	.BYTE 0x14
_key_count:
	.BYTE 0x2
_key_rst_cnt:
	.BYTE 0x2
_set_count:
	.BYTE 0x2

	.ESEG
_ee_set:
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0

	.DSEG
_min_cnt:
	.BYTE 0x2
_rst_count:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __ANEGW1
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	STS  _display_buffer,R30
	STS  _display_buffer+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL __DIVW21
	STS  _display_buffer,R30
	STS  _display_buffer+1,R31
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CALL __MODW21
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL __DIVW21
	__PUTW1MN _display_buffer,2
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	CALL __DIVW21
	__PUTW1MN _display_buffer,4
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__PUTW1MN _display_buffer,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	__POINTW1MN _display_buffer,8
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL __DIVW21
	__PUTW1MN _display_buffer,8
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	CALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	CALL __DIVW21
	__PUTW1MN _display_buffer,10
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	CALL __DIVW21
	__PUTW1MN _display_buffer,12
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x12:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	STS  _display_buffer,R30
	STS  _display_buffer+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,2
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,2
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,2
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,4
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,2
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:50 WORDS
SUBOPT_0x13:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW2
	LD   R26,Y
	LDD  R27,Y+1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,8
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,2
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,10
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,2
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	__PUTW1MN _display_buffer,12
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,2
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	ST   -Y,R13
	ST   -Y,R12
	MOVW R30,R12
	LDI  R26,LOW(_set)
	LDI  R27,HIGH(_set)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_message_set)
	LDI  R31,HIGH(_message_set)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_dummy)
	LDI  R27,HIGH(_dummy)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R30,_set
	LDS  R31,_set+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	LDI  R30,LOW(1)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	CALL __SAVELOCR6
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R16,R30
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R18,R30
	__CPWRN 18,19,60
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	MOVW R30,R16
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	ADD  R30,R18
	ADC  R31,R19
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x20:
	MOVW R30,R12
	LDI  R26,LOW(_ee_set)
	LDI  R27,HIGH(_ee_set)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R12
	LDI  R26,LOW(_set)
	LDI  R27,HIGH(_set)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9959)
	LDI  R31,HIGH(9959)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _key_rst_cnt,R30
	STS  _key_rst_cnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_ee_set)
	LDI  R27,HIGH(_ee_set)
	CALL __EEPROMRDW
	STS  _set,R30
	STS  _set+1,R31
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
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

;END OF CODE MARKER
__END_OF_CODE:
