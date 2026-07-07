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
#include <math.h>

typedef double flt;
#define pi M_PI

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#ifdef _MSC_VER
#define ALIGN(x) __declspec(align(x))
#define INLINE __force_inline __flatten __declspec(nothrow)
#define CONST __declspec(noalias)
#else
#define ALIGN(x) __attribute__((aligned(x)))
#define INLINE __attribute__((always_inline,flatten,nothrow)) inline
#define CONST __attribute__((const))
#endif

/* use preprocessor bitceil instead of stdc_bit_ceil because of numeric constexpr */
#define sh0(v)     (__typeof__((v)))((v)-1)
#define sh1(v)     (__typeof__((v)))(sh0(v) | sh0(v) >> (1 << 0))
#define sh2(v)     (__typeof__((v)))(sh1(v) | sh1(v) >> (1 << 1))
#define sh3(v)     (__typeof__((v)))(sh2(v) | sh2(v) >> (1 << 2))
#define sh4(v)     (__typeof__((v)))(sh3(v) | sh3(v) >> (1 << 3))
#define sh5(v)     (__typeof__((v)))(sh4(v) | sh4(v) >> (1 << 4))
#define sh6(v)     (__typeof__((v)))(sh5(v) | sh5(v) >> (1 << 5))
#define bitceil(v) (__typeof__((v)))(sh6((uint64_t)v) + 1)

/* n-dim array of arbitrary type (aligned to power of 2 if n == bitceil(n)) */
#ifdef _MSC_VER
#define arr(n,t) __typeof__(__typeof__(t)[n])
#else
#define arr(n,t) ALIGN((n == bitceil(n) ? n : 1) * __alignof__(t)) __typeof__(__typeof__(t)[n])
#endif

#pragma pack(push,1)
/* vector type vec(n,t) based on compiler extensions */
#if defined(__GNUC__) && !defined(__clang__) && !defined(_MSC_VER)
#define vec(n,t) __typeof__(__attribute__((vector_size(bitceil((uint32_t)n) * __alignof__(__typeof__(t))))) __typeof__(t))
#else
#if defined(__clang__)
#define vec(n,t) __typeof__(__attribute__((ext_vector_type(bitceil(n)))) __typeof__(t))
#else
#define vec(n,t) arr(n,t)
#endif
#endif
#pragma pack(pop)

/* define array verification and element count */
#undef  countof
#define countof(a  ) (sizeof((a))/sizeof((a)[0]))
#define isarray(a  ) __builtin_choose_expr(__builtin_types_compatible_p(typeof((a)[0]) [], typeof((a))), true, false)
/* define variable argument macros */
#define countargs(...) (0 __VA_OPT__(+sizeof((typeof(__VA_ARGS__)[]){__VA_ARGS__})/sizeof(__VA_ARGS__)))
#define emptyargs(...) (true __VA_OPT__(-1))

/* terminal output function */
#define eout() puts("")
#define sout(_pre,_s,_post) printf("%s%+e%s",(_pre),(double)(_s),(_post))
#define vout(_pre, _v, _post, _n, _align) \
({ \
printf("%s[",_pre); \
_Pragma("omp simd") \
for(size_t i = 0; i < _n; i++) \
        printf("%+e%s", (double)(_v)[i], i == (_n - 1) ? "]" : " "); \
printf("%s",_post); \
if((bool)_align) \
        printf(": %4zu/%4zu", __alignof__((_v)), sizeof((_v))); \
})

/* vector duplicate */
#define vdup(_n,_dst,_src) \
({ \
_Pragma("omp simd") \
for(size_t i = 0; i < _n; i++) \
        (_dst)[i] = (__typeof__((_dst)[0]))(_src)[i]; \
})

/* vector set */
#define vset(_v,...) \
({ \
        static_assert(!emptyargs(__VA_ARGS__)); \
        constexpr size_t _n = countargs(__VA_ARGS__); \
        __typeof__(__VA_ARGS__)* args = (__typeof__(__VA_ARGS__)[]){__VA_ARGS__}; \
        vdup(_n,_v,args); \
})

/* vector permute */
#define vperm(_v,...) \
({ \
        static_assert(!emptyargs(__VA_ARGS__)); \
        constexpr size_t _n = countargs(__VA_ARGS__); \
        __typeof__(__VA_ARGS__)* args = (__typeof__(__VA_ARGS__)[]){__VA_ARGS__}; \
        vec(_n,__typeof__((_v)[0])) _dst; \
        _Pragma("omp simd") \
        for(size_t i = 0; i < _n; i++) \
                (_dst)[i] = (_v)[(size_t)(args)[i]]; \
        (_dst); \
})

/* permute v and pad fill bit ceiled rest with w */
#define vwfillperm(_w,_v,...) \
({ \
        static_assert(!emptyargs(__VA_ARGS__)); \
        constexpr size_t _n = countargs(__VA_ARGS__); \
        __typeof__(__VA_ARGS__)* args = (__typeof__(__VA_ARGS__)[]){__VA_ARGS__}; \
        vec(_n + 1,__typeof__((_v)[0])) _dst; \
        _Pragma("omp simd") \
        for(size_t i = 0; i < _n; i++) \
                (_dst)[i] = (_v)[(size_t)(args)[i]]; \
        _Pragma("omp simd") \
        for(size_t i = _n; i < bitceil(_n+1); i++) \
                (_dst)[i] = (__typeof__((_dst)[0]))_w; \
        (_dst); \
})

/* vector accumulate sum */
#define  vsum(_n,_src,_t,_i) \
({ \
        _t _dst = (_t)_i; \
        _Pragma("omp simd reduction(+:_dst)") \
        for(size_t i = 0; i < _n; i++) \
                _dst += (_t)(_src)[i]; \
        _dst; \
})

/* vector reduction */
#define vred(_n,_a,_b,_op,_t,_i) \
({ \
        _t _dst = (_t)_i; \
        _Pragma("omp simd reduction(+:_dst)") \
        for(size_t i = 0; i < _n; i++) \
                _dst += (_t)(_a)[i] _op (_b)[i]; \
        _dst; \
})

/* vector dot product */
#define vdot(_n,_a,_b,_t,_i) vred(_n,_a,_b,*,_t,_i)
#define vdot3(_a,_b) vdot(3,_a,_b,__typeof__((_a)[0] * (_b)[0]),0)
#define vdot4(_a,_b) vdot(4,_a,_b,__typeof__((_a)[0] * (_b)[0]),0)

/* vector cross3 product - should evaluate to vfnmadd132pd on intel with fma */
#define vcross3(_a,_b) (vwfillperm(0,_a,1,2,0) * vwfillperm(0,_b,2,0,1)) - (vwfillperm(0,_a,2,0,1) * vwfillperm(0,_b,1,2,0))


#define broadcast(n,x) \
({ \
vec(n,__typeof__(x)) dst; \
_Pragma("omp simd") \
for(size_t i = 0; i < n; i++) \
        dst[i] = (x); \
dst; \
})

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
