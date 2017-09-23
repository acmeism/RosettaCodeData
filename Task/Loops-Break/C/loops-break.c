/*Corrected by Abhishek Ghosh, Mahalaya (19th September) 2017*/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int main() {
	time_t t;
	int a;
    srand((unsigned)time(&t));

    for (;;) {
        a = rand()%20;
        printf("%d\n", a);
        if (a == 0) break;
    }
    return 0;
}
