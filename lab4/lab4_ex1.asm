;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 4, ex 1
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000

AND R0, R0, #0

LD R1, ARRAY

LD R3, SUB_FILL_ARRAY_3200
LD R2, NINE


JSRR R3



HALT


SUB_FILL_ARRAY_3200   .FILL x3200
NINE   .FILL #9
ARRAY   .FILL x4000


.END


;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be
; unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------


.ORIG x3200

SUB_FILL_ARRAY_LOOP
    ADD R0, R0, #1
    ADD R1, R1, #1
    STR R0, R1, #0
    ADD R2, R2, #-1
    BRp SUB_FILL_ARRAY_LOOP
END_SUB_FILL_ARRAY_LOOP


RET


.END


.ORIG x4000

ARRAY_TEN   .BLKW #10

.END