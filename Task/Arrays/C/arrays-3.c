#pragma once
/* gcc/clang flags
CFLAGS="
-march=native
-mfpmath=<your SIMD>
-O3
-ftree-vectorize
-fopenmp
-fopenmp-simd
-std=gnu2x"

For MSVC see: https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180
*/
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdalign.h>
#include <stdio.h>
#include <stdbit.h>
#include <sys/param.h>
#include <math.h>

typedef double flt;
#define pi M_PI

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow)
#define CONST __declspec(noalias)
#else
#define INLINE __attribute__((always_inline,flatten,nothrow)) inline
#define CONST __attribute__((const))
#endif

#pragma pack(push,1)
#if defined(__clang__)
#define vec(n,t) [[clang::ext_vector_type((size_t)n)]] __typeof__(t)
#elif defined(__GNUC__)
#define vec(n,t) __attribute__((vector_size(stdc_bit_ceil((size_t)n) * __alignof__(t)))) __typeof__(t)
#else
#define vec(n,t) __typeof__(__typeof__(t)[stdc_bit_ceil((size_t)n)])
#endif
#pragma pack(pop)

#if defined(__GNUC__) && !defined(__clang__) && !defined(_MSC_VER)
#define arr(n,t) __attribute__((aligned((n == stdc_bit_ceil((size_t)n) ? n : 1) * __alignof__(t)))) __typeof__(__typeof__(t)[n])
#else
#define arr(n,t) __typeof__(__typeof__(t)[n])
#endif

/* sum using OpenMP */
#define sum(a,n,i) \
({ \
typeof((a)[0]) dst = i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(countof(a),n); j++) \
        dst += (a)[j]; \
dst; \
})

/* dot using OpenMP */
#define dot(a,b,n,i) \
({ \
typeof((a)[0]) dst = i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(MIN(countof(a),countof(b)),n); j++) \
        dst += (a)[j] * (b)[j]; \
dst; \
})

#define dot3(a,b) dot((a),(b),3,0)
#define dot4(a,b) dot((a),(b),4,0)

/* define array verification and element count */
#undef  countof
#define countof(a  ) (sizeof((a))/sizeof((a)[0]))
#define isarray(a  ) __builtin_choose_expr(__builtin_types_compatible_p(typeof((a)[0]) [], typeof((a))), true, false)
/* define variable argument macros */
#define countargs(...) (0 __VA_OPT__(+sizeof((typeof(__VA_ARGS__)[]){__VA_ARGS__})/sizeof(__VA_ARGS__)))
#define emptyargs(...) (true __VA_OPT__(-1))

/* add missing parens and expand for permute */
#define PARENS ()
#define EXPAND(...) EXPAND4(EXPAND4(EXPAND4(EXPAND4(__VA_ARGS__))))
#define EXPAND4(...) EXPAND3(EXPAND3(EXPAND3(EXPAND3(__VA_ARGS__))))
#define EXPAND3(...) EXPAND2(EXPAND2(EXPAND2(EXPAND2(__VA_ARGS__))))
#define EXPAND2(...) EXPAND1(EXPAND1(EXPAND1(EXPAND1(__VA_ARGS__))))
#define EXPAND1(...) __VA_ARGS__

/* add permute */
#define perm(a,...)          { __VA_OPT__(EXPAND(perm_helper(a,__VA_ARGS__))) }
#define perm_helper(a,i,...) (a)[i], __VA_OPT__(perm_again PARENS (a,__VA_ARGS__))
#define perm_again()         perm_helper

#define perm2(a,x,y    )     (vec(2,__typeof__((a)[0])))perm(a,x,y    )
#define perm3(a,x,y,z  )     (vec(3,__typeof__((a)[0])))perm(a,x,y,z  )
#define perm4(a,x,y,z,w)     (vec(4,__typeof__((a)[0])))perm(a,x,y,z,w)
#define broadcast(n,x) \
({ \
vec(n,__typeof__(x)) dst; \
_Pragma("omp simd") \
for(size_t i = 0; i < n; i++) \
        dst[i] = (x); \
dst; \
})

/* cross3 - 3-dimensional vector product for vector extension types only
 * TODO:
 * - support vector/array types without operators
 * - n-dimensional hodge star operator vector product based on
 *   levi-civita, laplace expansion and determinant as a
 *   left contraction grade projection operator. See Clifford, Hodge,
 */
#define cross3(a,b) \
  perm3(a,1,2,0) * perm3(b,2,0,1) \
- perm3(a,2,1,0) * perm3(b,1,2,0)

#define negate(a,mod,val) \
({ \
for(size_t i = 0; i < countof((a)); i++) \
        (a)[i] = i % mod == val ? -(a)[i] : (a)[i]; \
(a); \
})
#define cross2(a,winding) \
({ \
vec(2,typeof((a)[0])) id = broadcast(2,1); \
negate(id,2,0b1^(winding & 0b1)) * perm2(a,1,0); \
})

#define out_vec(msg,a,n) \
({ \
printf("%s [ ", msg); \
for(size_t i = 0; i < n; i++) \
{ \
printf("%+e ", (double)((a)[i])); \
if(i == n-1) printf("]"); \
} \
})
#define out_end() puts("");

/* TODO: https://github.com/HolyBlackCat/macro_sequence_for
 * duplicate array using initializer list and
 * make indexed sequence unrolling for loop based on
 * boilerplates.
 * #define     dup(a  ) { (a)[0]...(a)[countof(a)-1] } */
