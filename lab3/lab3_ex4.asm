;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================


.ORIG x3000

LEA R0, LABEL
PUTS

LD R1, ARRAY

LD R2, NEWLINE
	NOT R2, R2
	ADD R2, R2, #1

DO_WHILE_LOOP
	GETC
	STR R0, R1, #0
	ADD R1, R1, #1
    OUT
	ADD R3, R0, R2 ; adds every input with -10, it will detect 'enter' when 10 - 10 = 0 and ends loop
	BRnp DO_WHILE_LOOP
END_DO_WHILE_LOOP

LD R1, ARRAY

DO_WHILE_LOOP_2
	LDR R0, R1, #0
	OUT
	ADD R1, R1, #1

	ADD R4, R0, #0

	ADD R3, R4, R2
	
	BRnp DO_WHILE_LOOP_2
END_DO_WHILE_LOOP_2

HALT

LABEL .STRINGZ "Enter a string no more than 100 characters: "
ARRAY .FILL x4000
NEWLINE .FILL #10

.END

.ORIG x4000

ARRAY_R .BLKW #100

.END