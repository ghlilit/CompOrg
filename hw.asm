.model small

.stack 100H

.data

.code

start:
    MOV AX, 0       ;moves 0 to AX
    MOV BX, 1000H   ;raeds the status value to BX 
    CMP [BX], AX    ;compares if the status is 0
    JE START        ;if 0, then it is busy,starts again
    MOV AX, 40H     ;moves 40H to AX
    MOV BX, 1001H   ;reads the temperature to BX
    CMP [BX], AX    ;compares if the status is 40H
    JE start        ;if yes, starts again
    JL smaller      ;if low, performs the smaller chunk
    JB big          ;if bigger, performs the big chunk

smaller:    
    MOV AX, 0       ;moves 0 to AX
    MOV BX, 1000H   ;raeds the status value to BX 
    CMP [BX], AX    ;compares if the status is 0
    JE START        ;if 0, then it is busy,starts again
    MOV AX, 9       ;moves 9(AC off, Heater on) to AX
    MOV BX, 1002H   ;moves the command address to BX
    MOV [BX], AX    ;writes 9 to the command address
    JMP start       ;starts again

big:
    MOV AX, 0       ;moves 0 to AX
    MOV BX, 1000H   ;raeds the status value to BX 
    CMP [BX], AX    ;compares if the status is 0
    JE START        ;if 0, then it is busy,starts again
    MOV AX, 6       ;moves 6(AC on, Heater off) to AX
    MOV BX, 1002H   ;moves the command address to BX
    MOV [BX], AX    ;writes 9 to the command address
    JMP start       ;starts again

end start