;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

;========================
; Main Test Harness @ x3000
;========================
        .ORIG x3000
; Initialize the stack. Don't worry about what that means for now.
        LD      R6, top_stack_addr        ; DO NOT MODIFY, AND DON'T USE R6 OTHER THAN FOR BACKUP/RESTORE

; 1) Set R1 to the start of the buffer where we'll store the string
        LEA     R1, input_buffer

; 2) Call SUB_GET_STRING (via JSRR using a pointer, as taught)
        LD      R5, SUB_GET_STRING_PTR    ; R5 = address of subroutine
        JSRR    R5                        ; On return: R1 unchanged; R5 = char count

; 3) Print the captured string using PUTS (needs R0 = address of string)
        ADD     R0, R1, #0
        PUTS                  ; PUTS

        HALT

;========================
; Local data for MAIN
;========================
SUB_GET_STRING_PTR   .FILL   SUB_GET_STRING_3200   ; pointer to subroutine
input_buffer         .BLKW   #100                   ; reserve space for up to ~100 chars (+ NULL)

top_stack_addr       .FILL   xFE00                  ; DO NOT MODIFY THIS LINE OF CODE

.END

;========================
; Subroutines below
;========================

;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3200
; Parameter (R1): Starting address of the character array (unchanged on return)
; Postcondition: Prompts user, captures chars until ENTER, stores chars
;               starting at (R1), echoes each char as typed, writes a NULL
;               terminator (x0000) after the last char. Does NOT store ENTER.
; Return Value (R5): Number of non-sentinel (non-ENTER) chars read
; Notes:
;   - Uses GETC (x20) + OUT (x21) to echo (no BIOS "IN" prompt).
;   - Backs up R7 and any clobbered regs (R0,R2,R3,R4); leaves R1 and R5 per spec.
;------------------------------------------------------------------------
        .ORIG x3200
SUB_GET_STRING_3200
;==== (1) Backup R7 and clobbered regs (except return vals / params) ====
        ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0

;==== (2) Do the work ====
; Prompt the user
        LEA     R0, PROMPT
        PUTS                       ; PUTS

; R2 = write pointer (starts at R1). R5 = count = 0
        ADD     R2, R1, #0
        AND     R5, R5, #0

READ_LOOP
        GETC                   ; GETC -> R0 (no echo)
        ADD     R3, R0, #0                 ; R3 = current char

; If char == '\n' (x0A), end input
        LD      R4, NEWLINE
        NOT     R4, R4
        ADD     R4, R4, #1                 ; R4 = -NEWLINE
        ADD     R4, R3, R4
        BRz     END_INPUT

; If char == '\r' (x0D), also end input (handles some terminals)
        LD      R4, CARRIAGE_RETURN
        NOT     R4, R4
        ADD     R4, R4, #1                 ; R4 = -CR
        ADD     R4, R3, R4
        BRz     END_INPUT

; Echo the character
        ADD     R0, R3, #0
        OUT                        ; OUT

; Store the character into the array
        STR     R3, R2, #0
        ADD     R2, R2, #1                 ; advance write pointer
        ADD     R5, R5, #1                 ; count++

        BR      READ_LOOP

END_INPUT
; NULL-terminate the string at current R2
        AND     R0, R0, #0
        STR     R0, R2, #0
        
        LD      R0, NEWLINE
        OUT

;==== (3) Restore regs in reverse order ====
        LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1

;==== (4) Return ====
        RET

;==== Local data for SUB ====
PROMPT           .STRINGZ "Enter a string, then press ENTER: "
NEWLINE          .FILL    x000A
CARRIAGE_RETURN  .FILL    x000D

        .END
