; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 022
; TA: Javad Saberlatibari
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
; PUT ALL YOUR CODE AFTER THE main LABEL
;=================================================================================

;---------------------------------------------------------------------------------
;  Initialize program by setting stack pointer and calling main subroutine
;---------------------------------------------------------------------------------
.ORIG x3000

; initialize the stack
ld r6, stack_addr

; call main subroutine
lea r5, main
jsrr r5

;---------------------------------------------------------------------------------
; Main Subroutine
;---------------------------------------------------------------------------------
main
; get a string from the user
LEA R1, user_prompt     ; load label addresses into registers
LEA R2, user_string

LD R5, get_user_string_addr
JSRR R5

; find size of input string
ADD R1, R2, #0

LD R5, strlen_addr
JSRR R5

; call palindrome method
ADD R2, R1, R0
ADD R2, R2, #-1

LD R5, palindrome_addr
JSRR R5

; determine if string is a palindrome
ADD R0, R0, #0

BRp YES_PALINDROME_MESSAGE
BRz NOT_PALINDROME_MESSAGE


; print the result to the screen
YES_PALINDROME_MESSAGE
AND R0, R0 #0

LEA R0, result_string
PUTS

LEA R0, final_string
PUTS

HALT


; decide whether or not to print "not"
NOT_PALINDROME_MESSAGE
AND R0, R0 #0

LEA R0, result_string
PUTS

LEA R0, not_string
PUTS

LEA R0, final_string
PUTS

HALT

;---------------------------------------------------------------------------------
; Required labels/addresses
;---------------------------------------------------------------------------------

; Stack address ** DO NOT CHANGE **
stack_addr           .FILL    xFE00

; Addresses of subroutines, other than main
get_user_string_addr .FILL    x3200
strlen_addr          .FILL    x3300
palindrome_addr      .FILL	  x3400


; Reserve memory for strings in the progrtam
user_prompt          .STRINGZ "Enter a string: "
result_string        .STRINGZ "The string is "
not_string           .STRINGZ "not "
final_string         .STRINGZ	"a palindrome\n"

; Reserve memory for user input string
user_string          .BLKW	  100

.END


;--------------------------------------------------------------------------------
; get_user_string_3200 - prompts the user to input a string and stores it
;
; parameter: R1 - address of user_prompt
; parameter: R2 - address of stored user input string
;
; returns: nothing
;--------------------------------------------------------------------------------

.ORIG x3200

get_user_string
; Backup all used registers, R7 first, using proper stack discipline

ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0

ADD R0, R1, #0

PUTS


INPUT

GETC
OUT

LD R3, LINE_FEED
NOT R3, R3 
ADD R3, R3, #1

ADD R3, R3, R0      ; If result is zero, char was newline -> exit loop
BRz EXIT

STR R0, R2, #0      ; Store typed character at R2
ADD R2, R2, #1      ; increment R2 to get ready for next character
BRnzp INPUT

END_INPUT

EXIT

; Restore all used registers, R7 last, using proper stack discipline
LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

LINE_FEED .FILL x0A ; Constant for newline character


; Resture all used registers, R7 last, using proper stack discipline
.END

;--------------------------------------------------------------------------------
; strlen_3300 - compute the length of a zero terminated string
;
; parameter: R1 - the address of a zero terminated string
;
; returns: The length of the string in R0
;--------------------------------------------------------------------------------

.ORIG x3300

strlen
; Backup all used registers, R7 first, using proper stack discipline

ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

AND R0, R0, #0


FIND_STRING_LENGTH
    LDR R2, R1, #0      ; If char == 0 (null terminator), exit loop
    BRz EXIT_2
    
    ADD R0, R0, #1      ; Increment length count (R0++)
    ADD R1, R1, #1      ; Move to next character (R1++)
    
    BRnzp FIND_STRING_LENGTH
    
END_FIND_STRING_LENGTH

EXIT_2

; Restore all used registers, R7 last, using proper stack discipline

LDR R1, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

.END


;---------------------------------------------------------------------------------
; palindrome_3400 - determines whether or not string is a palindrome
;
; parameter: R1 - address of first character in string
; parameter: R2 - address of last character in string
;
; returns: 1 if string is palindrome or 0 if string is not a palindrome in R0
;---------------------------------------------------------------------------------

.ORIG x3400

palindrome ; Hint, do not change this label and use for recursive alls

; Backup all used registers, R7 first, using proper stack discipline

ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

AND R0, R0, #0
ADD R0, R0, #1

AND R3, R3, #0
AND R4, R4, #0

ADD R3, R1, #0 ; R3 = R1 (copy start pointer)
ADD R4, R2, #0 ; R4 = R2 (copy end pointer)

ADD R1, R1, #1 ; Increment start pointer (move inward)
ADD R2, R2, #-1 ; Decrement end pointer (move inward)

NOT R3, R3
ADD R3, R3, #1 ; R3 = -R1 (two's complement)

ADD R5, R3, R4

BRz SAME_CHARACTER ; If R5 == 0, pointers equal -> SAME_CHARACTER

BRn IS_PALINDROME ; If R5 < 0, R4 < R1 → consider as palindrome base case

JSR palindrome ; Otherwise, recursively call palindrome (inner substring)

SAME_CHARACTER

AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0

LDR R3, R1, #0 ; Load character at new start pointer
LDR R4, R2, #0 ; Load character at new end pointer

NOT R3, R3
ADD R3, R3, #1 ; find two's complement

ADD R5, R3, R4 ; R5 = char_end - char_start

BRz IS_PALINDROME ; If chars equal (difference 0), go to IS_PALINDROME
BRnp NOT_PALINDROME ; If not equal, go to NOT_PALINDROME


IS_PALINDROME
    ADD R0, R0, #0
    BRz NOT_PALINDROME
    
    AND R0, R0, #0
    ADD R0, R0, #1      ; Set R0 = 1 (indicate palindrome)
    BR FINISH
END_IS_PALINDROME
    
NOT_PALINDROME
    AND R0, R0, #0      ; Set R0 = 0 (indicate not palindrome)
END_NOT_PALINDROME

FINISH

; Restore all used registers, R7 last, using proper stack discipline
LDR R1, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

.END
