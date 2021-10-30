; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST 	P=16F877A
INCLUDE	P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
radix	dec

    
    
    
;--------------------| BEGIN OF THE VARIABLE SECTION |--------------------
    
CBLOCK	0x70
    
    sharedOne:	    1
    sharedTwo:	    1
    sharedThree:    1
    sharedFour:	    1
    sharedFive:	    1
    sharedSix:	    1
    
ENDC
	
    
variablesInMain	    UDATA  
	    
    x		    RES 1
    y		    RES 1
    N		    RES 1
    noElements	    RES 1
    sum		    RES 1
    A		    RES 40

		    
variablesInLocal    UDATA
    
    ; F_generateNumbers:
    xPLUSy	    RES	1
    Q		    RES	1
    
    ; F_delay250ms:
    delayVar1	    RES	1
    delayVar2	    RES	1
	
    ;F_multiply:
    zl		    RES	1
    zh		    RES	1
		    
		    
variablesForIndexes UDATA
    
    i		    RES	1
   	
;---------------------| END OF THE VARIABLE SECTION |---------------------
		    
		    
		    
		    
;-----------------| BEGIN OF THE INITIALIZATION SECTION |-----------------
		    
org 0x00 ; Reset vector
		    
BSF     STATUS, RP0 ; Select Bank1
		    
MOVLW	0xFF
MOVWF	TRISB ; Set all pins of PORTB as input
		    
CLRF    TRISD ; Set all pins of PORTD as output
		    
BCF     STATUS, RP0 ; Select Bank0  
		    
CLRF    PORTB	; Turn off all LEDs connected to PORTB
		    
CLRF    PORTD	; Turn off all LEDs connected to PORTD

;------------------| END OF THE INITIALIZATION SECTION |------------------
		    
		    
		    
		    
;--------------------| BEGIN OF THE MAIN CODE SECTION |-------------------
		    
MOVLW	d'97'
MOVWF	x ; uint8_t x = 97
 
	
MOVLW	d'18'
MOVWF	y ; uint8_t y = 18
  
MOVLW	d'105'
MOVWF	N ; uint8_t N = 105
  
;*************************************************************************
  
