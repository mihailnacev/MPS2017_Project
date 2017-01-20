data segment
    
    string db "PR0CES0R$"

ends

stack segment
    dw   128  dup(0)
ends

code segment
start:

    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
    
    lea si, string;
    lea di, string; 
    
    ciklus: 
    
    mov ah, 0d
    mov al, 36d 
    
    scasb  
    je kraj
    dec di  
    
    mov ah,0d
    mov al,48d
    scasb
    je ednakvo
    dec di
    mov al,[di]
    stosb 
    jmp ciklus
    
    ednakvo: 
    
    dec di
    mov al,4Fh 
    stosb
    
    jmp ciklus
     
    
    
kraj:    

mov ax, 4c00h
int 21h  

ends

end start
