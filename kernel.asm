org 0x7e00
jmp 0x0000:start

;Dados do projeto
titulo db 'JOGO DA TABUADA', 0
tutorial db 'Digite o resultado da operacao e pressione [enter] para confirmar', 0
instrucao1 db 'Pressione [enter] para iniciar', 0

perg1 db '5 x 7 = ', 0
resp1 db '35', 0
perg2 db '7 x 9 = ', 0
resp2 db '63', 0


;Funções
limpaTela:
    mov ah, 0
    mov al,12h
    int 10h

    mov ah, 0bh
    mov bh, 0
    mov bl, 1
    int 10h 

printString:
	lodsb
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h

    cmp al, 0
    jne printString
    ret


printaTextoDigitado:
    mov ah, 0
    int 16h

    ;lodsb
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    inc dl
    int 10h

    ;jmp printaTextoDigitado



%macro escreveTexto 3
	mov  ah, 02h
	mov  bh, 0
    mov  dl, %2
    mov  dh, %3
	int  10h
    mov si, %1
    call printString
%endmacro

%macro pergunta 2
	call limpaTela
    escreveTexto %1,20,10

    call printaTextoDigitado

    mov ah, 0
    int 16h

    cmp al, 13
    je %2
%endmacro

quiz:
    pergunta perg1, fim


fim:
    ret


start:
    xor ax,ax
	mov ds,ax

    call limpaTela

    ;Imprimir texto na tela
    escreveTexto titulo,32,10
    escreveTexto tutorial,8,12
    escreveTexto instrucao1,25,14

    ;Aguarda pressionar enter
    mov ah, 0
    int 16h
        
    ;Comparando com 'enter'
    cmp al, 13
    je quiz
   
jmp 0x7e00