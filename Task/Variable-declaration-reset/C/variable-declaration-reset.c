#include <stdio.h>

int main() {
    int i, gprev = 0;
    int s[7] = {1, 2, 2, 3, 4, 4, 5};

    /* There is no output as 'prev' is created anew each time
       around the loop and set explicitly to zero. */
    for (i = 0; i < 7; ++i) {
//  for (int i = 0, prev; i < 7; ++i) { // as below, see note
        int curr = s[i];
        int prev = 0;
//      int prev; // produces same output as second loop
        if (i > 0 && curr == prev) printf("%d\n", i);
        prev = curr;
    }

    /*  Now 'gprev' is used and reassigned
        each time around the loop producing the desired output. */
    for (i = 0; i < 7; ++i) {
        int curr = s[i];
        if (i > 0 && curr == gprev) printf("%d\n", i);
        gprev = curr;
    }

    return 0;
}
