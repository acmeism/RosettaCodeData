#include <stdio.h>

int main() {
    int i, clrs[7][3] = {
        {255,   0,   0}, // red
        {255, 128,   0}, // orange
        {255, 255,   0}, // yellow
        {  0, 255,   0}, // green
        {  0,   0, 255}, // blue
        { 75,   0, 130}, // indigo
        {128,   0, 255}, // violet
    };
    const char *s = "RAINBOW";
    for (i = 0; i < 7; ++i) {
        printf("\x1B[38;2;%d;%d;%dm%c", clrs[i][0], clrs[i][1], clrs[i][2], s[i]);
    }
    printf("\n");
    return 0;
}
