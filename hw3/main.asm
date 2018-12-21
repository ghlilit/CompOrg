.model small

.stack 100H

.data
input DB 10101110B
s1 DB ?
s2 DB ?
s3 DB ?
s4 DB ?
s5 DB ?
s6 DB ?
s7 DB ?
s8 DB ?
answer DB ?
message DB  "The answer is: $"


.code

START:  MOV AX, @data
        MOV DS, AX
        
        MOV AL, input       ;move input into AL register
        AND AL, 00000011B
        SHR AL, 5           ;move the leftmost 3 bits to bit 0, 1 & 2
        CALL XAND           ;AND bit 0 and bit 1 with XAND subroutine
        MOV s1, AH          ;save result in db s1
        
        MOV AL, input       ;move input into AL register
        SHR AL, 7           ;shift leftmost bit to bit 0
        CALL XNOT           ;revert the value of bit 0 with XNOT subroutine
        MOV s2, AH          ;save result in db s2
        
        MOV AL, s2          ;move s2 into AL register
        SHL AL, 1           ;shift s2 left by one, moving result stored in bit 0 to bit 1
        ADD AL, s1          ;add s1 to AL, making bit 0 of AL be the result stored in s1
        CALL XNAND          ;NAND the bit 0 & 1 of AL with XNAND subroutine (s1 NAND s2)
        MOV s3, AH          ;save result in db s2
        
        MOV AL, input       ;take 4th bit
        SHR AL, 4           ;move to most right
        CALL XNOT           ;call XNOT
        MOV s4, AH          ;store in s4
        
        MOV AL, s3          ;take s3
        SHL AL, 1           ;shift left
        ADD AL, s4          ;add to s4 to have them in bit0 and 1
        CALL XXOR           ;perform XOR operation
        MOV s5, AH          ;save in s5
        
        MOV AL, input       ;taking the input for the 5th bit
        SHR AL, 2           ;now it is at the second last position
        AND AL, 00000010B   ;keeping only the second last bit
        ADD AL, s5          ;now we have s5 and bit 5 at last and second last positions
        CALL XNAND          ;perform NAND operation
        MOV s6, AH          ;save in s6
        
        MOV AL,input        ;taking the input for the last 2 bits
        AND AL, 00000011B   ;keeping only the last 2
        CALL XNOR           ;perform NOR operation
        MOV s7, AH          ;save in s7
        
        MOV AL, input       ;taking the input for the 6th bit
        SHR AL, 1           ;shift right once to get 6th bit at second last position
        AND AL, 00000010B   ;keeping only the second last bit
        ADD AL, s7          ;now we have s7 and bit 6 at last and second last positions
        CALL XAND           ;perform AND operation
        MOV s8, AH          ;save in s8
        
        MOV AL, s6          ;take s6
        SHL AL, 1           ;shift left
        ADD AL, s8          ;add to s8 to have them in bit0 and 1
        CALL XoOR           ;perform OR operation
        MOV answer, AH      ;save the answer
        
        mov ah, 09H         ;print message
        mov dx, offset message
        int 21h
        
        MOV DL, answer
        ADD DL, 30H         ; have a 30H or 31H in register DL
        MOV AH, 2           ; setup to print the ASCII value in DL
        INT 21H             ; with the DOS function 2
        
        MOV AH, 4CH         ; setup to terminate program and
        INT 21H             ; return to the DOS prompt with function 4CH

        
        
;   *************************************************
;   * 1 input NOT gate simulator subroutine         *
;   *                                               *
;   * input: AL bit 0                               *
;   * output AH, bit 0                              *
;   *************************************************       
    XNOT:
        
        MOV BL, AL          ; copy of input bits into BL
        AND BL, 00000001B   ; mask off all bits except input bit 0
        NOT BL              ; invert bits for the NOT
        AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one
        
        MOV AH, BL          ; copy answer into return value register
        RET                 ; uncomment for subroutine


