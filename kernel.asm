org 0x7e00
jmp 0x0000:start

;Dados do projeto
titulo db 'JOGO DA TABUADA', 0
tutorial db 'Digite o resultado da operacao e pressione [enter] para confirmar', 0
instrucao1 db 'Pressione [enter] para iniciar', 0
instrucao2 db 'Pressione [enter] para responder', 0
resposta times 100 db 0
acertoMsg db 'ACERTOU MISERA', 0
erroMsg db 'ERROU MISERA', 0


perg1 db '5 x 7 = ', 0
resp1 db '35', 0
perg2 db '7 x 9 = ', 0
resp2 db '63', 0
perg3 db '7 x 7 = ', 0
resp3 db '49', 0
perg4 db '9 x 9 = ', 0
resp4 db '81', 0
perg5 db '6 x 7 = ', 0
resp5 db '42', 0
perg6 db '11 x 7 = ', 0
resp6 db '77', 0
perg7 db '49 x 21 = ', 0
resp7 db '1029', 0
perg8 db '65 x 56 = ', 0
resp8 db '3640', 0
perg9 db '14 x 19 = ', 0
resp9 db '266', 0
perg10 db '123 x 321  = ', 0
resp10 db '39483', 0



;Funções
putchar:    ;Printa um caractere na tela, pega o valor salvo em al
    mov ah, 0x0e
    int 10h
    ret


prints:             ; mov si, string
    .loop:
        lodsb           ; bota character apontado por si em al 
        cmp al, 0       ; 0 é o valor atribuido ao final de uma string
        je .endloop     ; Se for o final da string, acaba o loop
        call putchar    ; printa o caractere
        jmp .loop       ; volta para o inicio do loop
    .endloop:
    ret


getchar:    ;Pega o caractere lido no teclado e salva em al
    mov ah, 0x00
    int 16h
    ret

delchar:    ;Deleta um caractere lido no teclado
    mov al, 0x08          ; backspace
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08          ; backspace
    call putchar
    ret

gets:                 ; mov di, string, salva na string apontada por di, cada caractere lido na linha
    xor cx, cx          ; zerar contador
    .loop1:
        call getchar
        cmp al, 0x08      ; backspace
        je .backspace
        cmp al, 0x0d      ; carriage return
        je .done
        cmp cl, 10        ; string limit checker
        je .loop1
        
        stosb
        inc cl
        call putchar
        
        jmp .loop1
        .backspace:
            cmp cl, 0       ; is empty?
            je .loop1
            dec di
            dec cl
            mov byte[di], 0
            call delchar
        jmp .loop1
    .done:
    mov al, 0
    stosb
    call endl
    ret

endl:       ;Pula uma linha, printando na tela o caractere que representa o /n
    mov al, 0x0a          ; line feed
    call putchar
    mov al, 0x0d          ; carriage return
    call putchar
    ret

limpaTela:
    mov ah, 0
    mov al,12h
    int 10h

    mov ah, 0bh
    mov bh, 0
    mov bl, 1
    int 10h 


iniciaModoTexto:
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov cx, 2000 
    mov bh, 0
    mov al, 0x20
    mov ah, 0x9
    int 0x10
  
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
    ret


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

    lodsb
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

leResposta:
    call iniciaModoTexto
    mov di, resposta     
    call gets           
    call endl
    mov si, resposta
    call prints
    call endl
        
acertou:
    call limpaTela
    escreveTexto acertoMsg,25,14
    call fim

errou:
    call limpaTela
    escreveTexto erroMsg,25,14
    call fim

pergunta:
	call limpaTela
    escreveTexto perg1,20,10
    escreveTexto instrucao2,25,14

    mov ah, 0
    int 16h

    cmp al, 13
    je esperaResposta

    esperaResposta:
        call leResposta

        mov si, resposta    
        mov di, resp1
        call strcmp
        je acertou
        call errou


strcmp:              ; mov si, string1, mov di, string2, compara as strings apontadas por si e di
    .loop1:
        lodsb
        cmp al, byte[di]
        jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1
    .notequal:
        clc
        ret
    .equal:
        stc
        ret

quiz:
    call pergunta


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
   
fim:
    jmp $
    jmp 0x7e00