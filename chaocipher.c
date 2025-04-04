#include <stdio.h>
#include <string.h>

#define SIZE 26

// Alfabetos iniciais fixos
char lAlphabet[] = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
char rAlphabet[] = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

// Função auxiliar para copiar array
void copy_array(char *dest, char *src) {
    for (int i = 0; i < SIZE; i++) {
        dest[i] = src[i];
    }
}

// Permutação do disco esquerdo (LEFT)
void permute_left(char *left, int index) {
    char temp[SIZE];
    char store;

    // Rotaciona colocando a letra da posição `index` no início
    for (int j = index; j < SIZE; j++) temp[j - index] = left[j];
    for (int j = 0; j < index; j++) temp[SIZE - index + j] = left[j];

    // Move a 2ª letra para a 13ª posição
    store = temp[1];
    for (int j = 2; j < 14; j++) temp[j - 1] = temp[j];
    temp[13] = store;

    copy_array(left, temp);
}

// Permutação do disco direito (RIGHT)
void permute_right(char *right, int index) {
    char temp[SIZE];
    char store;

    // Rotaciona colocando a letra da posição `index` no início
    for (int j = index; j < SIZE; j++) temp[j - index] = right[j];
    for (int j = 0; j < index; j++) temp[SIZE - index + j] = right[j];

    // Roda uma posição à esquerda
    store = temp[0];
    for (int j = 1; j < SIZE; j++) temp[j - 1] = temp[j];
    temp[SIZE - 1] = store;

    // Move a 3ª letra para a 13ª posição
    store = temp[2];
    for (int j = 3; j < 14; j++) temp[j - 1] = temp[j];
    temp[13] = store;

    copy_array(right, temp);
}

// Função para criptografar
void encrypt(const char *plainText, char *cipherText) {
    char left[SIZE], right[SIZE], temp;
    int index;
    copy_array(left, lAlphabet);
    copy_array(right, rAlphabet);

    for (int i = 0; plainText[i] != '\0'; i++) {
        printf("%.*s  %.*s\n", SIZE, left, SIZE, right);

        // Localiza a letra no disco da direita e substitui pela mesma posição na esquerda
        for (index = 0; index < SIZE; index++) {
            if (right[index] == plainText[i]) break;
        }

        cipherText[i] = left[index];

        // Última letra? Não permutar
        if (plainText[i + 1] == '\0') break;

        permute_left(left, index);
        permute_right(right, index);
    }

    cipherText[strlen(plainText)] = '\0'; // Finaliza string
}

// Função para descriptografar
void decrypt(const char *cipherText, char *plainText) {
    char left[SIZE], right[SIZE];
    int index;
    copy_array(left, lAlphabet);
    copy_array(right, rAlphabet);

    for (int i = 0; cipherText[i] != '\0'; i++) {
        // Localiza a letra no disco da esquerda e substitui pela mesma posição na direita
        for (index = 0; index < SIZE; index++) {
            if (left[index] == cipherText[i]) break;
        }

        plainText[i] = right[index];

        // Última letra? Não permutar
        if (cipherText[i + 1] == '\0') break;

        permute_left(left, index);
        permute_right(right, index);
    }

    plainText[strlen(cipherText)] = '\0'; // Finaliza string
}

int main() {
    const char *input = "WELLDONEISBETTERTHANWELLSAID";
    char encrypted[100], decrypted[100];

    printf("Texto original: %s\n\n", input);
    printf("Discos após cada permutação (durante criptografia):\n\n");
    encrypt(input, encrypted);
    printf("\nTexto criptografado: %s\n", encrypted);

    decrypt(encrypted, decrypted);
    printf("Texto recuperado : %s\n", decrypted);

    return 0;
}
