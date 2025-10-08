;=================================================
; Name: Christopher Jung
; Email:  cjung035@ucr.edu
; 
; Lab: lab 2, ex 4
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000

LD R0, HEX_41
LD R1, NUM_ALPHABETS

DO_WHILE_LOOP
    OUT
    ADD R0, R0, #1
    ADD R1, R1, #-1
    BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP

HALT

HEX_41 .FILL x41
NUM_ALPHABETS .FILL #26

.END