MOVLW	A
MOVWF	sharedOne ; GenerateNumbers(A,
  
MOVFW	x
MOVWF	sharedTwo ; GenerateNumbers(A, x,
  
MOVFW	y
MOVWF	sharedThree ; GenerateNumbers(A, x, y,
  
MOVFW	N
MOVWF	sharedFour ; GenerateNumbers(A, x, y, N)
  
CALL	F_generateNumbers

MOVWF	noElements ; uint8_t noElements = GenerateNumbers(A, x, y, N)
  
;*************************************************************************

MOVLW	A
MOVWF	sharedOne ; AddNumbers(A,
  
MOVFW	noElements
MOVWF	sharedTwo ; AddNumbers(A, noElements)
  
CALL	F_addNumbers
  
MOVWF	sum ; uint8_t sum = AddNumbers(A, noElements)
	    
;*************************************************************************
  
MOVWF	sharedOne  ; DisplayNumbers(sum,
  
MOVLW	A
MOVWF	sharedTwo ; DisplayNumbers(sum, A)
  
CALL	F_displayNumbers ; DisplayNumbers(sum, A)
  
;*************************************************************************
  
LOOP    GOTO    $ ; while (1);
	    
;---------------------| END OF THE MAIN CODE SECTION |--------------------
	    

	    
	   
;------------------| BEGIN OF THE FUNCTION CODE SECTION |-----------------
  
F_generateNumbers:    
    MOVFW   sharedOne
    MOVWF   FSR ; FSR = *A[0] or FSR = A
   
    
    L_while_1: ; while ((x < N) && (y<N))
	L_while_1_condition:
	    MOVFW   sharedFour
	    SUBWF   sharedTwo, W
	    BTFSC   STATUS, C
	    GOTO    L_break_the_while_1 ; ((x < N)
	    
	    MOVFW   sharedFour
	    SUBWF   sharedThree, W
	    BTFSC   STATUS, C
	    GOTO    L_break_the_while_1 ; ((x < N) && (y < N))
	    
	L_if: ; if ((x + y) % 2)
	    L_if_condition:
		MOVFW   sharedTwo
		ADDWF   sharedThree, W ; ((x + y)
		ANDLW	b'00000001'
		BTFSC   STATUS, Z
		GOTO    L_else ; ((x + y) % 2)
	    
	    MOVFW	sharedTwo
	    MOVWF	sharedFive ; Multiply(x,
  
	    MOVFW	sharedThree
	    MOVWF	sharedSix ; Multiply(x, y)
	    
	    CALL    F_multiply
	    
	    MOVWF   INDF
	    INCF    FSR, F ; A[count++] = Multiply(x, y);
	    
	    INCF    sharedTwo, F ; x = x + 1;
	    
	    GOTO    L_while_1_condition
	    
	L_else:
	    MOVFW   sharedTwo
	    ADDWF   sharedThree, W
	    MOVWF   xPLUSy ; (x + y)
	    
	    CLRF    Q ; Q = 0
	    L_division_by_three:
		MOVLW	d'3'
		SUBWF	xPLUSy
		BTFSS	STATUS, C
		GOTO	L_end_of_the_division_by_three
		INCF	Q, F
		GOTO	L_division_by_three
	    L_end_of_the_division_by_three: ; Q = (x + y) / 3
	    
	    MOVFW   Q
	    MOVWF   INDF
	    INCF    FSR, F ; A[count++] = (x + y) / 3;
	    
	    MOVLW   d'3'
	    ADDWF   sharedThree, F ; y = y + 3
	    
	GOTO    L_while_1_condition
    L_break_the_while_1:
    
    
    MOVFW   sharedOne
    SUBWF   FSR, W ; calculate the count
    
RETURN ; return count

;*************************************************************************

F_addNumbers:
    MOVFW   sharedOne
    MOVWF   FSR ; FSR = *A[0] or FSR = A
    
    CLRF    sum ; uint8_t sum = 0
    
    
    L_for_1: ; for (int i = 0; i < count; i++)
	CLRF	i ; int i = 0
	L_for_1_condition:
	    MOVFW   sharedTwo
	    SUBWF   i, W
	    BTFSC   STATUS, C
	    GOTO    L_break_the_for_1 ; i < count
	    
	MOVFW	INDF
	ADDWF	sum, F ; sum += A[i]
	
	INCF	FSR, F
	INCF	i, F ; i++
	
	GOTO	L_for_1_condition
    L_break_the_for_1:
	    
    
    MOVFW   sum
    
RETURN ; return sum;

;*************************************************************************

F_displayNumbers:
    MOVFW   sharedOne
    MOVWF   PORTD ; PORTD = sum
    
    CALL    F_waitPortbButton3 ; while (PORTB3 == 1)
	
    MOVFW   sharedTwo
    MOVWF   FSR ; FSR = *A[0] or FSR = A
	    
    
    L_for_2: ; (int i = 0; i < 5; i++)
	CLRF	i ; int i = 0
	L_for_2_condition:
	    MOVLW   d'5'
	    SUBWF   i, W
	    BTFSC   STATUS, C
	    GOTO    L_break_the_for_2 ; i < 5
	
	MOVFW	INDF
	MOVWF	PORTD ; PORTD = A[i];
	
	INCF	FSR, F
	INCF	i, F ; i++
	
	CALL	F_delay250ms ; DelayMs(250)
	
	CALL    F_waitPortbButton3 ; while (PORTB3 == 1)
		
	GOTO	L_for_2_condition
    L_break_the_for_2:
    
RETURN ; void

;*************************************************************************

F_multiply:	
    CLRF   zl
    CLRF   zh
    
    L_swapping_for_xTIMESy:
	MOVFW	sharedFive
	SUBWF	sharedSix, W
	BTFSC	STATUS, C
	GOTO	L_end_of_the_swapping_for_xTIMESy
	
	MOVFW	sharedSix
	XORWF	sharedFive, F ; x = x XOR y
	
	MOVFW	sharedFive
	XORWF	sharedSix, F ; y = y XOR x
	
	MOVFW	sharedSix
	XORWF	sharedFive, F ; x = x XOR y
    L_end_of_the_swapping_for_xTIMESy:
    
    L_xTIMESy:
	MOVLW   d'0'
	MOVF    sharedFive, F
	BTFSC   STATUS, Z
	RETURN

	MOVFW    sharedSix
    
	L_xTIMESy_loop:
	    ADDWF	zl, F
	    BTFSC	STATUS, C
	    INCF	zh, F
	    DECFSZ	sharedFive, F
	    GOTO	L_xTIMESy_loop
    L_end_of_the_xTIMESy:
    
    MOVFW   zl
    ADDWF   zh, W
    RETURN ; return p[0] + p[1]

;*************************************************************************

F_waitPortbButton3:
    L_while_waitPortbButton3:  ; while (PORTB3 == 1)
	L_while_waitPortbButton3_condition:
	   BTFSC PORTB, 3 ; (PORTB3 == 1)
	    
	GOTO L_while_waitPortbButton3_condition
    L_break_the_while_waitPortbButton3:
        
RETURN ; void

;*************************************************************************

F_delay250ms:
    L_Delay250ms:
	MOVLW	d'250'
	MOVWF	delayVar1
    L_Delay250ms_OuterLoop:
	MOVLW	d'250'
	MOVWF	delayVar2
    L_Delay250ms_InnerLoop:	
	NOP
	DECFSZ	delayVar2, F
	GOTO	L_Delay250ms_InnerLoop

	DECFSZ	delayVar1, F
	GOTO	L_Delay250ms_OuterLoop
    
RETURN ; void
    
;-------------------| END OF THE FUNCTION CODE SECTION |------------------

END