;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 022
; TA: Javad Saberlatibari
; Date created: 9/30/2025
; 
;=================================================
;
;Hello world program
;

.ORIG x3000

;----------
;Instructions
;----------

    LEA R0, MSG_TO_PRINT
    PUTS
    
    HALT
    
;----------
;Local data
;----------

    MSG_TO_PRINT     .STRINGZ     "Hello world!!!\n"
    
    
    
    
    
.END