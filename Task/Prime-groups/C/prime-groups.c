#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool isPrime(int n) {
    int i;

    if (n < 2)
        return false;

    for (i = 2; i * i <= n; i++)
        if (n % i == 0)
            return false;

    return true;
}

void firstPrimeGroup3(char* word) {
    int i, j, k, n = strlen(word);

    for (i = 0; i < n; i++) {
        for (j = i + 1; j < n; j++) {
            for (k = j + 1; k < n; k++) {
                if (isPrime(abs(word[i] - word[j])) &&
                    isPrime(abs(word[i] - word[k])) &&
                    isPrime(abs(word[j] - word[k]))) {
                    printf("%c%c%c\n", word[i], word[j], word[k]);
                    return;
                }
            }
        }
    }
    printf("Not found.\n");
}

void firstPrimeGroup2(char* word) {
    int i, j, n = strlen(word);

    for (i = 0; i < n; i++) {
        for (j = i + 1; j < n; j++) {
            if (isPrime(abs(word[i] - word[j]))) {
                printf("%c%c\n", word[i], word[j]);
                return;
            }
        }
    }
    printf("Not found.\n");
}

int main() {
    int i;
    char* testCases[] = {"riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"};

    for (i = 0; i < sizeof(testCases) / sizeof(testCases[0]); i++)
        firstPrimeGroup3(testCases[i]);

    printf("\n");

    for (i = 0; i < sizeof(testCases) / sizeof(testCases[0]); i++)
        firstPrimeGroup2(testCases[i]);

    return 0;
}
