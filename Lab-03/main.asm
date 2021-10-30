; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; Reset vector
org 0x00
    
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
    
MOVLW 0xFF
MOVWF TRISB ; Set all pins of PORTB as input

CLRF TRISD ; Set all pins of PORTD as output
    
    
BCF STATUS, RP0 ; Select Bank0
    
CLRF PORTD ; Turn off all LEDs connected to PORTD
    
; ---------- Your code starts here --------------------------    
fib0 	EQU	0x21
fib1	EQU	0x22
fib	EQU	0x23
i	EQU	0x24

x	EQU	0x70
y	EQU	0x71
;***************************************************************
;***************************************************************
;***************************************************************
CLRF	fib0

MOVLW	d'1'
MOVWF	fib1

MOVLW	d'2'
MOVWF	i
;***************************************************************
;***************************************************************
;***************************************************************
L_for:
    L_for_condition: ;for (i=2; i<=N; i++)
	MOVF	i, W
	SUBLW	d'13'
	BTFSS	STATUS, C
	GOTO	L_breakTheFor
	INCF	i, F
	

    MOVF    fib0, W ;fib = fib0 + fib1
    ADDWF   fib1, W
    MOVWF   fib
    
    MOVF    fib1, W ;fib0 = fib1
    MOVWF   fib0
    
    MOVF    fib, W ;fib1 = fib
    MOVWF   fib1
    
    MOVWF   PORTD ;PORTD = fib
    
    
    Delay250ms:
	MOVLW	d'250'
	MOVWF	x
    Delay250ms_OuterLoop:
	MOVLW	d'250'
	MOVWF	y
    Delay250ms_InnerLoop:	
	NOP
	DECFSZ	y, F
	GOTO	Delay250ms_InnerLoop

	DECFSZ	x, F
	GOTO	Delay250ms_OuterLoop
	
	
    L_while:
	L_while_condition: ;while (PORTB3 == 1)
	    BTFSC PORTB, RB3
	    GOTO L_while
    
	    
    GOTO    L_for	
L_breakTheFor:
    

MOVLW 0x00
; ---------- Your code ends here ----------------------------
    
MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP GOTO $ ; Infinite loop
END ; End of the program