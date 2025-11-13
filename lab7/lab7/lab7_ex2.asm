;=================================================
; Name: Christopher Jung
; Email: cjung035@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 022
; TA: Javad Saberlatibari
; 
;=================================================

.ORIG x3000

        LD      R6, top_stack_addr          ; stack init

;-----------------------------------------------
; MAIN
;-----------------------------------------------
        LEA     R1, input_buffer
        LD      R5, SUB_GET_STRING_PTR
        JSRR    R5                          ; get string -> R5=len

        LD      R0, SUB_IS_PALINDROME_PTR
        JSRR    R0                          ; R4=1/0

        ST      R4, PAL_FLAG

        LEA     R0, MSG_PREFIX ; The string "string"
        PUTS

        ADD     R0, R1, #0 ; output the input string user typed
        PUTS

        LD      R4, PAL_FLAG
        ADD     R4, R4, #0
        BRz     NOT_PALI
        LEA     R0, MSG_IS
        PUTS
        BR      BR_DONE

NOT_PALI
        LEA     R0, MSG_IS_NOT
        PUTS

BR_DONE
        HALT

;-----------------------------------------------
; DATA
;-----------------------------------------------
SUB_GET_STRING_PTR       .FILL   x3200
SUB_IS_PALINDROME_PTR    .FILL   x3400
SUB_TO_UPPER_PTR         .FILL   x3600

input_buffer             .BLKW   #100
top_stack_addr           .FILL   xFE00
PAL_FLAG                 .BLKW   #1

MSG_PREFIX  .STRINGZ "The string \""
MSG_IS      .STRINGZ "\" IS a palindrome"
MSG_IS_NOT  .STRINGZ "\" IS NOT a palindrome"

.END


;=================================================
; SUB_GET_STRING_3200
;=================================================

.ORIG x3200

SUB_GET_STRING_3200
        ADD     R6, R6, #-1     ; backup regs
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0

        LEA     R0, PROMPT
        PUTS

        ADD     R2, R1, #0
        AND     R5, R5, #0

READ_LOOP
        GETC
        ADD     R3, R0, #0              ; R3 = typed char

        ; --- end on NEWLINE or CARRIAGE_RETURN ---
        LD      R4, NEWLINE
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R3, R4
        BRz     END_INPUT

        LD      R4, CARRIAGE_RETURN
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R3, R4
        BRz     END_INPUT

        ; --- BACKSPACE ---
        LD      R4, BACKSPACE           ; x0008
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R3, R4
        BRz     HANDLE_BS

        ; --- normal char ---
        ADD     R0, R3, #0
        OUT
        STR     R3, R2, #0
        ADD     R2, R2, #1
        ADD     R5, R5, #1
        BR      READ_LOOP

HANDLE_BS
        ; if no chars typed, ignore BS (solution for exercise 3)
        ADD     R4, R1, #0
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R2, R4              ; R4 = R2 - R1
        BRz     READ_LOOP

        ; erase last char in buffer
        ADD     R2, R2, #-1 ; Move pointer back one spot
        AND     R0, R0, #0 ; Clear R0 (set to 0)
        STR     R0, R2, #0 ; Overwrite that memory spot with 0
        ADD     R5, R5, #-1 ; Decrease string length counter

        ; visually erase on screen: BS
        LD      R0, BACKSPACE
        OUT
        
        BR      READ_LOOP

END_INPUT
        AND     R0, R0, #0
        STR     R0, R2, #0
        LD      R0, NEWLINE
        OUT
        
        RET

PROMPT           .STRINGZ "Enter a string, then press ENTER: "
NEWLINE          .FILL    x000A
CARRIAGE_RETURN  .FILL    x000D

BACKSPACE        .FILL   x0008
SPACE            .FILL   x0020

.END


;=================================================
; SUB_IS_PALINDROME_3400
;=================================================

.ORIG x3400

SUB_IS_PALINDROME_3400
        ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

        ; --- call SUB_TO_UPPER first ---
        LD      R0, SUB_TO_UPPER_PTR_NEAR
        JSRR    R0

        AND     R4, R4, #0
        ADD     R4, R4, #1 ; Set palindrome is true at first

        ADD     R2, R1, #0 ; left pointer start of the string
        ADD     R3, R1, #0 ; start of the string
        ADD     R0, R5, #0 ; R0 is the string length
        BRz     PALI_DONE ; if length is zero its done
        ADD     R0, R0, #-1 ; subtract length by 1
        ADD     R3, R3, R0 ; right pointer end of the string

PALI_LOOP
        ADD     R0, R3, #0
        NOT     R0, R2
        ADD     R0, R0, #1 ; two's complement R0 = -R2
        ADD     R0, R3, R0 ; R3 + (-R2) to find distance
        BRn     PALI_DONE ; negative end right pass left
        BRz     PALI_DONE ; zero end both meet in middle

COMPARE
        LDR     R0, R2, #0 ; left char
        LDR     R7, R3, #0 ; right char
        NOT     R7, R7
        ADD     R7, R7, #1
        ADD     R7, R0, R7 ; R7 = left - right
        BRz     NEXT_PAIR
        AND     R4, R4, #0 ; set palindrome as false
        BR      PALI_DONE ; end

NEXT_PAIR
        ADD     R2, R2, #1 ; move left forward
        ADD     R3, R3, #-1 ; move right backward
        BR      PALI_LOOP

PALI_DONE
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        
        RET
        
SUB_TO_UPPER_PTR_NEAR   .FILL   x3600
        
.END


;=================================================
; SUB_TO_UPPER_3600
;=================================================

.ORIG x3600

SUB_TO_UPPER_3600
        ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

        ADD     R2, R1, #0

UP_LOOP
        LDR     R0, R2, #0
        BRz     UP_DONE

        ; if R0 < 'a'  -> skip
        LD      R3, ASCII_a
        NOT     R3, R3
        ADD     R3, R3, #1
        ADD     R3, R0, R3               ; R3 = R0 - 'a'
        BRn     NO_CHANGE

        ; if R0 > 'z'  -> skip
        LD      R3, ASCII_z
        ADD     R3, R3, #-1              ; use z - 1 then compare (or invert like below)
        NOT     R3, R3
        ADD     R3, R3, #1               ; R3 = -('z' - 1)
        ADD     R3, R3, R0               ; R3 = R0 - ('z' + 0)
        BRp     NO_CHANGE

        ; in ['a','z'] -> clear bit 5
        LD      R3, MASK_CLEAR_BIT5
        AND     R0, R0, R3
        STR     R0, R2, #0

NO_CHANGE
        ADD     R2, R2, #1
        BR      UP_LOOP

UP_DONE
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        
        RET

ASCII_a            .FILL   x0061 ; decimal 97
ASCII_z            .FILL   x007A ; decimal 122
; UPPER CASE decimal < LOWER CASE decimal

MASK_CLEAR_BIT5    .FILL   xFFDF ; difference between a/A

.END
