/*
 * RossetaCode: Sum to 100, C11, MCU friendly.
 *
 * Find solutions to the "sum to one hundred" puzzle.
 *
 * We optimize algorithms for size. Therefore we don't use arrays, but recompute
 * all values again and again. It is a little surprise that the time efficiency
 * is quite acceptable.
 */

#include <stdio.h>

enum OP { ADD, SUB, JOIN };

int evaluate(int code){
    int value  = 0, number = 0, power  = 1;
    for ( int k = 9; k >= 1; k-- ){
        number = power*k + number;
        switch( code % 3 ){
            case ADD:  value = value + number; number = 0; power = 1; break;
            case SUB:  value = value - number; number = 0; power = 1; break;
            case JOIN: power = power * 10                           ; break;
        }
        code /= 3;
    }
    return value;
}

void print(int code){
    static char s[19]; char* p = s;
    int a = 19683, b = 6561;
    for ( int k = 1; k <= 9; k++ ){
        switch((code % a) / b){
            case ADD: if ( k > 1 ) *p++ = '+'; break;
            case SUB:              *p++ = '-'; break;
        }
        a = b;
        b = b / 3;
        *p++ = '0' + k;
    }
    *p = 0;
    printf("%9d = %s\n", evaluate(code), s);
}

int main(void){

    int i,j;
    const int nexpr = 13122;
#define LOOP(K) for (K = 0; K < nexpr; K++)

    puts("\nShow all solutions that sum to 100\n");
    LOOP(i) if ( evaluate(i) == 100 ) print(i);

    puts("\nShow the sum that has the maximum number of solutions\n");
    int best, nbest = (-1);
    LOOP(i){
        int test = evaluate(i);
        if ( test > 0 ){
            int ntest = 0;
            LOOP(j) if ( evaluate(j) == test ) ntest++;
            if ( ntest > nbest ){ best = test; nbest = ntest; }
        }
    }
    printf("%d has %d solutions\n", best,nbest);

    puts("\nShow the lowest positive number that can't be expressed\n");
    for ( i = 0; i <= 123456789; i++ ){
        LOOP(j) if ( i == evaluate(j) ) break;
        if ( i != evaluate(j) ) break;
    }
    printf("%d\n",i);

    puts("\nShow the ten highest numbers that can be expressed\n");
    int limit = 123456789 + 1;
    for ( i = 1; i <= 10; i++ ) {
        int best = 0;
        LOOP(j){
            int test = evaluate(j);
            if ( test < limit && test > best ) best = test;
        }
        LOOP(j) if ( evaluate(j) == best ) print(j);
        limit = best;
    }

    return 0;
}
