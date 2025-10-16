;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000

LEA R0, LABEL
PUTS

LEA R1, ARRAY
LD R2, DEC_10

DO_WHILE_LOOP
    GETC
    STR R0, R1, #0
    ADD R1, R1, #1
    OUT
    ADD R2, R2, #-1
    BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP


LD R0, NEWLINE
OUT

LEA R1, ARRAY
LD R2, DEC_10

DO_WHILE_OUTPUT_LOOP
    LDR R0, R1, #0
    OUT
    LD R0, NEWLINE
    OUT
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp DO_WHILE_OUTPUT_LOOP
END_DO_WHILE_OUTPUT_LOOP

HALT

LABEL .STRINGZ "Enter 10 characters: "
ARRAY .BLKW #10
DEC_10 .FILL #10
NEWLINE .STRINGZ "\n"

.END