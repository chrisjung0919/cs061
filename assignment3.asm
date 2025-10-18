;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 022
; TA: Javad Saberlatibari
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

LD R2, CountFour ; Set R2 = 4
LD R3, SIXTEEN ; Set R3 = 16


DO_PRINT_LOOP
    ADD R2, R2, #0 ; check if all 4 bits are added
    BRp CONDITION
    
    LEA R0, SPACE
    PUTS ; print space every 4 bits
    
    LD R2, CountFour ; reset R2 to 4 for the next group
    ADD R3, R3, #0 ; check remaining bits
    

    CONDITION
        ADD R1, R1, #0 ; check the current bit in R1 is 1 or 0
        BRp POSITIVE ; positive means bit = 0
        BRn NEGATIVE ; negative means bit = 1
    END_CONDITION
    
    
    POSITIVE
        LEA R0, ZERO
        PUTS ; print 0
        
        BR DECREASE ; go to DECREASE loop
    END_POSITIVE
    
    
    NEGATIVE
        LEA R0, ONE
        PUTS ; print 1
        
        BR DECREASE ; go to DECREASE loop
    END_NEGATIVE
    
    
    DECREASE
        ADD R1, R1, R1 ; left shift R1 by 1 bit to check the next bit
        ADD R2, R2, #-1 ; decrease group count(4) by 1
        ADD R3, R3, #-1 ; decrease total bit(16) by 1

        BRp DO_PRINT_LOOP ; keep repeating the loop if there are bits remaining
    END_DECREASE


END_DO_PRINT_LOOP


LD R0, NEWLINE
OUT     ; print newline at the end


HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL xCA01	; The address where value to be displayed is stored


CountFour   .FILL #4 ; Groups of 4 bits
SIXTEEN     .FILL #16 ; Total bits in 16 bits
ZERO   .STRINGZ  "0" ; Zero for positive
ONE    .STRINGZ   "1" ; One for negative


NEWLINE   .FILL #10 ; Number 10 is the ASCII newline character
SPACE  .STRINGZ  " " ; Space between groups of 4 bits


.END

.ORIG xCA01					; Remote data
Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
