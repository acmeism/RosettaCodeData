/* aligned for powers of 2 supporting arbitrary types and length
 * change int to float to see SIMD difference with -O0/1 and -O3
 * gcc -march=native -mfpmath=<your SIMD> -ftree-vectorize -fopenmp -fopenmp-simd -O3 -std=<c|gnu>2y
 * for MSVC see https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180
 */
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdalign.h>
#include <sys/param.h>

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow) __declspec(noalias) inline
#else
#define INLINE __attribute__((always_inline,flatten,nothrow,const)) inline
#endif

#define eol          puts("");

/* * * * * * * * * * * * * *
 * bitceil for pow 2 align *
 * * * * * * * * * * * * * */
#define BITOP_RUP01__(x) (             (x) | (             (x) >>  1))
#define BITOP_RUP02__(x) (BITOP_RUP01__(x) | (BITOP_RUP01__(x) >>  2))
#define BITOP_RUP04__(x) (BITOP_RUP02__(x) | (BITOP_RUP02__(x) >>  4))
#define BITOP_RUP08__(x) (BITOP_RUP04__(x) | (BITOP_RUP04__(x) >>  8))
#define BITOP_RUP16__(x) (BITOP_RUP08__(x) | (BITOP_RUP08__(x) >> 16))

#define bitceil(x) (const uint32_t)(BITOP_RUP16__(((uint32_t)(x)) - 1) + 1)

#undef  countof
#define countof(a  ) (sizeof((a))/sizeof((a)[0]))
#define isarray(a  ) __builtin_choose_expr(__builtin_types_compatible_p(typeof((a)[0]) [], typeof((a))), true, false)

/* pair of arbitrary types (aligned if sum equals power of two) */
#pragma pack(push,1)
#define pair(t1,t2)                                                         \
alignas((alignof(t1) + alignof(t2) == bitceil(alignof(t1) + alignof(t2))) ? \
         alignof(t1) + alignof(t2) : MAX(alignof(t1),alignof(t2)))          \
         typeof(struct pair_##t1_##t2_s { t1 first; t2 second; })
#pragma pack(pop)

/* fixed static array of arbitrary length and type (aligned if N is power of 2) */
#pragma pack(push,1)
#define arr(T,N) alignas((N == bitceil(N) ? N : 1) * alignof(T)) typeof(T[N])
#pragma pack(pop)

/* variable length array - VLA */
#pragma pack(push,1)
#define vla(T  ) typeof(T[ ])
#pragma pack(pop)

#define sumprod(arg)                                                                       \
({                                                                                         \
        isarray(arg);                                                                      \
        typeof((arg)[0] + (arg)[0]) sum  = 0;                                              \
        typeof((arg)[0] * (arg)[0]) prod = 1;                                              \
                                                                                           \
        _Pragma("omp simd reduction(+:sum) reduction(*:prod)")                             \
        for(size_t i = 0; i < countof(arg); i++)                                           \
        {                                                                                  \
                sum  += (arg)[i];                                                          \
                prod *= (arg)[i];                                                          \
        }                                                                                  \
                                                                                           \
        pair(typeof((arg)[0] + (arg)[0]),typeof((arg)[0] * (arg)[0])) dst = { sum, prod }; \
        (dst);                                                                             \
})

int main(int argc, char** argv)
{
        vla(int)      arg = {1,2,3,4,5};
        pair(int,int) dst = sumprod(arg);

        printf("sum : %+e", (double)dst.first ); eol;
        printf("prod: %+e", (double)dst.second); eol;

        exit(EXIT_SUCCESS);
}
