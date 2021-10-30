; Student 1: Tarik COSKUN - 152120161092
; Student 2: Belal RAHIMI - 152120171077
    
LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; Reset vector
org 0x00
    
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
CLRF TRISB ; Set all pins of PORTB as output
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
    
; ---------- Your code starts here --------------------------
x	EQU 0x21
y	EQU 0x22
box	EQU 0x23
;***************************************************************
;***************************************************************
;***************************************************************
MOVLW d'1'
MOVWF x
	
MOVLW d'2'
MOVWF y
;***************************************************************
;***************************************************************
;***************************************************************
L_if: ;if (x < 0 || x > 11 || y < 0 || y > 10) box = -1
    BTFSC x, 7 ;   |   negative => MSB:1
    GOTO  L_out_of_the_box
	
    MOVF  x, W
    SUBLW d'11' ;   |   11-x => C:0
    BTFSS STATUS, C
    GOTO  L_out_of_the_box
	
    BTFSC y, 7 ;   |   negative => MSB:1
    GOTO  L_out_of_the_box
	
    MOVF  y, W
    SUBLW d'10' ;   |   10-y => C:0
    BTFSC STATUS, C
    GOTO  L_else_if_1
	
    L_out_of_the_box:
    MOVLW -d'1'
    MOVWF box
    GOTO L_next_operations
    
    
L_else_if_1: ;else if (x <= 3)
    MOVF  x, W
    SUBLW d'3' ;   |   3-x => C:1
    BTFSS STATUS, C
    GOTO  L_else_if_2
    
    L_else_if_1____if: ;if (y <= 1) box = 3
	MOVF  y, W
	SUBLW d'1' ;   |   1-y => C:1
	BTFSS STATUS, C
	GOTO L_else_if_1____else_if
	MOVLW d'3'
	MOVWF box
	GOTO L_next_operations
    
    L_else_if_1____else_if: ;else if (y <= 4) box = 2
	MOVF  y, W
	SUBLW d'4' ;   |   4-y => C:1
	BTFSS STATUS, C
	GOTO L_else_if_1____else_default
	MOVLW d'2'
	MOVWF box
	GOTO L_next_operations
	
    L_else_if_1____else_default: ;else box = 1
	MOVLW d'1'
	MOVWF box
	GOTO L_next_operations
	
	
L_else_if_2: ;else if (x <= 7)
    MOVF  x, W
    SUBLW d'7' ;   |   7-x => C:1
    BTFSS STATUS, C
    GOTO  L_else_default
    
    L_else_if_2____if: ;if (y <= 5) box = 5
	MOVF  y, W
	SUBLW d'5' ;   |   5-y => C:1
	BTFSS STATUS, C
	GOTO L_else_if_2____else_default
	MOVLW d'5'
	MOVWF box
	GOTO L_next_operations
	
    L_else_if_2____else_default: ;else box = 4
	MOVLW d'4'
	MOVWF box
	GOTO L_next_operations
	
	
L_else_default: ;else  
    L_else_default____if: ;if ( y<=2 ) box = 9
	MOVF  y, W
	SUBLW d'2' ;   |   2-y => C:1
	BTFSS STATUS, C
	GOTO L_else_default____else_if_1
	MOVLW d'9'
	MOVWF box
	GOTO L_next_operations
    
    L_else_default____else_if_1: ;else if ( y<=6 ) box = 8
	MOVF  y, W
	SUBLW d'6' ;   |   6-y => C:1
	BTFSS STATUS, C
	GOTO L_else_default____else_if_2
	MOVLW d'8'
	MOVWF box
	GOTO L_next_operations
	
    L_else_default____else_if_2: ;else if ( y<=8 ) box = 7
	MOVF  y, W
	SUBLW d'8' ;   |   8-y => C:1
	BTFSS STATUS, C
	GOTO L_else_default____else_default
	MOVLW d'7'
	MOVWF box
	GOTO L_next_operations
	
    L_else_default____else_default: ;else box = 6
	MOVLW d'6'
	MOVWF box
    
L_next_operations:
; ---------- Your code ends here ----------------------------
    
MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP GOTO $ ; Infinite loop
END ; End of the program