#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <getopt.h>

#define NUMLETTERS 26
#define BUFSIZE 4096

char *get_input(void);

int main(int argc, char *argv[])
{
    char const usage[] = "Usage: vinigere [-d] key";
    char sign = 1;
    char const plainmsg[] = "Plain text:  ";
    char const cryptmsg[] = "Cipher text: ";
    bool encrypt = true;
    int opt;

    while ((opt = getopt(argc, argv, "d")) != -1) {
        switch (opt) {
        case 'd':
            sign = -1;
            encrypt = false;
            break;
        default:
            fprintf(stderr, "Unrecogized command line argument:'-%i'\n", opt);
            fprintf(stderr, "\n%s\n", usage);
            return 1;
        }
    }

    if (argc - optind != 1) {
        fprintf(stderr, "%s requires one argument and one only\n", argv[0]);
        fprintf(stderr, "\n%s\n", usage);
        return 1;
    }


    // Convert argument into array of shifts
    char const *const restrict key = argv[optind];
    size_t const keylen = strlen(key);
    char shifts[keylen];

    char const *restrict plaintext = NULL;
    for (size_t i = 0; i < keylen; i++) {
        if (!(isalpha(key[i]))) {
            fprintf(stderr, "Invalid key\n");
            return 2;
        }
        char const charcase = (isupper(key[i])) ? 'A' : 'a';
        // If decrypting, shifts will be negative.
        // This line would turn "bacon" into {1, 0, 2, 14, 13}
        shifts[i] = (key[i] - charcase) * sign;
    }

    do {
        fflush(stdout);
        // Print "Plain text: " if encrypting and "Cipher text:  " if
        // decrypting
        printf("%s", (encrypt) ? plainmsg : cryptmsg);
        plaintext = get_input();
        if (plaintext == NULL) {
            fprintf(stderr, "Error getting input\n");
            return 4;
        }
    } while (strcmp(plaintext, "") == 0); // Reprompt if entry is empty

    size_t const plainlen = strlen(plaintext);

    char* const restrict ciphertext = calloc(plainlen + 1, sizeof *ciphertext);
    if (ciphertext == NULL) {
        fprintf(stderr, "Memory error\n");
        return 5;
    }

    for (size_t i = 0, j = 0; i < plainlen; i++) {
        // Skip non-alphabetical characters
        if (!(isalpha(plaintext[i]))) {
            ciphertext[i] = plaintext[i];
            continue;
        }
        // Check case
        char const charcase = (isupper(plaintext[i])) ? 'A' : 'a';
        // Wrapping conversion algorithm
        ciphertext[i] = ((plaintext[i] + shifts[j] - charcase + NUMLETTERS) % NUMLETTERS) + charcase;
        j = (j+1) % keylen;
    }
    ciphertext[plainlen] = '\0';
    printf("%s%s\n", (encrypt) ? cryptmsg : plainmsg, ciphertext);

    free(ciphertext);
    // Silence warnings about const not being maintained in cast to void*
    free((char*) plaintext);
    return 0;
}
char *get_input(void) {

    char *const restrict buf = malloc(BUFSIZE * sizeof (char));
    if (buf == NULL) {
        return NULL;
    }

    fgets(buf, BUFSIZE, stdin);

    // Get rid of newline
    size_t const len = strlen(buf);
    if (buf[len - 1] == '\n') buf[len - 1] = '\0';

    return buf;
}
