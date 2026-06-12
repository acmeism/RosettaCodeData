#include <stdio.h>

int data[1000], dataLength, frequ[6];
int frequBounds[7] = { 0, 4, 8, 12, 16, 25, 101 };

int main() {
    FILE *fp;
    int i, j, k;
    float decreasePercent;

    fp = fopen("data.txt", "r");
    while (!feof(fp))
        fscanf(fp, "%d", &data[dataLength++]);
    close(fp);

    for (i = 0; i < dataLength; i++) {
        for (j = i; j+1 < dataLength && data[j+1] <= data[j]; j++) ;
        if (data[i] > data[j]) {
            decreasePercent = 100.0 * (data[i] - data[j]) / data[i];
            for (k = 0; frequBounds[k+1] <= decreasePercent; k++) ;
            frequ[k]++;
        }
        i = j;
    }

    printf("    Bin       Count\n");
    printf("===================\n");
    printf("( 0%% ,  4%%) %5d\n", frequ[0]);
    for (i = 1; i < 5; i++)
        printf("[%2d%% , %2d%%) %5d\n", frequBounds[i], frequBounds[i+1], frequ[i]);
    printf("[25%% , inf) %5d\n", frequ[5]);

    return 0;
}
