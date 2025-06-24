; Bootloader em Assembly - Atende exatamente ao pedido do professor
; Usa real mode da BIOS, lê entrada, concatena e exibe

[BITS 16]           ; Modo 16-bit (real mode)
[ORG 0x7C00]        ; Bootloader carrega em 0x7C00

start:
    ; Configuração inicial dos segmentos
    cli                 ; Desabilita interrupções
    xor ax, ax         ; ax = 0
    mov ds, ax         ; Data segment = 0
    mov es, ax         ; Extra segment = 0
    mov ss, ax         ; Stack segment = 0
    mov sp, 0x7C00     ; Stack pointer
    sti                ; Reabilita interrupções

    ; Limpa a tela
    mov ah, 0x00       ; Função: set video mode
    mov al, 0x03       ; Modo: 80x25 texto colorido
    int 0x10           ; Chama BIOS

    ; Exibe mensagem inicial
    mov si, msg_input
    call print_string

    ; Lê entrada do usuário
    mov di, buffer_nome
    call read_input

    ; Exibe prefixo "Ola, "
    mov si, msg_prefix
    call print_string

    ; Exibe nome digitado
    mov si, buffer_nome
    call print_string

    ; Nova linha
    mov ah, 0x0E
    mov al, 0x0D       ; Carriage return
    int 0x10
    mov al, 0x0A       ; Line feed
    int 0x10

    ; Loop infinito
    jmp $

; Função para imprimir string
; Entrada: SI = ponteiro para string terminada em 0
print_string:
    pusha              ; Salva todos os registradores
.loop:
    lodsb              ; Carrega byte de [SI] em AL, incrementa SI
    test al, al        ; Testa se AL = 0
    jz .done           ; Se zero, termina
    mov ah, 0x0E       ; Função BIOS: print char
    mov bh, 0          ; Página de vídeo
    int 0x10           ; Chama BIOS
    jmp .loop          ; Continua
.done:
    popa               ; Restaura registradores
    ret

; Função para ler entrada do usuário
; Entrada: DI = buffer de destino
read_input:
    pusha
.read_loop:
    mov ah, 0x00       ; Função BIOS: read key
    int 0x16           ; Chama BIOS (resultado em AL)
    
    cmp al, 0x0D       ; Verifica se é Enter (CR)
    je .done           ; Se for, termina
    
    cmp al, 0x08       ; Verifica se é Backspace
    je .backspace      ; Trata backspace
    
    cmp al, 0x20       ; Verifica se é caractere imprimível
    jb .read_loop      ; Se menor que espaço, ignora
    
    ; Armazena caractere e exibe
    stosb              ; Armazena AL em [DI], incrementa DI
    mov ah, 0x0E       ; Função BIOS: print char
    int 0x10           ; Exibe caractere
    jmp .read_loop     ; Continua lendo
    
.backspace:
    cmp di, buffer_nome ; Verifica se está no início
    je .read_loop      ; Se sim, ignora backspace
    dec di             ; Volta uma posição no buffer
    
    ; Apaga da tela: backspace, espaço, backspace
    mov ah, 0x0E
    mov al, 0x08       ; Backspace
    int 0x10
    mov al, 0x20       ; Espaço
    int 0x10
    mov al, 0x08       ; Backspace novamente
    int 0x10
    jmp .read_loop

.done:
    mov al, 0          ; Termina string com 0
    stosb
    popa
    ret

; Dados
msg_input:    db 'Digite seu nome: ', 0
msg_prefix:   db 0x0D, 0x0A, 'Ola, ', 0  ; Nova linha + "Ola, "
buffer_nome:  times 32 db 0               ; Buffer para o nome

; Padding e assinatura do bootloader
times 510-($-$$) db 0    ; Preenche até 510 bytes
dw 0xAA55                ; Assinatura bootloader