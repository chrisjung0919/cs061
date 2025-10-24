;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 4, ex 2
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

LD R1, ARRAY

LD R4, SUB_CONVERT_ARRAY_3400
LD R2, NINE
    ADD R2, R2, #1
LD R3, FORTYEIGHT
JSRR R4


HALT


SUB_FILL_ARRAY_3200   .FILL x3200
SUB_CONVERT_ARRAY_3400   .FILL x3400
NINE   .FILL #9
FORTYEIGHT   .FILL #48
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

SUB_FILL_ARRAY
    ADD R0, R0, #1
    ADD R1, R1, #1
    STR R0, R1, #0
    ADD R2, R2, #-1
    BRp SUB_FILL_ARRAY
END_SUB_FILL_ARRAY


RET


.END


;------------------------------------------------------------------------
; Subroutine: SUB_CONVERT_ARRAY
; Parameter (R1): The starting address of the array. This should be
; unchanged at the end of the subroutine!
; Postcondition: Each element (number) in the array should be represented as
; a character. E.g. 0 -> ‘0’
; Return Value (None)
;-------------------------------------------------------------------------


.ORIG x3400

SUB_CONVERT_ARRAY
    LDR R0, R1, #0
    ADD R0, R0, R3
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp SUB_CONVERT_ARRAY
END_SUB_CONVERT_ARRAY


RET


.END


.ORIG x4000

ARRAY_TEN   .BLKW #10

.END