
;CodeVisionAVR C Compiler V2.60 Evaluation
;(C) Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny13
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 16 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Automatic register allocation for global variables: On
;Smart register allocation: Off

	#pragma AVRPART ADMIN PART_NAME ATtiny13
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 64
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
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
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tuner_start_vol=R4
	.DEF _tuner_end_vol=R5
	.DEF _adc_vol_1800ma=R6
	.DEF _i=R7
	.DEF _key1_pressed_counter=R8
	.DEF _key2_pressed_counter=R10
	.DEF _Iout=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x55,0xC8,0x8E,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0xF
_0x5:
	.DB  0x1
_0x6:
	.DB  0xA
_0x7:
	.DB  0x32
_0x8:
	.DB  0xA

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V2.60 Evaluation
;Automatic Program Generator
;© Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 01.10.2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny13
;AVR Core Clock frequency: 9,600000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 16
;*******************************************************/
;
;#include <tiny13.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;#define LED PORTB.4
;
;const char corr=1;   //Коррекция при настройке максимума тока (шаг назад)

	.DSEG
;const int key_pressed_counter_max=15;
;const int key_pressed_counter_min=1;
;const int main_delay=10;        //задержка в основном цикле программы
;unsigned char tuner_start_vol=85;     //начальное значение ШИМ при настройке тока
;unsigned char tuner_end_vol=200;    //конечное значение ШИМ при настройке тока
;const int tune_delay=50;   //задержка при настройке тока
;unsigned char adc_vol_1800ma=142;//значение ADC при 1,8А (подбирается опытным путем)
;//130=1.7A; 140=1.8A
;const unsigned char rise_limit=10;//предел спада тока при настройке на максимум (в значениях ADC)
;
;unsigned char i; //итератор
;int key1_pressed_counter=0;//считает, как долго нажата кнопка 1
;int key2_pressed_counter=0;//считает, как долго нажата кнопка 1
;
;unsigned char Iout;
;
;#define ADC_VREF_TYPE ((1<<REFS0) | (1<<ADLAR))
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0034 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0035 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0036 // Delay needed for the stabilization of the ADC input voltage
; 0000 0037 delay_us(10);
	__DELAY_USB 27
; 0000 0038 // Start the AD conversion
; 0000 0039 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 003A // Wait for the AD conversion to complete
; 0000 003B while ((ADCSRA & (1<<ADIF))==0);
_0x9:
	SBIC 0x6,4
	RJMP _0xB
	RJMP _0x9
_0xB:
; 0000 003C ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 003D return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 003E }
; .FEND
;
;void blink_led()
; 0000 0041 {
_blink_led:
; .FSTART _blink_led
; 0000 0042     if(LED==0){LED=1;}else{LED=0;}
	SBIC 0x18,4
	RJMP _0xC
	SBI  0x18,4
	RJMP _0xF
_0xC:
	CBI  0x18,4
_0xF:
; 0000 0043 }
	RET
