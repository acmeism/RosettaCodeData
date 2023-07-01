#include <stdio.h>


int main() {
    int arabic[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};

    // There is a bug: "XL\0" is translated into sequence 58 4C 00 00, i.e. it is 4-bytes long...
    // Should be "XL" without \0 etc.
    //
    char roman[13][3] = {"M\0", "CM\0", "D\0", "CD\0", "C\0", "XC\0", "L\0", "XL\0", "X\0", "IX\0", "V\0", "IV\0", "I\0"};
    int N;

    printf("Enter arabic number:\n");
    scanf("%d", &N);
    printf("\nRoman number:\n");

    for (int i = 0; i < 13; i++) {
        while (N >= arabic[i]) {
            printf("%s", roman[i]);
            N -= arabic[i];
        }
    }
    return 0;
}
