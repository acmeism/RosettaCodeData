#define _CRT_SECURE_NO_WARNINGS    // turn off panic warnings
#define _CRT_NONSTDC_NO_WARNINGS   // enable old-gold POSIX names in MSVS

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 10

// Fixed size global arrays

static const int scGlobal[N];
const int cGlobal[N];
static int sGlobal[N];
int Global[N];

#define TEST(A, N)                                                             \
 do {                                                                          \
    puts("");                                                                  \
    printf("directly called:          sizeof(%8s) = %2d,  length = %2d,  %s\n",\
        #A,                                                                    \
        sizeof(A),                                                             \
        sizeof(A) / sizeof(int),                                               \
        sizeof(A) / sizeof(int) == N ? "pass" : "fail");                       \
                                                                               \
    test1(#A, A, N);                                                           \
    test2(#A, A, N);                                                           \
    test3(#A, A, N);                                                           \
} while (0);

void test1(char* name, int* A, int n)
{
    printf("as parameter int* A:      sizeof(%8s) = %2d,  length = %2d,  %s\n",
        name,
        sizeof(A),
        sizeof(A) / sizeof(int),
        sizeof(A) / sizeof(int) == n ? "pass" : "fail");
}

void test2(char* name, int A[], int n)
{
    printf("as parameter int A[]:     sizeof(%8s) = %2d,  length = %2d,  %s\n",
        name,
        sizeof(A),
        sizeof(A) / sizeof(int),
        sizeof(A) / sizeof(int) == n ? "pass" : "fail");
}

void test3(char* name, int A[10], int n)
{
    printf("as parameter int A[10]:   sizeof(%8s) = %2d,  length = %2d,  %s\n",
        name,
        sizeof(A),
        sizeof(A) / sizeof(int),
        sizeof(A) / sizeof(int) == n ? "pass" : "fail");
}


int main(int argc, char argv[])
{
    // Fixed size local arrays (defined inside curly braces block)

    static const int scLocal[N];
    const int cLocal[N];
    static int sLocal[N];
    auto int aLocal[N];
    int Local[N];

    // Fixed size VLA arrays can/should be used instead dynamically alocated
    // blocks. VLA has not implemented in Microsoft Visual Studio C.

    srand(time(NULL));
    int n = N + rand() % 2; // the value of n is unknow in the compile time?

#ifndef _MSC_VER
    int vlaLocal[n];
#endif

    // Memory blocks as ersatz arrays. This is not all possible ways to allocate
    // memory. There are other functions, like LocalAlloc, HeapAlloc, sbreak...
    // Don't use alloca in any serious program - this function is really bad
    // choice - it can corrupt the program stack and generate a stack overflow.

    int* mBlock = (int*)malloc(n * sizeof(int));
    int* cBlock = (int*)calloc(n, sizeof(int));
    int* aBlock = (int*)_alloca(n * sizeof(int)); // don't use in your programs!

    TEST(scGlobal, N);
    TEST(cGlobal, N);
    TEST(sGlobal, N);
    TEST(Global, N);

    TEST(scLocal, N);
    TEST(cLocal, N);
    TEST(sLocal, N);
    TEST(aLocal, N);
    TEST(Local, N);

#ifndef _MSC_VER
    TEST(vlaLocal, n);
#endif

    TEST(mBlock, N);
    TEST(cBlock, N);
    TEST(aBlock, N);

    free(mBlock, N);
    free(cBlock, N);
    // free must not be called on aBlock

    return 0;
}
