data segment
  registracija db 120 dup(?)
  tekovnaR db 12 dup(?)
  tekovnaA dw 0
  brojacR dw 0
  komanda dw ?
  pomosnaR db 12 dup(?)
  tempBrojac dw 0
  fiksna db 12d
  fiksna1 db 10d
  tekovnaD db 6 dup(?)
  
  pomMesecB dw 0
  pomGodinaB dw 0
  pomMesecV dw 0
  pomGodinaV dw 0
  flagGod db 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
mov ax,data
mov es,ax 
mov ds,ax

mov tekovnaA, OFFSET registracija 
include 'emu8086.inc'   
printn "Vnesete komanda (ADD,ERASE,FIND)"

glaven:     

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
   mov komanda,0
   je vnesR
   jne greska
   
vnesSpace2:
   mov ah,1
   int 21h
   cmp al,' '
   ;mov ch,1  ; eden za ERASE
   mov komanda,1
   je vnesR
   jne greska
   
vnesSpace3:
   mov ah,1
   int 21h
   cmp al,' '
   ;mov ch,2  ; dva za FIND
   mov komanda,2
   je skratenFormat
   jne greska        

skratenFormat:

lea DI,tekovnaD
mesec:
mov ah,1
int 21h
cmp al,48d
jb greska
cmp al,49d
jg greska
stosb

mov ah,1
int 21h
cmp al,48d
jb greska
cmp al,57d
jg greska
stosb

crta:
mov ah,1
int 21h
cmp al,'-'
jne greska
stosb

godina:
mov ah,1
int 21h
cmp al,48d
jb greska
cmp al,57d
jg greska
stosb

mov ah,1
int 21h
cmp al,48d
jb greska
cmp al,57d
jg greska
stosb

terminator:
mov ah,1
int 21h
cmp al,'$'
jne greska
stosb
printn ""
mov BP,brojacR
mov BX,0
delba_registracii2:
lea DI,pomosnaR
lea SI,registracija
add SI,BX
cmp BP,0
je krajDelba

mov CX,12
zacuvuvanjeVoPomR2:
movsb
loop zacuvuvanjeVoPomR2

lea SI,pomosnaR
add SI,5d
mov AX,0
mov AX,[SI]
mov al,ah
mov ah,0
sub ax,48d
mul fiksna1
inc SI
mov pomMesecB,ax
 
mov AX,0
mov AX,[SI]
mov al,ah
mov ah,0
sub AX,48d

add pomMesecB,ax

;dobro e
inc SI
inc SI

mov AX,0
mov AX,[SI]
mov al,ah
mov ah,0
sub AX,48d
mul fiksna1
inc SI
mov pomGodinaB,ax

mov AX,0
mov AX,[SI]
mov al,ah
mov ah,0
sub AX,48d

add pomGodinaB,ax
;dobro e2

lea SI,tekovnaD
mov AX,0
mov AX,[SI]
;mov al,ah
mov ah,0
sub AX,48d
mul fiksna1
inc SI
mov pomMesecV,ax

mov AX,0
mov AX,[SI]
;mov al,ah
mov ah,0
sub AX,48d

add pomMesecV,ax

inc SI
inc SI

mov AX,0
mov AX,[SI]
;mov al,ah
mov ah,0
sub AX,48d
mul fiksna1
inc SI
mov pomGodinaV,ax

mov AX,0
mov AX,[SI]
;mov al,ah
mov ah,0
sub AX,48d

add pomGodinaV,ax


;FINITO
mov flagGod,0d
mov ax,0
mov ax,pomGodinaV
cmp AX,pomGodinaB
je vtoraProverka
dec ax
cmp ax,pomGodinaB
mov flagGod,1d
je vtoraProverka
jmp skokDruga

vtoraProverka:
cmp flagGod,0d
je istaGod

razlicnaGodina:
mov ax,0
mov ax,pomMesecV
cmp ax,pomMesecB
jle istaGod
jmp skokDruga

istaGod:
lea DX,pomosnaR
mov ah,9d
int 21h
printn ""

skokDruga:
add BX,12d
dec BP
jmp delba_registracii2



krajDelba:

printn ""  
jmp glaven

vnesR:

;cmp ch,0d
;jne find
;cmp ch,1d 
;jne find
lea si,tekovnaR
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


proverkaPrviTri:

mov si, OFFSET tekovnaR
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
cmp [si], 49d
jg gresenFormat
inc si         
cmp [si], 48d
jl gresenFormat
cmp [si], 57d
jg gresenFormat
inc si
cmp [si], 45d    ;proverka za crta
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
;je proverkaRegVoMem
cmp komanda,0
je proverkaRegVoMem
cmp komanda,1
je erase
cmp komanda,2
je find
              
              
  
greska:
printn ""
printn "Ne postoi takva operacija"
jmp glaven
;add your code here
    
proverkaRegVoMem:
mov dx,brojacR
dec dx

povtoruvanjeProverka:
cmp dx,-1d
je krajProverka
mov al,12
mul dl
lea si, tekovnaR
lea di, registracija
add di, ax

MOV CX, 6 
REPE CMPSB 
JB prodolziProverka
JA prodolziProverka
;ako veke e dodadena registracija vo nizata
jmp prebrisi
prodolziProverka:
dec dx
jmp povtoruvanjeProverka

krajProverka:
inc brojacR
mov cx,12
lea si,tekovnaR
mov di,tekovnaA

kopiranje:
movsb
loop kopiranje

add tekovnaA,12
printn ""
jmp glaven
prebrisi:
mov cx,6
repe movsb

printn ""
jmp glaven

find:
jmp glaven

erase:
mov DX,brojacR
mov BX,0
delba_registracii:
lea DI,pomosnaR
lea SI,registracija
add SI,BX
cmp DX,0
je krajErase

mov CX,12
zacuvuvanjeVoPomR:
movsb
loop zacuvuvanjeVoPomR

lea SI,tekovnaR
lea DI,pomosnaR
MOV CX, 12 
REPE CMPSB 
JB prodolziP
JA prodolziP
;ako veke e najdena registracijata koja treba da se brise
lea DI,registracija
add DI,BX ;pocetok na dupkata vo memorija
;mov CX,12
;mov al,0
lea SI,registracija
add SI,BX
add SI,12d
mov AX,brojacR
mul fiksna
add BX,12d
sub AX,BX
cmp AX,0d
je da
mov CX,AX
jmp k
da:
mov cx,12d
k:
shiftanjePrazno:
movsb
loop shiftanjePrazno

skok:
mov AX,brojacR
dec AX
mul fiksna

lea DI,registracija
add DI,AX
mov CX,12d

mov AX,0
polnenjeNuli:
stosb
loop polnenjeNuli
dec brojacR
sub tekovnaA,12d
jmp krajErase
;polnenjeNuli:
;stosb  
;loop polnenjeNuli
;jmp krajErase
prodolziP:
dec DX
add BX,12
jmp delba_registracii


krajErase:
printn ""
jmp glaven

gresenFormat:
printn ""
printn "Gresen format"
jmp glaven
                                         
kraj:
mov ax, 4c00h
int 21h  

ends

end start
