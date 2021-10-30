; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST 	P=16F877A
INCLUDE	P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
radix	dec

    
    
    
;--------------------| BEGIN OF THE VARIABLE SECTION |--------------------
    
;DEFINES
    
    MOVE_LEFT	    EQU	0x0 ; #define MOVE_LEFT 0
    MOVE_RIGHT	    EQU	0x1 ; #define MOVE_RIGHT 1
	    
    
variablesInMain	    UDATA  
	    
    dir		    RES	1
    val		    RES	1
    count	    RES	1

		    
variablesInLocal    UDATA
    
    ; F_delay250ms: - F_Delay500ms:
    delayVar1	    RES	1
    delayVar2	    RES	1
    delayVar3	    RES	1
		    
		    
variablesForIndexes UDATA
    
    i		    RES	1
   	
;---------------------| END OF THE VARIABLE SECTION |---------------------
		    
		    
		    
		    
;-----------------| BEGIN OF THE INITIALIZATION SECTION |-----------------
		    
org 0x00 ; Reset vector
		    
BSF     STATUS, RP0 ; Select Bank1
		    
CLRF	TRISB ; Set all pins of PORTB as output
		    
CLRF    TRISD ; Set all pins of PORTD as output
		    
BCF     STATUS, RP0 ; Select Bank0  
		    
CLRF    PORTB	; Turn off all LEDs connected to PORTB
		    
CLRF    PORTD	; Turn off all LEDs connected to PORTD

;------------------| END OF THE INITIALIZATION SECTION |------------------
		    
		    
		    
		    
;--------------------| BEGIN OF THE MAIN CODE SECTION |-------------------

MOVLW	MOVE_LEFT
MOVWF	dir ; uint8_t dir = MOVE_LEFT
		    
MOVLW	0x1
MOVWF	val ; uint8_t val = 0x1
		    
CLRF	count ; uint8_t count = 0

;*************************************************************************		    
		    
L_infinite_while: ; while (1)
    MOVFW   val
    MOVWF   PORTD ; PORTD = val
    
    CALL    F_delay ; Delay()
    
    INCF    count, F ; count++
    
    L_if_1: ; if (count == 15)
	L_if_1_condition:
	    MOVFW   count
	    SUBLW   0xF
	    BTFSS   STATUS, Z  ; (count == 15)
	    GOTO    L_if_1_else
	    
	CLRF	PORTD ; PORTD = 0
	
	CALL    F_delay ; Delay()
	
	DECF	PORTD ;	PORTD = 0xFF;
	
	CALL    F_delay ; Delay()
	
	CLRF	PORTD ; PORTD = 0
	
	CALL    F_delay ; Delay()
	
	DECF	PORTD ;	PORTD = 0xFF;
	
	CALL    F_delay ; Delay()
	
	CLRF	PORTD ; PORTD = 0
	
	CALL    F_delay ; Delay()
	
	MOVLW	0x1
	MOVWF	val ; val = 0x1
	
	CLRF	count ; count = 0
	
	MOVLW	MOVE_LEFT
	MOVWF	dir ; dir = MOVE_LEFT
	
	GOTO 	L_end_of_the_if_1
	
    L_if_1_else: ; else
    
	L_if_2: ; if (val == 0x80)
	    L_if_2_condition:
		MOVFW   val
		SUBLW   0x80
		BTFSS   STATUS, Z ; (val == 0x80)
		GOTO    L_end_of_the_if_2
		
	    MOVLW   MOVE_RIGHT
	    MOVWF   dir ; dir = MOVE_RIGHT
		
	L_end_of_the_if_2:
    
	L_if_3: ; if (dir == MOVE_LEFT)
	    L_if_3_condition:
		MOVFW   dir
		SUBLW   MOVE_LEFT
		BTFSS   STATUS, Z ; (dir == MOVE_LEFT)
		GOTO    L_if_3_else
		
	    BCF	    STATUS, C ; Carry bit sets as zero to rotate
		
	    RLF	    val, F ; val = val << 1
	    
	    GOTO    L_end_of_the_if_3
	    
	L_if_3_else:
	    RRF	    val, F ; val = val >> 1
    
	L_end_of_the_if_3:
    
    L_end_of_the_if_1:
    
    GOTO    L_infinite_while
L_break_the_infinite_while:
	    
;---------------------| END OF THE MAIN CODE SECTION |--------------------
	    

	    
	   
;------------------| BEGIN OF THE FUNCTION CODE SECTION |-----------------

F_delay:
    CALL F_delay250ms
    
    ;CALL F_Delay500ms
    
RETURN ; void
		 
;*************************************************************************

F_Delay500ms:
	MOVLW	    d'2'
	MOVWF	    delayVar1
    L_Delay500ms_Loop1_Begin:
	MOVLW	    d'250'
	MOVWF	    delayVar2
    L_Delay500ms_Loop2_Begin:
	MOVLW	    d'250'
	MOVWF	    delayVar3
    L_Delay500ms_Loop3_Begin:
	NOP
	DECFSZ	    delayVar3, F
	GOTO	    L_Delay500ms_Loop3_Begin

	DECFSZ	    delayVar2, F
	GOTO	    L_Delay500ms_Loop2_Begin

	DECFSZ	    delayVar1, F
	GOTO	    L_Delay500ms_Loop1_Begin
    
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