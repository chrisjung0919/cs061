;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: 022
; TA: Javad Saberlatibari
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------





;First number from keyboard
GETC ;Keyboard input store the first number in R0
OUT

AND R1, R1, x0 ;Clear R1 set it to zero
ADD R1, R0, #0 ;Add the first number into R1
LD R0, newline
OUT ;Print newline



;Second number from keyboard
GETC ;Keyboard input store the second number in R0
OUT

AND R2, R2, x0 ;Clear R2 set it to zero
ADD R2, R0, #0 ;Add the second number into R2
LD R0, newline
OUT ;Print newline





;Print subtraction expression
AND R0, R0, x0 ;Clear R0 set it to zero
ADD R0, R1, #0 ;Add the first number into R0

OUT ;Print the first number

LEA R0, minus ;String " - "
PUTS ;Print " - "

AND R0, R0, x0 ;Clear R0 set it to zero
ADD R0, R2, #0 ;Add the second number into R0

OUT ;Print the second number

LEA R0, equal ;String " = "
PUTS ;Print " = "





;Conversion from ASCII characters to digit numbers
;ASCII 0 is 48 which I have to subtract 12 four times
;First number conversion
ADD R1, R1, #-12
ADD R1, R1, #-12
ADD R1, R1, #-12
ADD R1, R1, #-12

;Second number conversion
ADD R2, R2, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12

AND R3, R3, x0 ;Clear R3
NOT R2, R2 ;Flips the bits to make it negative
ADD R2, R2, #1 ;Adding 1 makes it two's complement
ADD R3, R1, R2 ;This is R3 = R1 + (-R2) = R1 - R2



BRzp PRINT ;If R3 >= 0 skip the negative sign

LEA R0, negativesign
PUTS ;Print negative sign "-" if the answer is negative
NOT R3, R3 ;Flips the bits to make it positive
ADD R3, R3, #1 ;Adding 1 makes it two's complement



;Print the result
PRINT

ADD R0, R3, x0 ;Add the result in R3 to R0
ADD R0, R0, #12 ;Add 12 four times to convert digit to ASCII
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12

OUT ;Print the result

LD R0, newline
OUT ;Print newline


HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL x0A	; newline character - use with LD followed by OUT
minus .STRINGZ " - "
equal .STRINGZ " = "
negativesign .STRINGZ "-"

;---------------	
;END of PROGRAM
;---------------	
.END

