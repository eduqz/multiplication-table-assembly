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
    cont db '0', 0
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
;Esse macro recebe como parâmetros o texto e as posições x e y do cursor
%macro escreveTexto 3 
	mov  ah, 02h
	mov  bh, 0
    mov  dl, %2
    mov  dh, %3
	int  10h
    mov si, %1
    call escreveString
%endmacro

;Esse macro recebe como parâmetros a pergunta e a resposta correta, para definir se o usuário acertou ou não
%macro pergunta 2
	call limpaTela
    escreveTexto %1,28,12
    escreveTexto instrucao2,25,25

    call esperaEnter

    ;Lê resposta
    mov bl, 15
	call limpaTela
	call leTeclado

    ;Compara resposta
    mov di, resposta    
    mov si, %2
    call comparaString

    jnc errou
    call acertou
%endmacro


;Funções
fundoVermelho:
	mov ah, 0xb
	mov bh, 0
	mov bl, 4
	int 10h

	ret

fundoAzul:
	mov ah, 0xb
	mov bh, 0
	mov bl, 1
	int 10h

	ret

fundoVerde:
	mov ah, 0xb
	mov bh, 0
	mov bl, 2
	int 10h

escreveChar:
    mov ah, 0x0e
    int 10h
    ret

leChar:
    mov ah, 0x00
    int 16h
    ret

removeChar:
    mov al, 0x08
    call escreveChar
    mov al, ' '
    call escreveChar
    mov al, 0x08
    call escreveChar
    ret

leTeclado:
    xor cx, cx
    .loop:
        call leChar
        cmp al, 0x08
        je .teclaEspaco
    cmp al, 0x0d
    je .fim
    cmp cl, 10
    je .loop
    
    stosb
    inc cl
    call escreveChar
    
    jmp .loop
    .teclaEspaco:
        cmp cl, 0
        je .loop
        dec di
        dec cl
        mov byte[di], 0
        call removeChar
    jmp .loop
    .fim:
    mov al, 0
    stosb
    call fimLeitura
    ret

fimLeitura:
    mov al, 0x0a
    call escreveChar
    mov al, 0x0d
    call escreveChar
    ret

limpaTela:
    mov ah, 0
	mov al, 12h
	int 10h
	ret

escreveString:
	lodsb
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h

    cmp al, 0
    jne escreveString
    ret

esperaEnter:
	mov di, resposta
	call leChar
	cmp al, 13
	jne esperaEnter

	ret

acertou:
    mov dl, [cont]
    inc dl
    mov [cont], dl

    call limpaTela
    call fundoVerde

    escreveTexto acertoMsg,33,14
    escreveTexto instrucao3,25,25
    
    escreveTexto pontuacao,35,3
    escreveTexto cont,42,3

    call esperaEnter
    ret

errou:
    call limpaTela
    call fundoVermelho

    escreveTexto erroMsg,34,14
    escreveTexto instrucao4,25,25

    escreveTexto pontuacao,35,3
    escreveTexto cont,42,3


    call esperaEnter
    call start

comparaString:
	.loop1:
		lodsb
		cmp al, byte[di]
		jne .diferente
		cmp al, 0
		je .igual
		inc di
		jmp .loop1
	.diferente:
		clc
		ret
	.igual:
		stc
		ret

fim:
    jmp $
    jmp 0x7e00

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
    call fundoAzul
    escreveTexto vencedor,25,10
    call fim


;Função principal
start:
    mov ax, 0
 	mov ds, ax
 	mov es, ax
	mov bh, 0
    mov dl, 48

    ;Zera contador
    mov dl, [cont]
    mov dl, '0'
    mov [cont], dl

	call limpaTela

    ;Imprimir texto na tela
    escreveTexto titulo,26,10
    escreveTexto descricao,12,12
    escreveTexto instrucao1,25,25

    call esperaEnter
    je quiz