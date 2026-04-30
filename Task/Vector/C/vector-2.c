#pragma once

#include<stdio.h>
#include<stdint.h>
#include<stdlib.h>
#include<stddef.h>
#include<stdbool.h>
#include<stdalign.h>
#include<stdarg.h>
#include<sys/param.h>
#include<math.h>

/* default floating point scalar */
typedef double flt;
#define pi M_PI

#define PARENS ()
#define EXPAND(...) EXPAND4(EXPAND4(EXPAND4(EXPAND4(__VA_ARGS__))))
#define EXPAND4(...) EXPAND3(EXPAND3(EXPAND3(EXPAND3(__VA_ARGS__))))
#define EXPAND3(...) EXPAND2(EXPAND2(EXPAND2(EXPAND2(__VA_ARGS__))))
#define EXPAND2(...) EXPAND1(EXPAND1(EXPAND1(EXPAND1(__VA_ARGS__))))
#define EXPAND1(...) __VA_ARGS__

#undef countof
#define countof(x) sizeof(typeof((x)))/sizeof(typeof((x)[0]))
#define cnt(...) sizeof((typeof(__VA_ARGS__)[]){__VA_ARGS__})/sizeof(__VA_ARGS__)

#define BITOP_RUP01__(x) (             (x) | (             (x) >>  1))
#define BITOP_RUP02__(x) (BITOP_RUP01__(x) | (BITOP_RUP01__(x) >>  2))
#define BITOP_RUP04__(x) (BITOP_RUP02__(x) | (BITOP_RUP02__(x) >>  4))
#define BITOP_RUP08__(x) (BITOP_RUP04__(x) | (BITOP_RUP04__(x) >>  8))
#define BITOP_RUP16__(x) (BITOP_RUP08__(x) | (BITOP_RUP08__(x) >> 16))


#define BIT_CEIL(x) (BITOP_RUP16__(((uint32_t)(x)) - 1) + 1)

#if   defined(__clang__)
#define vec(T,N) typeof(T __attribute__((ext_vector_type(N))))
#elif defined(__GNUC__)
#define vec(T,N) typeof(T __attribute__((vector_size(sizeof(T) * BIT_CEIL(N)))))
#elif defined(_MSC_VER)
#define vec(T,N) typeof(T __declspec((align(sizeof(T)*BIT_CEIL(N))))[BIT_CEIL(N)])
#warn "Your compiler doens't support vector extensions."
#warn "Using aligned arrays without operators instead."
#else
#define vec(T,N) typeof(T __attribute__((aligned(sizeof(T)*BIT_CEIL(N))))[BIT_CEIL(N)])
#warn "Your compiler doens't support vector extensions."
#warn "Using aligned arrays without operators instead."
#endif

#define perm(a,...) { __VA_OPT__(EXPAND(perm_helper(a,__VA_ARGS__))) }
#define perm_helper(a,i,...) (a)[i], __VA_OPT__(perm_again PARENS (a,__VA_ARGS__))
#define perm_again() perm_helper
#define perm2(a,...) ((vec(typeof((a)[0]),2))perm((a),__VA_ARGS__))
#define perm3(a,...) ((vec(typeof((a)[0]),3))perm((a),__VA_ARGS__))
#define perm4(a,...) ((vec(typeof((a)[0]),4))perm((a),__VA_ARGS__))
#define broadcast(n,x) (vec(typeof((a)[0]),n))(x - (vec(typeof((a)[0]),n)){})

#define dot(a,b,t,n,i) \
({ \
t dst = (t)i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(MIN(countof(a),countof(b)),n); j++) \
        dst += (t)((a)[j] * (b)[j]); \
dst; \
})

/* default dot products for length 3/4 */
#define dot3(a,b) (dot((a),(b),flt,3,0))
#define dot4(a,b) (dot((a),(b),flt,4,0))

#define negate(a,mod,val) \
({ \
for(size_t i = 0; i < countof((a)); i++) \
        (a)[i] = i % mod == val ? -(a)[i] : (a)[i]; \
(a); \
})

#define cross2(a,winding) \
({ \
vec(typeof((a)[0]),2) id = broadcast(2,1); \
negate(id,2,0b1^(winding & 0b1)) * perm2(a,1,0); \
})

#define cross3(a,b) \
  perm3(a,1,2,0) * perm3(b,2,0,1) \
- perm3(a,2,0,1) * perm3(b,1,2,0)

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
