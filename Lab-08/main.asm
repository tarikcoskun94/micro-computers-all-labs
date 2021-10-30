; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST 	P=16F877A
INCLUDE	P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
radix	dec

    
    
    
;--------------------| BEGIN OF THE VARIABLE SECTION |--------------------
    
;DEFINES
    
    ;SSDCodes values
    zero	    EQU	B'00111111' ; 0
    one		    EQU	B'00000110' ; 1
    two		    EQU	B'01011011' ; 2
    three	    EQU	B'01001111' ; 3
    four	    EQU	B'01100110' ; 4
    five	    EQU	B'01101101' ; 5
    six		    EQU	B'01111101' ; 6
    seven	    EQU	B'00000111' ; 7
    eight	    EQU	B'01111111' ; 8
    nine	    EQU	B'01101111' ; 9
   
    
variablesInMain	    UDATA  
	    
    counter	    RES	1
    DigitBits	    RES	10
		    		      	
;---------------------| END OF THE VARIABLE SECTION |---------------------
		    
		    
		    
		    
;-----------------| BEGIN OF THE INITIALIZATION SECTION |-----------------
		    
org 0x00 ; Reset vector
		    
BSF     STATUS, RP0 ; Select Bank1

MOVLW 0x06
MOVWF ADCON1
		    
CLRF	TRISA ; Set all pins of PORTA as output
		    
CLRF	TRISB
DECF	TRISB,	F ; Set all pins of PORTB as input

CLRF    TRISD ; Set all pins of PORTD as output
		    
BCF     STATUS, RP0 ; Select Bank0  
		    
CLRF    PORTA	; Turn off all LEDs connected to PORTA
		    
CLRF    PORTB	; Turn off all LEDs connected to PORTB
		    
CLRF    PORTD	; Turn off all LEDs connected to PORTD

;------------------| END OF THE INITIALIZATION SECTION |------------------
		    
		    
		    
		    
;--------------------| BEGIN OF THE MAIN CODE SECTION |-------------------

MOVLW	DigitBits
MOVWF	FSR

MOVLW	zero
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	one
MOVWF	INDF
INCF	FSR, F

MOVLW	two
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	three
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	four
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	five
MOVWF	INDF
INCF	FSR, F

MOVLW	six
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	seven
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	eight
MOVWF	INDF
INCF	FSR, F
		    
MOVLW	nine
MOVWF	INDF
		    
;*************************************************************************		    

BSF	PORTA, RA5 ; PORTA5 = 1
		    
CLRF	counter ; counter = 0

;*************************************************************************		    
		    
L_infinite_while: ; while (1)
    L_if_1: ; If (button3 is pressed)
	L_if_1_condition:
	    BTFSC   PORTB, RB3
	    GOTO    L_else_1_if_1 ; (button3 is pressed)
	
	L_if_2: ; If (counter == 9)
	    L_if_2_condition:
		MOVLW	0x09
		SUBWF	counter, W
		BTFSS	STATUS, Z
		GOTO	L_else_default_if_2 ; (counter == 9)
		
	    CLRF    counter ; counter = 0
	    
	    GOTO    L_end_of_the_if_1
		
	L_else_default_if_2: ; else
	    INCF    counter, F ; counter++
	    
	    GOTO    L_end_of_the_if_1
	    
	    
    L_else_1_if_1: ; else if (button4 is pressed)
	L_else_1_if_1_condition:
	    BTFSC   PORTB, RB4
	    GOTO    L_else_2_if_1 ; (button4 is pressed)
	    
	L_if_3: ; If (counter == 0)
	    L_if_3_condition:
		MOVLW	0x00
		SUBWF	counter, W
		BTFSS	STATUS, Z
		GOTO	L_else_default_if_3 ; (counter == 0)
		
	    MOVLW   0x09
	    MOVWF   counter ; counter = 9
	    
	    GOTO    L_end_of_the_if_1
		
	L_else_default_if_3: ; else
	    DECF    counter, F ; counter--
	    
	    GOTO    L_end_of_the_if_1
    
    
    L_else_2_if_1: ; else if (button5 is pressed)
	L_else_2_if_1_condition:
	    BTFSC   PORTB, RB5
	    GOTO    L_end_of_the_if_1 ; (button5 is pressed)
	    
	CLRF    counter ; counter = 0
    
    L_end_of_the_if_1:
    
    
    MOVLW   DigitBits
    ADDWF   counter, W
    MOVWF   FSR ; DigitBits[counter]
	
    MOVFW   INDF
    MOVWF   PORTD ; PORTD = DigitBits[counter]
    
    
    L_if_4: ; If (any of the buttons is pressed)
	L_if_4_condition_1:
	    BTFSS   PORTB, RB3
	    GOTO    L_if_4_process ; (any of the buttons is pressed)
	    
	L_if_4_condition_2:
	    BTFSS   PORTB, RB4
	    GOTO    L_if_4_process ; (any of the buttons is pressed)
	    
	L_if_4_condition_3:
	    BTFSS   PORTB, RB5
	    GOTO    L_if_4_process ; (any of the buttons is pressed)
	
	GOTO	L_end_of_the_if_4
	
	L_if_4_process:
    
	CALL	Delay100ms
    
    L_end_of_the_if_4:
    
    GOTO    L_infinite_while
L_break_the_infinite_while:
	    
;---------------------| END OF THE MAIN CODE SECTION |--------------------
	    

	    
	   
;------------------| BEGIN OF THE FUNCTION CODE SECTION |-----------------

Delay100ms:
i	EQU	    0x70		    ; Use memory slot 0x70
j	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'100'		    ; 
	MOVWF	    i			    ; i = 100
Delay100ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay100ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay100ms_InnerLoop

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay100ms_OuterLoop    
	RETURN
    
;-------------------| END OF THE FUNCTION CODE SECTION |------------------

END