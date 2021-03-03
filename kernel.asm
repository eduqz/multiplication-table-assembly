org 0x7e00
jmp 0x0000:start

;Dados do projeto
data:
    titulo db 'JOGO DA TABUADA',0
    tutorial db 'Digite o resultado da operacao e pressione [enter] para confirmar',0
    instrucao1 db 'Pressione [enter] para iniciar',0
    instrucao2 db 'Pressione [enter] para responder',0
    instrucao3 db 'Pressione [enter] para continuar',0
    resposta times 20 db 0
    acertoMsg db 'ACERTOU MISERA',0
    erroMsg db 'ERROU MISERA',0
    pontuacao db 'Pontuacao: ',0
    perg1 db '5 x 7 = ',0
    resp1 db '35',0
    perg2 db '7 x 9 = ',0
    resp2 db '63',0
    perg3 db '7 x 7 = ',0
    resp3 db '49',0
    perg4 db '9 x 9 = ',0
    resp4 db '81',0
    perg5 db '6 x 7 = ',0
    resp5 db '42',0
    perg6 db '11 x 7 = ',0
    resp6 db '77',0
    perg7 db '49 x 21 = ',0
    resp7 db '1029',0
    perg8 db '65 x 56 = ',0
    resp8 db '3640',0
    perg9 db '14 x 19 = ',0
    resp9 db '266',0
    perg10 db '123 x 321  = ',0
    resp10 db '39483',0


;Macros
%macro escreveTexto 3
	mov  ah, 02h
	mov  bh, 0
    mov  dl, %2
    mov  dh, %3
	int  10h
    mov si, %1
    call printString
%endmacro


;Funções
redBackground:
	mov ah, 0xb
	mov bh, 0
	mov bl, 4
	int 10h

	ret

blueBackground:
	mov ah, 0xb
	mov bh, 0
	mov bl, 1
	int 10h

	ret

greenBackground:
	mov ah, 0xb
	mov bh, 0
	mov bl, 2
	int 10h

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
	mov al, 12h
	int 10h
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

waitEnter:
	mov di, resposta
	call getchar
	cmp al, 13
	jne waitEnter

	ret

acertou:
    inc dl
    call limpaTela
    call greenBackground

    escreveTexto acertoMsg,25,14
    escreveTexto instrucao3,25,18
    escreveTexto pontuacao,25,20

    mov al,dl
    call putchar

    call waitEnter
    ret

errou:
    call limpaTela
    call redBackground

    escreveTexto erroMsg,25,14
    escreveTexto instrucao3,25,18
    escreveTexto pontuacao,25,20

    mov al,dl
    call putchar

    call waitEnter
    ret

strcmp:             ; mov si, string1, mov di, string2
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


%macro pergunta 2
	call limpaTela
    escreveTexto %1,20,10
    escreveTexto instrucao2,25,14

    call waitEnter

    ;Lê resposta
    mov bl, 15
	call limpaTela
	call gets

    ;Compara resposta
    mov di, resposta    
    mov si, %2
    call strcmp
    
    jnc errou
    call acertou
%endmacro

quiz:
    ;xor dx,dx
    mov dl, '0'
    pergunta perg1,resp1
    pergunta perg2,resp2
    pergunta perg3,resp3
    pergunta perg4,resp4
    pergunta perg5,resp5
    pergunta perg6,resp6
    pergunta perg7,resp7
    pergunta perg8,resp8
    pergunta perg9,resp9
    pergunta perg10,resp10
    

start:
    mov ax, 0
 	mov ds, ax
 	mov es, ax
	mov bh, 0

	call limpaTela

    ;Imprimir texto na tela
    escreveTexto titulo,32,10
    escreveTexto tutorial,8,12
    escreveTexto instrucao1,25,14

    call waitEnter
    je quiz
   
fim:
    jmp $
    jmp 0x7e00