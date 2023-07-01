#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void process(int lineNum, char buffer[]) {
    char days[7][64];
    int i = 0, d = 0, j = 0;

    while (buffer[i] != 0) {
        if (buffer[i] == ' ') {
            days[d][j] = '\0';
            ++d;
            j = 0;
        } else if (buffer[i] == '\n' || buffer[i] == '\r') {
            days[d][j] = '\0';
            ++d;
            break;
        } else {
            days[d][j] = buffer[i];
            ++j;
        }

        if (d >= 7) {
            printf("There aren't 7 days in line %d\n", lineNum);
            return;
        }
        ++i;
    }
    if (buffer[i] == '\0') {
        days[d][j] = '\0';
        ++d;
    }

    if (d < 7) {
        printf("There aren't 7 days in line %d\n", lineNum);
        return;
    } else {
        int len = 0;

        for (len = 1; len < 64; ++len) {
            int d1;
            for (d1 = 0; d1 < 7; ++d1) {
                int d2;
                for (d2 = d1 + 1; d2 < 7; ++d2) {
                    int unique = 0;
                    for (i = 0; i < len; ++i) {
                        if (days[d1][i] != days[d2][i]) {
                            unique = 1;
                            break;
                        }
                    }
                    if (!unique) {
                        goto next_length;
                    }
                }
            }

            // uniqueness found for this length
            printf("%2d ", len);
            for (i = 0; i < 7; ++i) {
                printf(" %s", days[i]);
            }
            printf("\n");
            return;

            // a duplication was found at the current length
        next_length: {}
        }
    }

    printf("Failed to find uniqueness within the bounds.");
}

int main() {
    char buffer[1024];
    int lineNum = 1, len;
    FILE *fp;

    fp = fopen("days_of_week.txt", "r");
    while (1) {
        memset(buffer, 0, sizeof(buffer));

        fgets(buffer, sizeof(buffer), fp);
        len = strlen(buffer);

        if (len == 0 || buffer[len - 1] == '\0') {
            break;
        }

        process(lineNum++, buffer);
    }
    fclose(fp);

    return 0;
}
