#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

typedef int bool;
typedef enum { ENCRYPT, DECRYPT } cmode;

const char *l_alphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
const char *r_alphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

void chao(const char *in, char *out, cmode mode, bool show_steps) {
    int i, j, index;
    char store;
    size_t len = strlen(in);
    char left[27], right[27], temp[27];
    strcpy(left, l_alphabet);
    strcpy(right, r_alphabet);
    temp[26] = '\0';

    for (i = 0; i < len; ++i ) {
        if (show_steps) printf("%s  %s\n", left, right);
        if (mode == ENCRYPT) {
            index = strchr(right, in[i]) - right;
            out[i] = left[index];
        }
        else {
            index = strchr(left, in[i]) - left;
            out[i] = right[index];
        }
        if (i == len - 1) break;

        /* permute left */

        for (j = index; j < 26; ++j) temp[j - index] = left[j];
        for (j = 0; j < index; ++j) temp[26 - index + j] = left[j];
        store = temp[1];
        for (j = 2; j < 14; ++j) temp[j - 1] = temp[j];
        temp[13] = store;
        strcpy(left, temp);

        /* permute right */

        for (j = index; j < 26; ++j) temp[j - index] = right[j];
        for (j = 0; j < index; ++j) temp[26 - index + j] = right[j];
        store = temp[0];
        for (j = 1; j < 26; ++j) temp[j - 1] = temp[j];
        temp[25] = store;
        store = temp[2];
        for (j = 3; j < 14; ++j) temp[j - 1] = temp[j];
        temp[13] = store;
        strcpy(right, temp);
    }
}

int main() {
    const char *plain_text = "WELLDONEISBETTERTHANWELLSAID";
    char *cipher_text = malloc(strlen(plain_text) + 1);
    char *plain_text2 = malloc(strlen(plain_text) + 1);
    printf("The original plaintext is : %s\n", plain_text);
    printf("\nThe left and right alphabets after each permutation"
           " during encryption are :\n\n");
    chao(plain_text, cipher_text, ENCRYPT, TRUE);
    printf("\nThe ciphertext is : %s\n", cipher_text);
    chao(cipher_text, plain_text2, DECRYPT, FALSE);
    printf("\nThe recovered plaintext is : %s\n", plain_text2);
    free(cipher_text);
    free(plain_text2);
    return 0;
}
