#pragma once
/* gcc/clang flags
CFLAGS="
-march=native
-mfpmath=<your SIMD>
-O3
-ftree-vectorize
-fopenmp
-fopenmp-simd
-std=gnu23"

For MSVC see: https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180
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

/* define missing bit ceil function first for power of 2 memory alignment */
#define BITOP_RUP01__(x) (             (x) | (             (x) >>  1))
#define BITOP_RUP02__(x) (BITOP_RUP01__(x) | (BITOP_RUP01__(x) >>  2))
#define BITOP_RUP04__(x) (BITOP_RUP02__(x) | (BITOP_RUP02__(x) >>  4))
#define BITOP_RUP08__(x) (BITOP_RUP04__(x) | (BITOP_RUP04__(x) >>  8))
#define BITOP_RUP16__(x) (BITOP_RUP08__(x) | (BITOP_RUP08__(x) >> 16))

#define bitceil(x) (BITOP_RUP16__(((uint32_t)(x)) - 1) + 1)

/* define different array types */
#define     arr(T,N) typeof(T[N]) /* fixed static array of arbitrary length and type */
#define     vla(T  ) typeof(T[ ]) /* variable length array - VLA */

/* define vector extension power of 2 sized SIMD vector types for non MSVC */
#ifndef _MSC_VER
#ifdef __clang__
#define vec_ext(T,N) typeof(T __attribute__((ext_vector_type(N))))
#else
#define vec_ext(T,N) typeof(T __attribute__((vector_size(bitceil(alignof(T) * N)))))
#endif
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

#define perm3(a,x,y,z  )     (vec_ext(typeof((a)[0]),3))perm(a,x,y,z  )
#define perm4(a,x,y,z,w)     (vec_ext(typeof((a)[0]),4))perm(a,x,y,z,w)

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

/* TODO: https://github.com/HolyBlackCat/macro_sequence_for
 * duplicate array using initializer list and
 * make indexed sequence unrolling for loop based on
 * boilerplates.
 */
#define     dup(a  ) { (a)[0]...(a)[countof(a)-1] };
