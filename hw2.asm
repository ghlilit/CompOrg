Model small

.data
A DB 5

.code
org 0100H

START:
      MOV AX,@DATA      ;moving to AX the address of our data
      MOV DS,AX         ;moving the Data pointer to AX

      MOV AH,00H        ;setting AH to 0, so that no flags are affected if the result is bigger than AL can store
      MOV AL,A          ;keeping the initial value of A in AL register before decrementing
      
L1:   DEC A             ;loop start, decrementing the A
      MUL A             ;multiplies the AL register content with A, stores in AX
      MOV CL,A          ;moving the decremented A value to CL
      CMP CL,01         ;checking if it is one, base case
      JNZ L1            ;if not start again, the program computes the factorial of A

      MOV AH,4CH        ;Moving the exit interrupt command to AH
      INT 21H           ;Calling interrupt 21 to exit the program

END START