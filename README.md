# Quiz da tabuada em Assembly [em modo kernele]

Projeto em desenvolvimento para a disciplina de Infraestrutura de Software - CIn, UFPE.
Trata-se de um quiz no qual são exibidas expressões matemáticas e o usuário tem que responder o valor correto da expressão. Casso erre uma, perde o jogo; caso acerte, acumula 1 ponto no score e prossegue á pergunta seguinte. No total, são 9 perguntas com nível de dificudlade crescente.
O objetivo do projeto é de aprender a utilizar a linguagem Assembly e entender mais sobre Bootloader e modo Kernel.


<h3>Grupo:</h3>

+ Eduardo Almeida de Queiroz (eaq)

+ Juan Felipe Serafim dos Santos (jfss)

+ Marcos Antonio Vital de Lima (mavl)

+ Victor Emanuel Pessoa da Silva (veps)


<h3>Links úteis (tutoriais utilizados):</h3>

+ https://www.joe-bergeron.com/posts/Writing%20a%20Tiny%20x86%20Bootloader/ - Tutoriais para aprender nasm assembly - mais completo.

+ https://www.tutorialspoint.com/assembly_programming/index.htm - Tutoriais para aprender assembly - mais curto e direto.

+ https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders - Informações sobre a arquitetura x86 e Bootloaders.


<h3>Instruções básicas:</h3>

+ Instalar as dependências necessárias:
```
sudo apt install nasm
sudo apt install qemu
```

+ Montar e rodar:
```
make
```
