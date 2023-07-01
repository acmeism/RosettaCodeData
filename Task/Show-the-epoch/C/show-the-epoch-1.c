#include <time.h>
#include <stdio.h>

int main() {
    time_t t = 0;
    printf("%s", asctime(gmtime(&t)));
    return 0;
}
