#include <stdio.h>
#include <time.h>

int main() {
    int i, j, ms = 250;
    const char *a = "|/-\\";
    time_t start, now;
    struct timespec delay;
    delay.tv_sec = 0;
    delay.tv_nsec = ms * 1000000L;
    printf("\033[?25l");  // hide the cursor
    time(&start);
    while(1) {
        for (i = 0; i < 4; i++) {
            printf("\033[2J");          // clear terminal
            printf("\033[0;0H");        // place cursor at top left corner
            for (j = 0; j < 80; j++) {  // 80 character terminal width, say
                printf("%c", a[i]);
            }
            fflush(stdout);
            nanosleep(&delay, NULL);
        }
        // stop after 20 seconds, say
        time(&now);
        if (difftime(now, start) >= 20) break;
    }
    printf("\033[?25h"); // restore the cursor
    return 0;
}
