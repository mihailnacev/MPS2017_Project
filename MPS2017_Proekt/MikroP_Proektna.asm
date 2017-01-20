data segment
  registracija db 12 dup ('a')
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
mov ax,data
mov es,ax 
mov ds,ax

include 'emu8086.inc'   
printn "Vnesete komanda (ADD,ERASE,FIND)"     

    prvaADD:
    mov ah,01h
    int 21h
    cmp al,'A'
    je vtoraADD 
    jne ostanato
    
    vtoraADD:
    mov ah,01h
    int 21h
    cmp al,'D'
    je tretaADD
    jne greska
    
    tretaADD:
    mov ah,1
    int 21h
    cmp al,'D'
    je vnesSpace1
    jne greska

ostanato:
    cmp al,'E'
    je vtoraERASE
    jne ostanato2
    
    vtoraERASE:
    mov ah,1
    int 21h
    cmp al,'R'
    je tretaERASE
    jne greska
    
    tretaERASE:
    mov ah,1
    int 21h
    cmp al,'A'
    je cetvrtaERASE
    jne greska
    
    cetvrtaERASE:
    mov ah,1
    int 21h
    cmp al,'S'
    je pettaERASE
    jne greska
    
    pettaERASE:
    mov ah,1
    int 21h
    cmp al,'E'
    je vnesSpace2
    jne greska

ostanato2:

    cmp al,'F'
    je vtoraFIND
    jne greska
    
    vtoraFIND:
    mov ah,1
    int 21h
    cmp al,'I'
    je tretaFIND
    jne greska
    
    tretaFIND:
    mov ah,1
    int 21h
    cmp al,'N'
    je cetvrtaFIND
    jne greska
    
    cetvrtaFIND:
    mov ah,1
    int 21h
    cmp al,'D'
    je vnesSpace3
    jne greska
     
vnesSpace1:
   mov ah,1
   int 21h
   cmp al,' '
   ;mov ch,0  ; nula za ADD
   je vnesR
   jne greska
   
vnesSpace2:
   mov ah,1
   int 21h
   cmp al,' '
   ;mov ch,1  ; eden za ERASE
   je vnesR
   jne greska
   
vnesSpace3:
   mov ah,1
   int 21h
   cmp al,' '
   ;mov ch,2  ; dva za FIND
   je vnesR
   jne greska
        
vnesR:

;cmp ch,0d
;jne find
;cmp ch,1d 
;jne find
mov si,OFFSET registracija
mov cl,12
ciklus:
cmp cl,0d
je proverkaPrviTri
mov ah,1
int 21h
mov [si],al
inc si
dec cl
jmp ciklus

find:

proverkaPrviTri:

mov si, OFFSET registracija
cmp [si],48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si
cmp [si],48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si
cmp [si],48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si

proverkaBukvi:
cmp [si], 65d
jl gresenFormat
cmp [si], 90d
jg gresenFormat
inc si 
cmp [si], 65d
jl gresenFormat
cmp [si], 90d
jg gresenFormat
inc si


proverkaRegSpace:
cmp [si], 32d
jne gresenFormat
inc si

proverkaData:
cmp [si], 48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si         
cmp [si], 48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si
cmp [si], 45d
jne gresenFormat
inc si
cmp [si], 48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si         
cmp [si], 48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si
cmp [si], 36d
jne gresenFormat
je proverkaRegVoMem
              
              
  
greska:

    ; add your code here
    
proverkaRegVoMem:

gresenFormat:
printn "Gresen format"
                                         
kraj:
mov ax, 4c00h
int 21h  

ends

end start
