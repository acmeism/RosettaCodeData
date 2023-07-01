#include <stdlib.h>
#include <stdio.h>

int main(int argc,char** argv) {

    int arg1 = atoi(argv[1]), arg2 = atoi(argv[2]), sum, diff, product, quotient, remainder ;

    __asm__ ( "addl %%ebx, %%eax;" : "=a" (sum) : "a" (arg1) , "b" (arg2) );
    __asm__ ( "subl %%ebx, %%eax;" : "=a" (diff) : "a" (arg1) , "b" (arg2) );
    __asm__ ( "imull %%ebx, %%eax;" : "=a" (product) : "a" (arg1) , "b" (arg2) );

    __asm__ ( "movl $0x0, %%edx;"
              "movl %2, %%eax;"
              "movl %3, %%ebx;"
               "idivl %%ebx;" : "=a" (quotient), "=d" (remainder) : "g" (arg1), "g" (arg2) );

    printf( "%d + %d = %d\n", arg1, arg2, sum );
    printf( "%d - %d = %d\n", arg1, arg2, diff );
    printf( "%d * %d = %d\n", arg1, arg2, product );
    printf( "%d / %d = %d\n", arg1, arg2, quotient );
    printf( "%d %% %d = %d\n", arg1, arg2, remainder );

    return 0 ;
}
