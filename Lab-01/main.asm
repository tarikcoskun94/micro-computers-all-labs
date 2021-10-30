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
x   EQU 0x21
y   EQU 0x22
z   EQU 0x23
r1  EQU 0x24
r2  EQU 0x25
r3  EQU 0x26
r4  EQU 0x27
r   EQU 0x28
;*********************************************
;*********************************************
;*********************************************
MOVLW d'5'
MOVWF x
   
MOVLW d'6'
MOVWF y
   
MOVLW d'7'
MOVWF z
;*********************************************     
MOVF x, W
   
ADDWF x, W
ADDWF x, W
   
MOVWF r1    ; r1 = (3*x)
;*********************************************
MOVF y, W
   
ADDWF y, W
ADDWF y, W
ADDWF y, W
ADDWF y, W
ADDWF r1, W
   
MOVWF r1    ; r1 = (3*x + 5*y)
;*********************************************
MOVF z, W
   
ADDLW d'13'
SUBWF r1, W
   
MOVWF r1    ; r1 = (3*x + 5*y) - (z+13)  
;*********************************************
;*********************************************
;*********************************************
MOVF x, W
 
ADDLW d'2'
 
MOVWF r2    ; r2 = (x+2)
;*********************************************
ADDWF r2, W
ADDWF r2, W
ADDWF r2, W
ADDWF r2, W
ADDWF r2, W
ADDWF r2, W
ADDWF r2, W
 
MOVWF r2    ; r2 = (x+2)*8
;*********************************************
MOVF z, W
 
ADDWF z,W
ADDWF z,W
ADDWF z,W
ADDWF z,W
ADDWF y,W
SUBWF r2, W

MOVWF r2    ; r2 = (x+2)*8 - (y+5*z)
;*********************************************
;*********************************************
;*********************************************
MOVF x, W
   
ADDWF x, W
ADDWF x, W
ADDWF x, W
ADDWF x, W
   
MOVWF r3    ; r3 = 5*x
;*********************************************
MOVF y, W
   
ADDWF y, W
ADDWF y, W
ADDWF r3, W
   
MOVWF r3    ; r3 = 5*x + 3*y
;*********************************************
MOVF z, W
 
SUBWF r3, W
 
MOVWF r3    ; r3 = 5*x + 3*y -z
;*********************************************
;*********************************************
;*********************************************
MOVF x, W
   
ADDWF x, W
   
MOVWF r4    ; r4 = (2*x)
;*********************************************
MOVF y, W
   
ADDWF y, W
ADDWF y, W
ADDWF r4, W
   
MOVWF r4    ; r4 = (2*x + 3*y)
;*********************************************
ADDWF r4, W
   
MOVWF r4    ; r4 = (2*x + 3*y)*2
;*********************************************
MOVF z, W

ADDLW d'12'
SUBWF r4, W
   
MOVWF r4    ; r4 = (2*x + 3*y)*2 - (z+12)
;*********************************************
;*********************************************
;*********************************************
MOVF r1, W
   
ADDWF r1, W
ADDWF r1, W
ADDWF r1, W
   
MOVWF r    ; r = 4*r1
;*********************************************
MOVF r2, W
   
ADDWF r2, W
ADDWF r, W

MOVWF r    ; r = 4*r1 + 2*r2
;*********************************************
MOVF r3, W

SUBWF r, W
   
MOVWF r    ; r = 4*r1 + 2*r2 - r3
;*********************************************
BCF STATUS, C
   
RRF r4, W
SUBWF r, W
   
MOVWF r    ; r = 4*r1 + 2*r2 - r3 - r4/2
; ---------- Your code ends here ----------------------------
    
MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP GOTO $ ; Infinite loop
END ; End of the program


