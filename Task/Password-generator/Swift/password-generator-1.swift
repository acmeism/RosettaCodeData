#include <stdlib.h>
#include <time.h>

void initRandom(const unsigned int seed){
    if(seed==0){
        srand((unsigned) time(NULL));
    }
    else{
        srand(seed);
    }
}

int getRand(const int upperBound){
    return rand() % upperBound;
}
