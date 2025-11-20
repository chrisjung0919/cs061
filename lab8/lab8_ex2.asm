
.ORIG x3000

LD R6, TOP_STACK_ADDR

; Test harness
;-------------------------------------------------
LEA R0, PROMPT
PUTS

GETC ; GET CHARACTER
OUT  ; PRINT THE CHARACTER

ST R0, STORAGE ; STORES THE CHARACTER INTO A RESERVED SPACE

LD R1, PARITY_CHECK_3600 ; CALL TO SUBROUTINE
JSRR R1

LD R0, NEWLINE 
OUT

LEA R0, RESULT_PROMPT ; NEW SENTENCE OUTPUT
PUTS

LD R0, STORAGE ; PRINTS OUT CHARACTER THE USER INPUTTED
OUT

LEA R0, RESULT_PROMPT2 ; CONTINUES SENTENCE
PUTS

LD R2, ASCII ; #48 TO CONVERT INTO PRINTABLE DECIMAL #

ADD R0, R2, R3 ; ADDS ASCII #48 WITH NUMBER OF 1S COUNTED AND PUT INTO R0 TO PRINT
OUT

HALT

; Test harness local data
;-------------------------------------------------
TOP_STACK_ADDR .FILL xFE00
PROMPT .STRINGZ "Enter a single character: "
NEWLINE .FILL x0A
RESULT_PROMPT .STRINGZ "The number of 1's in '"
RESULT_PROMPT2 .STRINGZ "' is: "
PARITY_CHECK_3600 .FILL x3600
STORAGE .BLKW #1
ASCII .FILL #48

.END

;=================================================
; Subroutine: PARITY_CHECK_3600
; Parameter: R0 from GETC.
; Postcondition: The parity check will look at the value and return the amount of 1s it counts.
; Return Value (R3): Value is stored in R3 and returns the number of 1s.
;=================================================

.ORIG x3600

; Backup registers
ADD R6, R6, #-1 ; BACKUP REGISTERS
STR R7, R6, #0 
ADD R6, R6, #-1
STR R4, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0

; Code
AND R3, R3, #0 ; COUNTER <INITIALIZE TO ZERO>
LD R2, DEC_16 ; LIMIT OF LOOPS <16>

KEEP_COUNTING
    ADD R4, R0, #0 ; VALUE PASSED IN R0 WILL GO INTO R4 FOR CHECKING
    BRzp CONTINUE ; IF VALUE TO REPRESENT THAT "DIGIT WAS ZERO OR POSITIVE, THE PROGRAM CONTINUES TO NEXT NUMBER WHILE DECREMENTING A LOOP#
    ADD R3, R3, #1 ; OTHERWISE COUNT/ADD 1 TO R3 <VALUE IS REPRESENTED AS A NEGATIVE NUM>
    
    CONTINUE
        ADD R0, R0, R0 ; ADD TO ITSELF TO INCREMENT THRU DIGITS shift left by 1 bit
        ADD R2, R2, #-1 ; DECREMENT 1 FROM LOOP
        BRp KEEP_COUNTING
END_KEEP_COUNTING    

; Restore registers
LDR R2, R6, #0
ADD R6, R6, #1
LDR R4, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1 ; LD BACK REGISTERS OG STATE

RET

DEC_16 .FILL #16

.END