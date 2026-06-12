#include <stdio.h>
#include <time.h>

#define EPOCH 1900  // may need to change this for your system

struct tm *day_count_to_ord(int dc) {
    struct tm t = { .tm_year = -EPOCH, .tm_mon = 0, .tm_mday = 1 + dc };
    time_t tt = mktime(&t);
    return gmtime(&tt);
}

int main() {
   int day_counts[3] = {0, 109573, 146096};
   for (int i = 0; i < 3; ++i) {
        int dc = day_counts[i];
        printf("Daycount: %d\n", dc);
        for (int j = 0; j < 6; ++j) {
            struct tm *t = day_count_to_ord(j * 146097 + dc);
            printf("%02d/%02d/%04d\n", t->tm_mday, 1 + t->tm_mon, EPOCH + t->tm_year);
        }
        printf("\n");
   }
   return 0;
}
