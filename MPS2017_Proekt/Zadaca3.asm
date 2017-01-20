data segment 
    
    vnesi db "n=$"    
    suma dw 0
    n db ?
    temp db 50 dup('a')

ends

stack segment
    dw   128  dup(0)
ends

code segment
    
    sumiranje proc
    
    pop bp ; pokazuvac
    pop si ; efektivnata adresa na tmp
    pop dx ; suma
    pop bx ; promenliva n
    
    ciklus2:
    
    cmp bx,1d
    je izlez2
    add dx,bx
    mov ax,bx
    cmp ax,9
    ja konvert
    ; ako ne e pogolem od 9
    add ax,48d
    mov [si],ax
    inc si
    mov [si],43d
    inc si
    dec bx
    jmp ciklus2
    
    konvert:
    
    mov ch,0d
    mov cl,10d
    div cl
    add ah,48d
    add al,48d
    mov [si],al
    inc si
    mov [si],ah
    inc si
    mov [si],43d
    inc si
    dec bx
    jmp ciklus2
    
    izlez2:
       
    add dx,1 
    mov [si],49d
    inc si
    mov [si],61d
    inc si 
    ; konverter za sumata
    
    mov ax,dx
    mov ch,0d
    mov cl,10d
    div cl
    add ah,48d
    add al,48d
    mov [si],al
    inc si
    mov [si],ah
    inc si
    mov [si],36d
    inc si

    lea si,temp
    
    push si              
    push dx
    push bp                            
                  
    ret
                  
    sumiranje endp    
    
    
start:
    
    mov ax, data
    mov ds, ax
    mov es, ax
    
    ; add your code here
    
    mov ah,09h
    lea dx,vnesi
    int 21h
    
    mov dh,0d
    mov dl,0d
    mov bh,0d
    mov bl,0d
    mov ch,0d
    mov cl,10d
    
    mov ah,01h
    int 21h
    
    ciklus:
    cmp al,36d
    je izlez
    
    ;ne e # za izlez 
    sub al,48d
    mov bl,al
    mov al,dl
    mul cl
    mov dl,al
    add dl,bl
    mov ah,01h
    int 21h
    jmp ciklus
    
    izlez:
    
    mov n,dl
    push dx
    push suma
    lea si,temp
    push si
    
    call sumiranje
    
    pop dx
    mov suma,dx
    pop si
    
    
    mov ah,09h
    lea dx,temp
    int 21h
    
mov ax, 4c00h
int 21h  

ends

end start
