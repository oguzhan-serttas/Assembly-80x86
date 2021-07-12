    
 ;This is a dynamic and recursive program that find the Conway number
   
        
    STACKSG SEGMENT PARA STACK 'STACK'
        DW 1000 DUP(?)
    STACKSG ENDS
   
    DATASG SEGMENT PARA 'DATA'
     
    
    array DW 501 DUP(0) 
    searchingNumber1 DW 10
    searchingNumber2 DW 500
    
    
    DATASG ENDS
    
    CODESG SEGMENT PARA 'CODE'
     ASSUME CS:CODESG, DS:DATASG, SS:STACKSG
    
    
    
    START PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX

        MOV AX, DATASG
        MOV DS, AX
        
         
             
             
        MOV AX, searchingNumber1      ;Push searchingNumber1 through AX to give as an argument to CONWAY
		PUSH AX 
        CALL FAR PTR CONWAY 
        POP AX                   	;Pop the return value of CONWAY
        
        CALL FAR PTR PRINTINT      ;Print the number using base on 10
        
        
        MOV CX, searchingNumber1
        ADD CX, 1
        PUSH DI
        LEA DI, array
        
 L1:                            
        MOV [DI],WORD PTR 0
        ADD DI, 2
        
        
        LOOP L1 
        
        POP DI
        
        MOV AX, searchingNumber2
		PUSH AX                     
        CALL FAR PTR CONWAY 
        POP AX
                                   
        
        CALL FAR PTR PRINTINT        
        

        
        
        RETF
    START ENDP
   



CONWAY PROC FAR    

    
        
        LEA DI, array 
        CMP [DI + 2],WORD PTR 1
        JE jump 
           
        
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI 
        PUSH AX  
		PUSH BP
		

		MOV BP, SP
		MOV AX, [BP + 18] 
		
		
		MOV [DI], WORD PTR 0
		MOV [DI + 2] , WORD PTR 1
		MOV [DI + 4] , WORD PTR 1 
		MOV  BX , 2
		
	     
jump:          
         
        
         
         
         MUL BX
         ADD DI, AX
         CMP [DI],WORD PTR 0  
         XOR DX,DX
         DIV BX
         JNE exit 
      
        CMP [DI - 2],WORD PTR 0         ; Is a(n-1) calculated 
        JNE  jump2  
                                         
                                         
                                        
        DEC AX  
        PUSH AX 
        PUSH DI 
        CALL FAR PTR CONWAY
        POP DI
        POP AX 
        INC AX 

           
           
           
jump2:  

       
        PUSH DI
        
        SUB AX, [DI - 2]
        MUL BX
        LEA DI, array
        ADD DI, AX
        
        
        CMP [DI],WORD PTR 0       ; Is a(n - a(n-1)) calculated  
        JNE jump3                 
                                  
        XOR DX,DX
        DIV BX
        PUSH AX 
        PUSH DI
        CALL FAR PTR CONWAY 
        POP DI
        POP AX
      
        
        
jump3:  MOV DX, [DI]
        POP DI
        ADD [DI], DX  	; Add (a(n - a(n-1))) 
        PUSH DI
        
        
        
        MOV AX, [DI - 2]
        MUL BX 
        LEA DI, array
        ADD DI, AX    
        
        CMP [DI],WORD PTR 0              ; Is a(a(n-1)) calculated
        JNE jump4  
                                         
        XOR DX,DX
        DIV BX                           
        PUSH AX 
        PUSH DI
        CALL FAR PTR CONWAY 
        POP DI
        POP AX
       
        
jump4:   
       MOV DX, [DI]
       POP DI
       ADD [DI], DX     ;Add a(a(n-1)) 
        
        
exit:  
       
       PUSH AX 
       PUSH DI
       MOV AX, DI
       LEA DI, array
       MOV CX, DI
       SUB AX, CX
       
       XOR DX,DX         
       DIV BX 
      
       CMP [BP + 18],AX        ; If searchingNumber is calculated then go to exit2
       POP DI
       POP AX 
       JZ exit2 
      
       
        RETF
      
    
    
exit2: 
       MOV CX, [DI]
       MOV [BP + 18], CX  
       
       POP BP             
       POP AX             
       POP DI             
       POP SI             
       POP DX             
       POP CX               
       POP BX     		
       
       RETF 

CONWAY ENDP



PRINTINT PROC FAR 
    
    
    PUSH CX
    PUSH DX
    XOR DX,DX
    PUSH DX
    MOV CX,10
    
calculateDigit:

    DIV CX
    ADD DX, '0'
    PUSH DX
    XOR DX,DX
    CMP AX,0 
    
    JNE calculateDigit
     
print:

    POP AX
    CMP AX, 0
    JE end
    
    PUSH AX 
    PUSH DX
    MOV DL,AL
    MOV AH,2
    INT 21H
    POP DX
    POP AX
    
    JMP print
      
end:   
    POP DX
    POP CX
   
    
    RETF  
    
    PRINTINT ENDP 
    
   
    CODESG ENDS
    END START
