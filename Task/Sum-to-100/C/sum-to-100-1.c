/*
 * RossetaCode: Sum to 100, C99, an algorithm using ternary numbers.
 *
 * Find solutions to the "sum to one hundred" puzzle.
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * There are only 13122 (i.e. 2*3**8) different possible expressions,
 * thus we can encode them as positive integer numbers from 0 to 13121.
 */
#define NUMBER_OF_EXPRESSIONS (2 * 3*3*3*3 * 3*3*3*3 )
enum OP { ADD, SUB, JOIN };
typedef int (*cmp)(const void*, const void*);

// Replacing struct Expression and struct CountSum by a tuple like
// struct Pair { int first; int last; } is possible but would make the source
// code less readable.

struct Expression{
    int sum;
    int code;
}expressions[NUMBER_OF_EXPRESSIONS];
int expressionsLength = 0;
int compareExpressionBySum(const struct Expression* a, const struct Expression* b){
    return a->sum - b->sum;
}

struct CountSum{
    int counts;
    int sum;
}countSums[NUMBER_OF_EXPRESSIONS];
int countSumsLength = 0;
int compareCountSumsByCount(const struct CountSum* a, const struct CountSum* b){
    return a->counts - b->counts;
}

int evaluate(int code){
    int value  = 0, number = 0, power  = 1;
    for ( int k = 9; k >= 1; k-- ){
        number = power*k + number;
        switch( code % 3 ){
            case ADD:  value = value + number; number = 0; power = 1; break;
            case SUB:  value = value - number; number = 0; power = 1; break;
            case JOIN: power = power * 10                ; break;
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

void comment(char* string){
    printf("\n\n%s\n\n", string);
}

void init(void){
    for ( int i = 0; i < NUMBER_OF_EXPRESSIONS; i++ ){
        expressions[i].sum = evaluate(i);
        expressions[i].code = i;
    }
    expressionsLength = NUMBER_OF_EXPRESSIONS;
    qsort(expressions,expressionsLength,sizeof(struct Expression),(cmp)compareExpressionBySum);

    int j = 0;
    countSums[0].counts = 1;
    countSums[0].sum = expressions[0].sum;
    for ( int i = 0; i < expressionsLength; i++ ){
        if ( countSums[j].sum != expressions[i].sum ){
            j++;
            countSums[j].counts = 1;
            countSums[j].sum = expressions[i].sum;
        }
        else
            countSums[j].counts++;
    }
    countSumsLength = j + 1;
    qsort(countSums,countSumsLength,sizeof(struct CountSum),(cmp)compareCountSumsByCount);
}

int main(void){

    init();

    comment("Show all solutions that sum to 100");
    const int givenSum = 100;
    struct Expression ex = { givenSum, 0 };
    struct Expression* found;
    if ( found = bsearch(&ex,expressions,expressionsLength,
        sizeof(struct Expression),(cmp)compareExpressionBySum) ){
        while ( found != expressions && (found-1)->sum == givenSum )
            found--;
        while ( found != &expressions[expressionsLength] && found->sum == givenSum )
            print(found++->code);
    }

    comment("Show the positve sum that has the maximum number of solutions");
    int maxSumIndex = countSumsLength - 1;
    while( countSums[maxSumIndex].sum < 0 )
        maxSumIndex--;
    printf("%d has %d solutions\n",
        countSums[maxSumIndex].sum, countSums[maxSumIndex].counts);

    comment("Show the lowest positive number that can't be expressed");
    for ( int value = 0; ; value++ ){
        struct Expression ex = { value, 0 };
        if (!bsearch(&ex,expressions,expressionsLength,
                sizeof(struct Expression),(cmp)compareExpressionBySum)){
            printf("%d\n", value);
            break;
        }
    }

    comment("Show the ten highest numbers that can be expressed");
    for ( int i = expressionsLength-1; i >= expressionsLength-10; i-- )
        print(expressions[i].code);

    return 0;
}
