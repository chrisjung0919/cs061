;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 022
; TA: Javad Saberlatibari
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R4
;=================================================================================

.ORIG x3000		
;-------------
;Instructions
;-------------


START
; output intro prompt
LD R0, introPromptPtr

PUTS
						
; Set up flags, counters, accumulators as needed
AND R6, R6, #0 ; 0 = pos, 1 = neg
AND R5, R5, #0 ; counter
AND R4, R4, #0
ADD R5, R5, #5

; Get first character, test for '\n', '+', '-', digit/non-digit
GETC
OUT
		
; is very first character = '\n'? if so, just quit (no message)!
LD R1, NEWLINE

NOT R1, R1
ADD R1, R1, #1
ADD R2, R1, R0

BRz FINISH

; is it = '+'? if so, ignore it, go get digits
LD R1, PLUS

NOT R1, R1
ADD R1, R1, #1
ADD R2, R1, R0

BRz GET_DIGITS

; is it = '-'? if so, set neg flag, go get digits
LD R1, MINUS

NOT R1, R1
ADD R1, R1, #1
ADD R2, R1, R0

BRnp CHECK_NEG

ADD R6, R6, #1

BRnzp GET_DIGITS

CHECK_NEG

; is it < '0'? if so, it is not a digit	- o/p error message, start over
LD R1, ZERO

NOT R1, R1
ADD R1, R1, #1
ADD R2, R1, R0

BRn ERROR

; is it > '9'? if so, it is not a digit	- o/p error message, start over
LD R1, NINE

NOT R1, R1
ADD R1, R1, #1
ADD R2, R1, R0

BRp ERROR
	
; if none of the above, first character is first numeric digit - convert it to number & store in target register!

; change R0 to ascii
LD R2, ZERO

NOT R2, R2
ADD R2, R2, #1
ADD R0, R0, R2

; multiply R4 by 10

AND R3, R3, #0 ; set R3 to zero
ADD R3, R3, #9 ; Add 9 to R3
ADD R2, R4, #0

MULTIPLY_LOOP

ADD R4, R4, R2
ADD R3, R3, #-1

BRp MULTIPLY_LOOP

; add new R0 to R4

ADD R4, R4, R0

; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator

ADD R5, R5, #-1

BRz FINISH ; stop if 5 digits have been entered

GET_DIGITS

GETC
OUT

LD R2, NEWLINE

NOT R2, R2
ADD R2, R2, #1
ADD R1, R0, R2

BRz FINISH ; if newline end input

BRnp CHECK_NEG


ERROR
LD R0, errorMessagePtr
PUTS ; show the error message
BRnzp START ; restart from beginning

FINISH

ADD R6, R6, #0
BRz PRINT

NOT R4, R4
ADD R4, R4, #1 ; two's complement

PRINT

; remember to end with a newline!

LD R0, NEWLINE
OUT


HALT


;---------------	
; Program Data
;---------------

NEWLINE   .FILL   #10   ; '\n' newline


introPromptPtr  .FILL xB000
errorMessagePtr .FILL xB200

PLUS .FILL x2B   ; '+' sign
MINUS .FILL x2D   ; '-' sign
ZERO .FILL x30   ; '0' zero
NINE .FILL x39   ; '9' nine

.END

;------------
; Remote data
;------------
.ORIG xB000	 ; intro prompt
.STRINGZ	 "Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"

.END					
					
.ORIG xB200	 ; error message
.STRINGZ	 "ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
