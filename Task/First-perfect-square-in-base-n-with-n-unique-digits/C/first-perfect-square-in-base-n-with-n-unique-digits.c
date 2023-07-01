#include <stdio.h>
#include <string.h>

#define BUFF_SIZE 32

void toBaseN(char buffer[], long long num, int base) {
    char *ptr = buffer;
    char *tmp;

    // write it backwards
    while (num >= 1) {
        int rem = num % base;
        num /= base;

        *ptr++ = "0123456789ABCDEF"[rem];
    }
    *ptr-- = 0;

    // now reverse it to be written forwards
    for (tmp = buffer; tmp < ptr; tmp++, ptr--) {
        char c = *tmp;
        *tmp = *ptr;
        *ptr = c;
    }
}

int countUnique(char inBuf[]) {
    char buffer[BUFF_SIZE];
    int count = 0;
    int pos, nxt;

    strcpy_s(buffer, BUFF_SIZE, inBuf);

    for (pos = 0; buffer[pos] != 0; pos++) {
        if (buffer[pos] != 1) {
            count++;
            for (nxt = pos + 1; buffer[nxt] != 0; nxt++) {
                if (buffer[nxt] == buffer[pos]) {
                    buffer[nxt] = 1;
                }
            }
        }
    }

    return count;
}

void find(int base) {
    char nBuf[BUFF_SIZE];
    char sqBuf[BUFF_SIZE];
    long long n, s;

    for (n = 2; /*blank*/; n++) {
        s = n * n;
        toBaseN(sqBuf, s, base);
        if (strlen(sqBuf) >= base && countUnique(sqBuf) == base) {
            toBaseN(nBuf, n, base);
            toBaseN(sqBuf, s, base);
            //printf("Base %d : Num %lld Square %lld\n", base, n, s);
            printf("Base %d : Num %8s Square %16s\n", base, nBuf, sqBuf);
            break;
        }
    }
}

int main() {
    int i;

    for (i = 2; i <= 15; i++) {
        find(i);
    }

    return 0;
}
