; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST 	P=16F877A
INCLUDE	P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
radix	dec

    
    
    
;--------------------| BEGIN OF THE VARIABLE SECTION |--------------------
    
;DEFINES
    
    NO_ITERATIONS   EQU	D'90' ; #define NO_ITERATIONS 90
    
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
	    
    digit0	    RES	1
    digit1	    RES	1
    SSDCodes	    RES	10

		    
variablesInLocal    UDATA
    
    ; L_Delay5ms:
    delayVar1	    RES	1
    delayVar2	    RES	1
		    
		    
variablesForIndexes UDATA
    
    i		    RES	1
   	
;---------------------| END OF THE VARIABLE SECTION |---------------------
		    
		    
		    
		    
;-----------------| BEGIN OF THE INITIALIZATION SECTION |-----------------
		    
org 0x00 ; Reset vector
		    
BSF     STATUS, RP0 ; Select Bank1

MOVLW 0x06
MOVWF ADCON1
		    
CLRF	TRISA ; Set all pins of PORTA as output

CLRF    TRISD ; Set all pins of PORTD as output
		    
BCF     STATUS, RP0 ; Select Bank0  
		    
CLRF    PORTA	; Turn off all LEDs connected to PORTA
		    
CLRF    PORTD	; Turn off all LEDs connected to PORTD

;------------------| END OF THE INITIALIZATION SECTION |------------------
		    
		    
		    
		    
;--------------------| BEGIN OF THE MAIN CODE SECTION |-------------------

MOVLW	SSDCodes
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
		    
CLRF	digit0 ; digit0 = 0
CLRF	digit1 ; digit1 = 0

;*************************************************************************		    
		    
L_infinite_while: ; while (1)
    L_for: ; for (int i=0; i<NO_ITERATIONS; i++)
	CLRF	i ; int i=0
	L_for_condition:
	    MOVLW   NO_ITERATIONS
	    SUBWF   i, W
	    BTFSC   STATUS, C ; i<NO_ITERATIONS
	    GOTO    L_break_the_for
	
	BSF	PORTA, RA5 ; PORTA5 = 1
	BCF	PORTA, RA4 ; PORTA4 = 0
	
	MOVLW	SSDCodes
	ADDWF	digit0, W
	MOVWF	FSR ; SSDCodes [digit0]
	
	MOVFW	INDF
	MOVWF	PORTD ; PORTD = SSDCodes [digit0];
	
	CALL	F_Delay5ms ; DelayMs(5);
	
	
	BCF	PORTA, RA5 ; PORTA5 = 0
	BSF	PORTA, RA4 ; PORTA4 = 1
	
	MOVLW	SSDCodes
	ADDWF	digit1, W
	MOVWF	FSR ; SSDCodes[digit1]
	
	MOVFW	INDF
	MOVWF	PORTD ; PORTD = SSDCodes[digit1];
	
	CALL	F_Delay5ms ; DelayMs(5);
	
	INCF	i, F
		
	GOTO	L_for_condition
    L_break_the_for:
    
    INCF    digit0, F ; digit0++
    
    L_if_1: ; if (digit0 == 10)
	L_if_1_condition:
	    MOVLW   D'10'
	    SUBWF   digit0, W
	    BTFSS   STATUS, Z ; (digit0 == 10)
	    GOTO    L_end_of_the_if_1
	    
	CLRF	digit0 ; digit0 = 0
	INCF	digit1, F ; digit1++
	
    L_end_of_the_if_1:
    
    L_if_2: ; if (digit1 == 2 && digit0 == 1)
	L_if_2_condition_1:
	    MOVLW   D'2'
	    SUBWF   digit1, W
	    BTFSS   STATUS, Z ; (digit1 == 2)
	    GOTO    L_end_of_the_if_2
	L_if_2_condition_2:
	    MOVLW   D'1'
	    SUBWF   digit0, W
	    BTFSS   STATUS, Z ; (digit0 == 1)
	    GOTO    L_end_of_the_if_2
	    
	CLRF	digit0
	CLRF	digit1 ; digit1 = digit0 = 0
    
    L_end_of_the_if_2:
    
    GOTO    L_infinite_while
L_break_the_infinite_while:
	    
;---------------------| END OF THE MAIN CODE SECTION |--------------------
	    

	    
	   
;------------------| BEGIN OF THE FUNCTION CODE SECTION |-----------------

F_Delay5ms:
	MOVLW	    d'5'
	MOVWF	    delayVar1
L_Delay5ms_OuterLoop:
	MOVLW	    d'250'
	MOVWF	    delayVar2
L_Delay5ms_InnerLoop:	
	NOP
	DECFSZ	    delayVar2, F
	GOTO	    L_Delay5ms_InnerLoop

	DECFSZ	    delayVar1, F
	GOTO	    L_Delay5ms_OuterLoop
    
RETURN ; void
    
;-------------------| END OF THE FUNCTION CODE SECTION |------------------

END