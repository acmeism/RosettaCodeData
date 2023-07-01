#include <stdio.h>

/* Check whether a number has an equal amount of rises
 * and falls
 */
int riseEqFall(int num) {
    int rdigit = num % 10;
    int netHeight = 0;
    while (num /= 10) {
        netHeight += ((num % 10) > rdigit) - ((num % 10) < rdigit);
        rdigit = num % 10;
    }
    return netHeight == 0;
}

/* Get the next member of the sequence, in order,
 * starting at 1
 */
int nextNum() {
    static int num = 0;
    do {num++;} while (!riseEqFall(num));
    return num;
}

int main(void) {
    int total, num;

    /* Generate first 200 numbers */
    printf("The first 200 numbers are: \n");
    for (total = 0; total < 200; total++)
        printf("%d ", nextNum());

    /* Generate 10,000,000th number */
    printf("\n\nThe 10,000,000th number is: ");
    for (; total < 10000000; total++) num = nextNum();
    printf("%d\n", num);

    return 0;
}