;   *************************************************
;   * 2 input AND gate simulator subroutine         *
;   *                                               *
;   * input: AL bits 0,1                            *
;   * output AH, bit 0                              *
;   *************************************************
    XAND:
        
        MOV BL, AL          ; copy of input bits into BL
        MOV CL, AL          ; and another copy in CL
        AND BL, 00000001B   ; mask off all bits except input bit 0
        AND CL, 00000010B   ; mask off all bits except input bit 1
        SHR CL, 1           ; move bit 1 value into bit 0 of CL register
        AND BL, CL          ; AND these two registers, result in BL
        AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one
        
        MOV AH, BL          ; copy answer into return value register
        RET                 ; uncomment for subroutine
        
        
;   *************************************************
;   * 2 input NAND gate simulator subroutine         *
;   *                                               *
;   * input: AL bits 0,1                            *
;   * output AH, bit 0                              *
;   *************************************************
    XNAND:
    
        MOV BL, AL          ; copy of input bits into BL
        MOV CL, AL          ; and another in CL
        AND BL, 00000001B   ; mask off all bits except input bit 0
        AND CL, 00000010B   ; mask off all bits except input bit 1
        SHR CL, 1           ; move bit 1 value into bit 0 of CL register
                            ; now we have the binary value of each bit in BL and CL, in bit 0 location
        AND BL, CL          ; AND these two registers, result in BL
        NOT BL              ; invert bits for the not part of nand
        AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
        
        MOV AH, BL          ; copy answer into return value register
        RET                 ; uncomment for subroutine
        
    
;   *************************************************
;   * 2 input OR gate simulator subroutine          *
;   *                                               *
;   * input: AL bits 0,1                            *
;   * output AH, bit 0                              *
;   *************************************************
    XoOR:
    
    MOV BL,AL           ; copy of input bits into BL
    MOV CL,AL           ; and another in CL
    AND BL, 00000001B   ; mask off all bits except input bit 0
    AND CL, 00000010B   ; mask off all bits except input bit 1
    SHR CL,1            ; move bit 1 value into bit 0 of CL register
                        ; now we have the binary value of each bit in BL and CL, in bit 0 location
    OR BL,CL            ; OR these two registers, result in BL
    AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
    
    MOV AH, BL          ; copy answer into return value register
    RET                 ; uncomment for subroutine
 
    
;   *************************************************
;   * 2 input NOR gate simulator subroutine         *
;   *                                               *
;   * input: AL bits 0,1                            *
;   * output AH, bit 0                              *
;   *************************************************
    XNOR:
    
    MOV BL,AL           ; copy of input bits into BL
    MOV CL,AL           ; and another in CL
    AND BL, 00000001B   ; mask off all bits except input bit 0
    AND CL, 00000010B   ; mask off all bits except input bit 1
    SHR CL,1            ; move bit 1 value into bit 0 of CL register
                        ; now we have the binary value of each bit in BL and CL, in bit 0 location
    OR BL,CL            ; OR these two registers, result in BL
    NOT BL              ; invert bits for the not part of nor
    AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
    
    MOV AH, BL          ; copy answer into return value register
    RET                 ; uncomment for subroutine
    
    
;   *************************************************
;   * 2 input XOR gate simulator subroutine         *
;   *                                               *
;   * input: AL bits 0,1                            *
;   * output AH, bit 0                              *
;   *************************************************
    XXOR:
    
    MOV BL,AL           ; copy of input bits into BL
    MOV CL,AL           ; and another in CL
    AND BL, 00000001B   ; mask off all bits except input bit 0
    AND CL, 00000010B   ; mask off all bits except input bit 1
    SHR CL,1            ; move bit 1 value into bit 0 of CL register
                        ; now we have the binary value of each bit in BL and CL, in bit 0 location
    XOR BL,CL           ; XOR these two registers, result in BL
    AND BL, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
    
    MOV AH, BL          ; copy answer into return value register
    RET                 ; uncomment for subroutine
   
END START 
