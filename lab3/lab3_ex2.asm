;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 3, ex 2
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

HALT

LABEL .STRINGZ "Enter 10 characters: "
ARRAY .BLKW #10
DEC_10 .FILL #10

.END