; .FEND
;
;unsigned char tune_peak()                    // настройка на максимум тока
; 0000 0046 {
_tune_peak:
; .FSTART _tune_peak
; 0000 0047     unsigned char Iout_max=0;      //теущее значение максимального тока
; 0000 0048     unsigned char Iout_max_PWMvol=0;     //значение PWM при этом токе
; 0000 0049 
; 0000 004A      delay_ms(100);
	RCALL __SAVELOCR2
;	Iout_max -> R16
;	Iout_max_PWMvol -> R17
	LDI  R16,0
	LDI  R17,0
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 004B 
; 0000 004C  for(i=OCR0A;i<=tuner_end_vol;i++)
	IN   R7,54
_0x13:
	CP   R5,R7
	BRSH PC+2
	RJMP _0x14
; 0000 004D     {
; 0000 004E         blink_led();    //пока настраивается - мигаем светодиодом
	RCALL _blink_led
; 0000 004F         OCR0A=i;
	OUT  0x36,R7
; 0000 0050         delay_ms(tune_delay);
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	RCALL _delay_ms
; 0000 0051         Iout=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOV  R12,R30
; 0000 0052         if(Iout>Iout_max){Iout_max=Iout;Iout_max_PWMvol=i;}
	CP   R16,R12
	BRLO PC+2
	RJMP _0x15
	MOV  R16,R12
	MOV  R17,R7
; 0000 0053         if((Iout_max-Iout)>rise_limit){break;}   //прерывание цикла, если пошел спад тока
_0x15:
	MOV  R26,R16
	SUB  R26,R12
	CPI  R26,LOW(0xB)
	BRSH PC+2
	RJMP _0x16
	RJMP _0x14
; 0000 0054     }
_0x16:
_0x12:
	INC  R7
	RJMP _0x13
_0x14:
; 0000 0055 
; 0000 0056    if(i>=tuner_end_vol){return 0;}     //не удалось найти пик (спада не было)
	CP   R7,R5
	BRSH PC+2
	RJMP _0x17
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0057     OCR0A=tuner_start_vol;            //установка минимального значения тока,
_0x17:
	OUT  0x36,R4
; 0000 0058     delay_ms(100);                          //т.к. у блока питания гистерезис
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0059     OCR0A=Iout_max_PWMvol-corr;        //установка максимального значения тока минус значение коррекции
	MOV  R30,R17
	SUBI R30,LOW(1)
	OUT  0x36,R30
; 0000 005A 
; 0000 005B return Iout_max_PWMvol; //возврат значения PWM, которое было при максимальном токе (либо возврат нуля)
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 005C }
; .FEND
;
;unsigned char tune_peak_or_current(unsigned char adc_vol) //подбор PWM, чтобы на ADC было adc_vol или настройка на максимум тока
; 0000 005F {
_tune_peak_or_current:
; .FSTART _tune_peak_or_current
; 0000 0060     unsigned char Iout_max=0;      //теущее значение максимального тока
; 0000 0061     unsigned char Iout_max_PWMvol=0;     //значение PWM при этом токе
; 0000 0062 
; 0000 0063      delay_ms(100);
	ST   -Y,R26
	RCALL __SAVELOCR2
;	adc_vol -> Y+2
;	Iout_max -> R16
;	Iout_max_PWMvol -> R17
	LDI  R16,0
	LDI  R17,0
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0064 
; 0000 0065  for(i=OCR0A;i<=tuner_end_vol;i++)
	IN   R7,54
_0x19:
	CP   R5,R7
	BRSH PC+2
	RJMP _0x1A
; 0000 0066     {
; 0000 0067         blink_led();    //пока настраивается - мигаем светодиодом
	RCALL _blink_led
; 0000 0068         OCR0A=i;
	OUT  0x36,R7
; 0000 0069         delay_ms(tune_delay);
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	RCALL _delay_ms
; 0000 006A         Iout=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOV  R12,R30
; 0000 006B         if(Iout>Iout_max){Iout_max=Iout;Iout_max_PWMvol=i;}
	CP   R16,R12
	BRLO PC+2
	RJMP _0x1B
	MOV  R16,R12
	MOV  R17,R7
; 0000 006C         if((Iout_max-Iout)>rise_limit){break;}   //прерывание цикла, если пошел спад тока
_0x1B:
	MOV  R26,R16
	SUB  R26,R12
	CPI  R26,LOW(0xB)
	BRSH PC+2
	RJMP _0x1C
	RJMP _0x1A
; 0000 006D         if(Iout>=adc_vol){return i;}               //Настроился ток. Возвращаем значение PWM
_0x1C:
	LDD  R30,Y+2
	CP   R12,R30
	BRSH PC+2
	RJMP _0x1D
	MOV  R30,R7
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; 0000 006E     }
_0x1D:
_0x18:
	INC  R7
	RJMP _0x19
_0x1A:
; 0000 006F 
; 0000 0070     OCR0A=tuner_start_vol;            //установка минимального значения тока,
	OUT  0x36,R4
; 0000 0071     delay_ms(100);                          //т.к. у блока питания гистерезис
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0072     OCR0A=Iout_max_PWMvol-corr;        //установка максимального значения тока минус значение коррекции
	MOV  R30,R17
	SUBI R30,LOW(1)
	OUT  0x36,R30
; 0000 0073 
; 0000 0074 return 0; //возврат нуля, т.к. ток не настроился
	LDI  R30,LOW(0)
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; 0000 0075 }
; .FEND
;
;/*unsigned char tune(unsigned char adc_vol)   //подбор PWM, чтобы на ADC было adc_vol
;{
;     OCR0A=tuner_start_vol;
;     delay_ms(100);
;
;     if(read_adc(3)>=adc_vol){return 0;}   //ток сразу больше, чем надо настроить - ошибка
;
;    for(i=tuner_start_vol;i<=tuner_end_vol;i++)
;    {
;        blink_led();    //пока настраивается - мигаем светодиодом
;        OCR0A=i;
;        delay_ms(tune_delay);
;        Iout=read_adc(3);
;        if(Iout>=adc_vol){return i;}               //Настройка удалась. Возвращаем значение PWM
;    }
;
;return 0;        //Не удалось настроиться на adc_vol
;} */
;
;void main(void)
; 0000 008B {
_main:
; .FSTART _main
; 0000 008C // Declare your local variables here
; 0000 008D 
; 0000 008E // Crystal Oscillator division factor: 1
; 0000 008F #pragma optsize-
; 0000 0090 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0091 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0092 #ifdef _OPTIMIZE_SIZE_
; 0000 0093 #pragma optsize+
; 0000 0094 #endif
; 0000 0095 
; 0000 0096 // Input/Output Ports initialization
; 0000 0097 // Port B initialization
; 0000 0098 // Function: Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0099 DDRB=(1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(49)
	OUT  0x17,R30
; 0000 009A // State: Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 009B PORTB=(0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 009C 
; 0000 009D // Timer/Counter 0 initialization
; 0000 009E // Clock source: System Clock
; 0000 009F // Clock value: 9600,000 kHz
; 0000 00A0 // Mode: Fast PWM top=0xFF
; 0000 00A1 // OC0A output: Non-Inverted PWM
; 0000 00A2 // OC0B output: Disconnected
; 0000 00A3 // Timer Period: 0,032 ms
; 0000 00A4 // Output Pulse(s):
; 0000 00A5 // OC0A Period: 0,032 ms Width: 0 us
; 0000 00A6 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(131)
	OUT  0x2F,R30
; 0000 00A7 //(0<<COM0B1) - PWM B off
; 0000 00A8 //(1<<COM0B1) - PWM B off
; 0000 00A9 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 00AA 
; 0000 00AB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00AC OCR0A=85;
	LDI  R30,LOW(85)
	OUT  0x36,R30
; 0000 00AD 
; 0000 00AE // Timer/Counter 0 Interrupt(s) initialization
; 0000 00AF TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00B0 
; 0000 00B1 // External Interrupt(s) initialization
; 0000 00B2 // INT0: Off
; 0000 00B3 // Interrupt on any change on pins PCINT0-5: Off
; 0000 00B4 GIMSK=(0<<INT0) | (0<<PCIE);
	OUT  0x3B,R30
; 0000 00B5 MCUCR=(0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00B6 
; 0000 00B7 // Analog Comparator initialization
; 0000 00B8 // Analog Comparator: Off
; 0000 00B9 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00BA DIDR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00BB 
; 0000 00BC // ADC initialization
; 0000 00BD // ADC Clock frequency: 1000,000 kHz
; 0000 00BE // ADC Bandgap Voltage Reference: On
; 0000 00BF // ADC Auto Trigger Source: Free Running
; 0000 00C0 // Only the 8 most significant bits of
; 0000 00C1 // the AD conversion result are used
; 0000 00C2 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00C3 DIDR0|=(0<<ADC0D) | (0<<ADC2D) | (0<<ADC3D) | (0<<ADC1D);
	IN   R30,0x14
	OUT  0x14,R30
; 0000 00C4 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00C5 ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(163)
	OUT  0x6,R30
; 0000 00C6 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 00C7 
; 0000 00C8 if(tune_peak_or_current(adc_vol_1800ma))
	MOV  R26,R6
	RCALL _tune_peak_or_current
	CPI  R30,0
	BRNE PC+2
	RJMP _0x1E
; 0000 00C9 {LED=1;}else{LED=0;}   //Настройка на заданный ток удалась - включаем светодиод
	SBI  0x18,4
	RJMP _0x21
_0x1E:
	CBI  0x18,4
_0x21:
; 0000 00CA 
; 0000 00CB while (1)
_0x24:
; 0000 00CC       {
; 0000 00CD       // Place your code here
; 0000 00CE 
; 0000 00CF             if(PINB.1==0){key1_pressed_counter=0;}
	SBIC 0x16,1
	RJMP _0x27
	CLR  R8
	CLR  R9
; 0000 00D0             if(PINB.1==1){key1_pressed_counter++;}
_0x27:
	SBIS 0x16,1
	RJMP _0x28
	__GETW1R 8,9
	ADIW R30,1
	__PUTW1R 8,9
	SBIW R30,1
; 0000 00D1             if(key1_pressed_counter==key_pressed_counter_max){key1_pressed_counter=0;}
_0x28:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x29
	CLR  R8
	CLR  R9
; 0000 00D2 
; 0000 00D3 
; 0000 00D4             if(PINB.2==0){key2_pressed_counter=0;}
_0x29:
	SBIC 0x16,2
	RJMP _0x2A
	CLR  R10
	CLR  R11
; 0000 00D5             if(PINB.2==1){key2_pressed_counter++;}
_0x2A:
	SBIS 0x16,2
	RJMP _0x2B
	__GETW1R 10,11
	ADIW R30,1
	__PUTW1R 10,11
	SBIW R30,1
; 0000 00D6             if(key2_pressed_counter==key_pressed_counter_max){key2_pressed_counter=0;}
_0x2B:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R10
	CPC  R31,R11
	BREQ PC+2
	RJMP _0x2C
	CLR  R10
	CLR  R11
; 0000 00D7 
; 0000 00D8 
; 0000 00D9            delay_ms(main_delay);
_0x2C:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL _delay_ms
; 0000 00DA 
; 0000 00DB 
; 0000 00DC 
; 0000 00DD            if((key1_pressed_counter==key_pressed_counter_min)&&(key2_pressed_counter==0))    //если кнопка 1, то увеличение тока
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x2E
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ PC+2
	RJMP _0x2E
	RJMP _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 00DE            {
; 0000 00DF                 LED=1;
	SBI  0x18,4
; 0000 00E0                 delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00E1                 OCR0A++;
	IN   R30,0x36
	SUBI R30,-LOW(1)
	OUT  0x36,R30
; 0000 00E2                 LED=0;
	CBI  0x18,4
; 0000 00E3            }
; 0000 00E4 
; 0000 00E5 
; 0000 00E6           if((key2_pressed_counter==key_pressed_counter_min)&&(key1_pressed_counter==0))     //если кнопка 2, то уменьшение тока
_0x2D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BREQ PC+2
	RJMP _0x35
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ PC+2
	RJMP _0x35
	RJMP _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 00E7            {
; 0000 00E8                 LED=1;
	SBI  0x18,4
; 0000 00E9                 delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00EA                 OCR0A--;
	IN   R30,0x36
	SUBI R30,LOW(1)
	OUT  0x36,R30
; 0000 00EB                 LED=0;
	CBI  0x18,4
; 0000 00EC            }
; 0000 00ED 
; 0000 00EE           if((PINB.1==1)&&(PINB.2==1))     //если нажаты обе кнопки, то настройка на макс тока
_0x34:
	SBIS 0x16,1
	RJMP _0x3C
	SBIS 0x16,2
	RJMP _0x3C
	RJMP _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 00EF           {
; 0000 00F0                 LED=0;
	CBI  0x18,4
; 0000 00F1                 if(tune_peak()){LED=1;}else{LED=0;};
	RCALL _tune_peak
	CPI  R30,0
	BRNE PC+2
	RJMP _0x40
	SBI  0x18,4
	RJMP _0x43
_0x40:
	CBI  0x18,4
_0x43:
; 0000 00F2           }
; 0000 00F3 
; 0000 00F4 
; 0000 00F5       }
_0x3B:
	RJMP _0x24
_0x26:
; 0000 00F6 }
_0x46:
	RJMP _0x46
; .FEND

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
