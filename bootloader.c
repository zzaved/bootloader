#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>

#define MAX_NOME 50
#define PREFIXO "Ola, "

void limpar_tela() {
    system("cls");
}

void imprimir_char(char c) {
    putchar(c);
    fflush(stdout);
}

void imprimir_string(const char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        imprimir_char(str[i]);
    }
}

void ler_nome(char* buffer) {
    int pos = 0;
    char c;
    
    while (1) {
        c = getch();
        
        if (c == '\r' || c == '\n') {
            buffer[pos] = '\0';
            imprimir_char('\n');
            break;
        }
        else if (c == '\b' || c == 127) {
            if (pos > 0) {
                pos--;
                imprimir_char('\b');
                imprimir_char(' ');
                imprimir_char('\b');
            }
        }
        else if (c >= 32 && c <= 126 && pos < MAX_NOME - 1) {
            buffer[pos] = c;
            pos++;
            imprimir_char(c);
        }
    }
}

int main() {
    char nome[MAX_NOME];
    char mensagem_final[MAX_NOME + 20];
    
    limpar_tela();
    
    imprimir_string("SIMULADOR DE BOOTLOADER DO PABLITO\n");
    
    imprimir_string("Digite seu nome: ");
    ler_nome(nome);
    
    if (strlen(nome) == 0) {
        strcpy(nome, "Usuario");
    }
    
    strcpy(mensagem_final, PREFIXO);
    strcat(mensagem_final, nome);
    
    imprimir_string("\nResultado:\n");
    imprimir_string(mensagem_final);
    imprimir_string("\n\n");
    
    imprimir_string("Pressione qualquer tecla para sair...\n");
    getch();
    
    return 0;
} 
