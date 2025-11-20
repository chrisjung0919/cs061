
.ORIG x3000

LD R6, TOP_STACK_ADDR

; Test harness
;-------------------------------------------------

LD R2, LOAD_FILL_VALUE_3200 ; CALL LOAD VALUE SUBROUTINE
JSRR R2

ADD R4, R4, #1 ; ADD THAT VALUE BY ONE

LD R2, OUTPUT_AS_DECIMAL_3400 ; CALL THE PRINT SUBROUTINE WITH THAT +1
JSRR R2

HALT

; Test harness local data
;-------------------------------------------------
TOP_STACK_ADDR .FILL xFE00
LOAD_FILL_VALUE_3200 .FILL x3200
OUTPUT_AS_DECIMAL_3400 .FILL x3400

.END

;=================================================
; Subroutine: LOAD_FILL_VALUE_3200
; Parameter: None
; Postcondition: Subroutine will take a hard-coded value and load it into a register (R4).
; Return Value: R4 (number inputted will be stored here)
;=================================================

.ORIG x3200

; Backup registers
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

; Code
LD R4, HARD_CODE_VALUE ; VALUE IS HARDCODED (.FILL)

; Restore registers
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

HARD_CODE_VALUE .FILL #-3

.END

;=================================================
; Subroutine: OUTPUT_AS_DECIMAL_3400
; Parameter: R4 (taking the input from subroutine 1)
; Postcondition: Take the hard-coded value and print it out as a decimal value.
; Return Value: None
;=================================================

.ORIG x3400

; Backup registers
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
ADD R6, R6, #-1
STR R4, R6, #0

; Code
LD R3, ASCII ; #48

ADD R4, R4, #0 
BRzp PROCEED ; IF NUMBER IS A POS/ZERO NUM, SKIPS THE NEXT STEPS
LEA R0, NEGATIVE_SIGN ; OTHERWISE PRINT A NEGATIVE SIGN
PUTS
    NOT R4, R4      ; TAKE COMPLEMENT OF THE NEGATIVE TO TURN POSITIVE
    ADD R4, R4, #1

PROCEED
AND R2, R2, #0 ; MAKE R2 ZERO

FIRST_LOOP
    LD R1, DEC_10000
        NOT R1, R1
        ADD R1, R1, #1  ; TAKE THE COMPLEMENT TO TURN 10000 NEGATIVE
    ADD R2, R2, #1      ; COUNTER FOR HOW MANY TIMES THIS LOOPS
    ADD R4, R4, R1      ; ADD THE VALUE WITH -10000 subtract 10000
    BRzp FIRST_LOOP     ; IF IT'S STILL POSITIVE, RELOOP

ADD R2, R2, #-1         ; HAVE TO SUBTRACT 1 FROM COUNTER SINCE IT LOOPS AND TURN VALUE NEG
LD R1, DEC_10000
    ADD R4, R4, R1      ; BECAUSE VALUE TURNED NEGATIVE, ADD 10000 TO MAKE IT ZERO
ADD R0, R2, R3          ; ADD THE DECIMAL VAL WITH 48 SO THE COUNTER IS PRINTABLE
OUT                     ; PRINT THE COUNTER

AND R2, R2, #0          ; MAKE R2 ZERO AGAIN

SECOND_LOOP
    LD R1, DEC_1000
        NOT R1, R1
        ADD R1, R1, #1  ; TAKE COMPLEMENT OF 1000 SO IT BECOMES -1000
    ADD R2, R2, #1      ; COUNTER
    ADD R4, R4, R1      ; ADD THE VALUE WITH -1000
    BRzp SECOND_LOOP    ; IF POSITIVE, RELOOP

ADD R2, R2, #-1 
LD R1, DEC_1000
    ADD R4, R4, R1 ; TURN THAT NEGATIVE VAL INTO A POSITIVE VAL AGAIN
ADD R0, R2, R3 
OUT ; PRINT R2

AND R2, R2, #0 ; reset R2

THIRD_LOOP
    LD R1, DEC_100
        NOT R1, R1
        ADD R1, R1, #1 ; TAKE COMPLEMENT SO 100 BECOMES -100
    ADD R2, R2, #1 ; COUNTER
    ADD R4, R4, R1
    BRzp THIRD_LOOP

ADD R2, R2, #-1
LD R1, DEC_100
    ADD R4, R4, R1 ; TURN THAT NEGATIVE VAL INTO A POSITIVE VAL AGAIN
ADD R0, R2, R3 
OUT ; PRINT R2

AND R2, R2, #0 ; reset R2

FOURTH_LOOP
    LD R1, DEC_10
        NOT R1, R1
        ADD R1, R1, #1 ; TAKE COMPLEMENT SO 10 BECOMES -10
    ADD R2, R2, #1 ; COUNTER
    ADD R4, R4, R1
    BRzp FOURTH_LOOP

ADD R2, R2, #-1
LD R1, DEC_10
    ADD R4, R4, R1 ; TURN THAT NEGATIVE VAL INTO A POSITIVE VAL AGAIN
ADD R0, R2, R3 
OUT ; PRINT R2

AND R2, R2, #0 ; reset R2

FIFTH_LOOP
    LD R1, DEC_1
        NOT R1, R1
        ADD R1, R1, #1 ; TAKE COMPLEMENT SO 1 BECOMES -1
    ADD R2, R2, #1 ; COUNTER
    ADD R4, R4, R1
    BRzp FIFTH_LOOP

ADD R2, R2, #-1
LD R1, DEC_1
    ADD R4, R4, R1 ; TURN THAT NEGATIVE VAL INTO A POSITIVE VAL AGAIN
ADD R0, R2, R3 
OUT ; PRINT R2
    
; Restore registers
LDR R4, R6, #0
ADD R6, R6, #1
LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

ASCII .FILL #48
DEC_10000 .FILL #10000
DEC_1000 .FILL #1000
DEC_100 .FILL #100
DEC_10 .FILL #10
DEC_1 .FILL #1
NEGATIVE_SIGN .STRINGZ "-"

.END