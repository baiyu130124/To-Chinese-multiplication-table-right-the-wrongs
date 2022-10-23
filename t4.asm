DATAS SEGMENT
table  db 7,2,3,4,5,6,7,8,9                               ;九九乘法表
       db 2,4,7,8,10,12,14,16,18
       db 3,6,9,12,15,18,21,24,27
       db 4,8,12,16,7,24,28,32,36
       db 5,10,15,20,25,30,35,40,45
       db 6,12,18,24,7,36,42,48,54
       db 7,14,21,28,35,42,49,56,63
       db 8,16,24,32,40,48,56,7,72
       db 9,18,27,36,45,54,63,72,81                     
CRLF   DB  0AH, 0DH,'$'     ;换行符
OUTPUT1 DB "The position of the error in the multiplication table is :",'$'
OUTPUTXY DB "X    Y",'$'

OUTER    DB 0,"    ",0,'$'
DATAS ENDS
 
STACKS SEGMENT
    DW  20  DUP(1)                                          ;此处输入堆栈段代码  
STACKS ENDS
 
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV AX,STACKS
    MOV SS,AX
    MOV SP,40

    LEA DX, OUTPUT1                  ;输出字符串
    MOV AH, 09H							 
    INT 21H
 

    LEA DX, CRLF                  ;换行                   
    MOV AH, 09H							 
    INT 21H
  
    LEA DX, OUTPUTXY                  ;输出XY首行
    MOV AH, 09H							 
    INT 21H
  

    LEA DX, CRLF                  ;换行                   
    MOV AH, 09H							 
    INT 21H
  
    MOV DI,0           
    MOV BX,0
    MOV CX,9
    MOV AX,0
XP: INC AX              ;表示行数
    MOV BX,0
    PUSH AX
    PUSH CX

    MOV CX,9
YP: INC BX              ;表示列数
    
    PUSH AX             ;计算table对应的位置
    DEC AX
    MOV SI,9
    MUL SI
    DEC BX
    MOV SI,BX
    INC BX
    ADD AX,SI
    MOV DI,AX            ;DI存放对应的位置


    POP AX
    PUSH AX
    MUL BX                ;16位乘法，结果低16位存放在AX中，高16位DX中
  
    PUSH BX
    MOV BX,0
    MOV BL,table[DI]
    CMP AX,BX
    JNZ ER
    POP BX
    POP AX
FR: LOOP YP
    POP CX
    POP AX
    LOOP XP
   

    
    JMP OK
ER: POP BX
    POP AX
    PUSH AX
    PUSH BX
    XOR AL,30H
    XOR BL,30H
    MOV OUTER[0],AL
    MOV OUTER[5],BL
    POP BX
    POP AX
    LEA DX, OUTER              ;输出错误XY的位置
    MOV AH, 09H							 
    INT 21H
  
    
    LEA DX, CRLF                  ;换行                   
    MOV AH, 09H							 
    INT 21H
    MOV AH,0
    JMP FR




OK: MOV AH,4CH
    INT 21H
CODES ENDS
    END START