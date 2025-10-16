;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000


LD R5, DATA_PTR

LDR R3, R5, #0
LDR R4, R5, #1

ADD R3, R3, #1
ADD R4, R4, #1

STR R3, R5, #0
STR R4, R5, #0

HALT


DATA_PTR .FILL x4000

.END

;; Remote data
.ORIG x4000

NEW_DEC_65 .FILL #65
NEW_HEX_41 .FILL x41

.END