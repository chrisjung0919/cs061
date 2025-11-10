;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 6, ex 2
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000
; Initialize the stack. Don't worry about what that means for now.
        LD      R6, top_stack_addr        ; DO NOT MODIFY, AND DON'T USE R6 OTHER THAN FOR BACKUP/RESTORE

; 1) Set R1 to the start of the buffer where we'll store the string
        LEA     R1, input_buffer

; 2) Call SUB_GET_STRING (via JSRR using a pointer, as taught)
        LD      R5, SUB_GET_STRING_PTR    ; R5 = address of subroutine
        JSRR    R5                        ; On return: R1 unchanged; R5 = char count

; 3) Call SUB_IS_PALINDROME (uses R1, R5; returns R4=1/0)
        LD      R0, SUB_IS_PALINDROME_PTR   ; keep R5 = length
        JSRR    R0

; --- save the flag BEFORE any PUTS (since PUTS can trash regs) ---
        ST      R4, PAL_FLAG

; 4) Report result in MAIN (NOT in subroutine)
;    Print: The string "<input>" IS / IS NOT a palindrome
        LEA     R0, MSG_PREFIX            ; "The string \""
        PUTS

        ADD     R0, R1, #0                ; print the captured string
        PUTS

        LD      R4, PAL_FLAG            ; restore flag safely        
        ADD     R4, R4, #0                ; test flag from subroutine
        BRz     NOT_PALI
        LEA     R0, MSG_IS                ; "\" IS a palindrome"
        PUTS
        BR      DONE_MSG

NOT_PALI
        LEA     R0, MSG_IS_NOT            ; "\" IS NOT a palindrome"
        PUTS

DONE_MSG
        HALT

;========================
; Local data for MAIN
;========================
SUB_GET_STRING_PTR       .FILL   SUB_GET_STRING_3200
SUB_IS_PALINDROME_PTR    .FILL   SUB_IS_PALINDROME_3400

input_buffer             .BLKW   #100

top_stack_addr           .FILL   xFE00

PAL_FLAG .BLKW #1

; Messages
MSG_PREFIX  .STRINGZ "The string \""
MSG_IS      .STRINGZ "\" IS a palindrome"
MSG_IS_NOT  .STRINGZ "\" IS NOT a palindrome"

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
;   - Uses GETC + OUT to echo (no IN).
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
        PUTS

; R2 = write pointer (starts at R1). R5 = count = 0
        ADD     R2, R1, #0
        AND     R5, R5, #0

READ_LOOP
        GETC                            ; R0 = char (no echo)
        ADD     R3, R0, #0             ; R3 = current char

; If char == '\n' (x0A), end input
        LD      R4, NEWLINE
        NOT     R4, R4
        ADD     R4, R4, #1             ; R4 = -NEWLINE
        ADD     R4, R3, R4
        BRz     END_INPUT

; If char == '\r' (x0D), also end input (handles some terminals)
        LD      R4, CARRIAGE_RETURN
        NOT     R4, R4
        ADD     R4, R4, #1             ; R4 = -CR
        ADD     R4, R3, R4
        BRz     END_INPUT

; Echo the character
        ADD     R0, R3, #0
        OUT

; Store the character into the array
        STR     R3, R2, #0
        ADD     R2, R2, #1             ; advance write pointer
        ADD     R5, R5, #1             ; count++

        BR      READ_LOOP

END_INPUT
; NULL-terminate the string at current R2
        AND     R0, R0, #0
        STR     R0, R2, #0

; newline after ENTER so printed string appears on next line
        LD      R0, CARRIAGE_RETURN
        OUT
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

;------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME_3400
; Parameter (R1): Start address of NULL-terminated string
; Parameter (R5): Length of the string (number of chars, not counting NULL)
; Postcondition: Sets R4 = 1 if palindrome, otherwise 0. No printing here.
; Notes:
;   - Leaves R1 and R5 unchanged.
;   - Two-pointer technique: left (R2) and right (R3).
;------------------------------------------------------------------------
        .ORIG x3400
SUB_IS_PALINDROME_3400
; backup: R7, R0, R2, R3
        ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

; assume palindrome
        AND     R4, R4, #0
        ADD     R4, R4, #1

; left = R1
        ADD     R2, R1, #0

; right = R1 + (R5 - 1), unless length == 0
        ADD     R3, R1, #0
        ADD     R0, R5, #0
        BRz     PALI_DONE              ; empty string -> palindrome
        ADD     R0, R0, #-1
        ADD     R3, R3, R0

PALI_LOOP
; stop when left >= right
        ADD     R0, R3, #0
        NOT     R0, R2
        ADD     R0, R0, #1             ; R0 = R3 - R2
        ADD     R0, R3, R0
        BRn     PALI_DONE              ; right < left
        BRz     PALI_DONE              ; right == left

COMPARE
        LDR     R0, R2, #0             ; left char
        LDR     R7, R3, #0             ; right char
        NOT     R7, R7
        ADD     R7, R7, #1             ; -right char
        ADD     R7, R0, R7             ; left - right
        BRz     NEXT_PAIR              ; equal -> continue

; mismatch -> not palindrome
        AND     R4, R4, #0             ; R4 = 0
        BR      PALI_DONE

NEXT_PAIR
        ADD     R2, R2, #1             ; left++
        ADD     R3, R3, #-1            ; right--
        BR      PALI_LOOP

PALI_DONE
; restore: R3, R2, R0, R7
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

        .END
