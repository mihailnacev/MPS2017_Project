data segment
        
        vnesi db "Vnesi A:$"
        vnesii db "Vnesi B:$"
        A db 50 dup ('a')      ; inicijalizacija prazni
        B db 50 dup ('b')
        dolzina db ? 
        pod db "Podstring$"
        nepod db "NE E PODSTRING$"
        flagce db 0d
        
ends

stack segment
    dw   128  dup(0)
ends

code segment
    
    procedura proc
         
      pop dx
      pop bx
      mov di,bx
      pop bx
      mov si,bx
      mov ah,0d
      mov al,36d
      mov ch,0d
      mov cl,0d ; brojac
      
      mov bh,0d
      mov bl,0d
     
      
      golemina:
      
      mov bl,[si]
      cmp bl,36d
      je izlez
      inc cl
      inc si
      jmp golemina
      
      izlez:
      
      mov dolzina,cl
      mov cl,0d 
      lea si, A
      inc si
      inc si
      
 
      ciklus:
      
      scasb
      je kraj
      dec di
      
      cmpsb
      je ednakvo
      
      ;ne ednakvo 

      dec si
      cmp cl, 0d
      ja vrati
      jmp ciklus
      
      vrati:
      cmp cl, dolzina
      je flag 
      sub si,cx
      dec di
      mov cl,0d
      jmp ciklus
      
      ednakvo:
      
      inc cl  
       cmp cl, dolzina
    je flag
 
      jmp ciklus 
      
  
   
  
     
    flag:  
         mov flagce,1d
    kraj:
     mov ah,0d
    mov al,flagce
    
    push ax
    push dx 
    
    ret
          
    procedura endp
    
    
    
    
    
start:

    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
    
    mov ah,09h
    lea dx, vnesi
    int 21h
    
    mov ah,0ah
    lea dx, A
    int 21h
    
    mov ah,09h
    lea dx,vnesii
    int 21h
    
    mov ah,0ah
    lea dx, B
    int 21h
    
    lea si,A
    lea di,B 
    
    inc si
    inc si
    inc di
    inc di
    
    push si
    push di 
    
    call procedura
    
    pop ax
    
    cmp ax,1d
    je podstring
    
    ; ne e podstring
    
    mov ah,09h
    lea dx, nepod
    int 21h
    jmp konecno
    
    podstring:
    
    mov ah,09h
    lea dx, pod
    int 21h
   

konecno:   
    

mov ax, 4c00h
int 21h  

ends

end start
