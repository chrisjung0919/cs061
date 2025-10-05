;=================================================
; Name: Christopher Jung
; Email:  cjung035@ucr.edu
; 
; Lab: lab 1, ex 1
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000

;----------
;Instructions
;----------

    AND R1, R1, x0    ;R1 <-- (R1) AND x0000
    LD R2, DEC_12    ;R2 <-- #12
    LD R3, DEC_6     ;R3 <-- #6
    
    DO_WHILE_LOOP
        ADD R1, R1, R2     ;R1 <-- R1 + R2
        ADD R3, R3, #-1     ;R3 <-- R3 - #1
        BRp DO_WHILE_LOOP
    END_DO_WHILE_LOOP
    
    HALT
    
    ;----------
    ;Local data
    ;----------
    
    DEC_0     .FILL     #0
    DEC_12     .FILL     #12
    DEC_6     .FILL     #6
    
.END