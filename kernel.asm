org 0x7e00
jmp 0x0000:start

;Dados do projeto
data:
    titulo db '*** JOGO DA TABUADA ***',0
    descricao db 'Teste seus conhecimentos em matematica com esse quiz',0
    instrucao1 db 'Pressione [enter] para iniciar',0
    instrucao2 db 'Pressione [enter] para responder',0
    instrucao3 db 'Pressione [enter] para continuar',0
    instrucao4 db 'Pressione [enter] para reiniciar',0
    vencedor db 'Parabens! Voce eh um genio da matematica!',0
    resposta times 20 db 0
    acertoMsg db 'ACERTOU MISERA',0
    erroMsg db 'ERROU MISERA',0
    pontuacao db 'SCORE: ',0
    perg1 db 'Qual o resulado de 5 x 7?',0
    resp1 db '35',0
    perg2 db 'Qual o resulado de 7 x 9?',0
    resp2 db '63',0
    perg3 db 'Qual o resulado de 7 x 7?',0
    resp3 db '49',0
    perg4 db 'Qual o resulado de 9 x 9?',0
    resp4 db '81',0
    perg5 db 'Qual o resulado de 6 x 7?',0
    resp5 db '42',0
    perg6 db 'Qual o resulado de 11 x 7?',0
    resp6 db '77',0
    perg7 db 'Qual o resulado de 49 x 21?',0
    resp7 db '1029',0
    perg8 db 'Qual o resulado de 65 x 56?',0
    resp8 db '3640',0
    perg9 db 'Qual o resulado de 14 x 19?',0
    resp9 db '266',0


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
    xor d
    mov dl,50

    call limpaTela
    call greenBackground

    escreveTexto acertoMsg,33,14
    escreveTexto instrucao3,25,25
    escreveTexto pontuacao,35,3

    mov al, 0x08
    mov al, dl
    call putchar

    call waitEnter
    ret

errou:
    call limpaTela
    call redBackground

    escreveTexto erroMsg,34,14
    escreveTexto instrucao4,25,25
    escreveTexto pontuacao,35,3

    mov al, 0x08
    mov al, dl
    call putchar

    call waitEnter
    call start

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
    escreveTexto %1,28,12
    escreveTexto instrucao2,25,25

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
    pergunta perg1,resp1
    pergunta perg2,resp2
    pergunta perg3,resp3
    pergunta perg4,resp4
    pergunta perg5,resp5
    pergunta perg6,resp6
    pergunta perg7,resp7
    pergunta perg8,resp8
    pergunta perg9,resp9
    
    call limpaTela
    call blueBackground
    escreveTexto vencedor,25,10
    call fim

start:
    mov ax, 0
 	mov ds, ax
 	mov es, ax
	mov bh, 0
    mov dl, 48

	call limpaTela

    ;Imprimir texto na tela
    escreveTexto titulo,26,10
    escreveTexto descricao,12,12
    escreveTexto instrucao1,25,25

    call waitEnter
    je quiz
   
fim:
    jmp $
    jmp 0x7e00