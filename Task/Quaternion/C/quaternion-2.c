/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* quaternion type C preprocessor vector extension macros                */
/*                                                                       */
/* -march=native                                                         */
/* -mfpmath=<SIMD type>                                                  */
/* -ftree-vectorize                                                      */
/* -fopenmp-simd                                                         */
/* -O3                                                                   */
/* -std=<c|gnu>23                                                        */
/*                                                                       */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
#define quat(T) typeof(T __attribute__((ext_vector_type(N))))
#elif defined(__GNUC__)
#define quat(T) typeof(T __attribute__((vector_size(sizeof(T)*4))))
#elif defined(_MSC_VER)
#define quat(T) typeof(T __declspec((align(sizeof(T))))[4])
#warn "Your compiler doens't support vector extensions."
#warn "Using aligned arrays without operators instead."
#else
#define quat(T) typeof(T __attribute__((aligned(sizeof(T))))[4])
#warn "Your compiler doens't support vector extensions."
#warn "Using aligned arrays without operators instead."
#endif

#define out_quat(msg,a) printf("%s[ %+e %+e %+e %+e ]", msg, (double)((a)[0]), (double)((a)[1]), (double)((a)[2]), (double)((a)[3]))
#define out_end() puts("")

#define sum(a,t,n,i) \
({ \
t dst = (t)i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(countof((a)),n); j++) \
        dst += (t)((a)[j]); \
dst; \
})

#define dot(a,b,t,n,i) \
({ \
t dst = (t)i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(MIN(countof((a)),countof((b))),n); j++) \
        dst += (t)((a)[j] * (b)[j]); \
dst; \
})

#define sum4(a)   (sum((a),flt,4,0))
#define dot4(a,b) (dot((a),(b),flt,4,0))

#define perm4(a,...) (quat(typeof((a)[0]))){ __VA_OPT__(EXPAND(perm_helper(a,__VA_ARGS__))) }
#define perm_helper(a,i,...) (a)[i], __VA_OPT__(perm_again PARENS (a,__VA_ARGS__))
#define perm_again() perm_helper
#define broadcast(n,x) ((quat(typeof((a)[0]),n))(x - (quat(typeof((a)[0]),n)){}))

#define quat_dup(q) (quat(typeof((q)[0]))){ (q)[0], (q)[1], (q)[2], (q)[3] }
#define quat_norm(q) (sqrt(dot4((q),(q))))
#define quat_norm_sqr(q) (dot4((q),(q)))
#define quat_conj(q) (quat(typeof((q)[0]))){ (q)[0], -(q)[1], -(q)[2], -(q)[3] }
#define quat_add_d(q,d) (quat(typeof((q)[0]))){ (q)[0] + d, (q)[1], (q)[2], (q)[3] }
#define quat_mul_d(q,d) (quat(typeof((q)[0]))){ (q)[0] * d, (q)[1], (q)[2], (q)[3] }

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* quaternion multiplication                                             */
/*                                                                       */
/*      \    black           sign             index                      */
/*        g  \-\-\-       1,-1,-1,-1        0, 1, 2, 3                   */
/*     +\ _r/_\-\-        1, 1, 1,-1        1, 0, 3, 2                   */
/*    +\+\ /e  \-         1,-1, 1, 1        2, 3, 0, 1                   */
/*   +\+\+\  y            1, 1,-1, 1        3, 2, 1, 0                   */
/*    white    \                                                         */
/*                       infinitesimal    skew-symmetric                 */
/*                      rotation matrix  permutation matrix              */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
#define quat_mul(a,b)   (quat(typeof((a)[0]))){                           \
sum4(((quat(typeof((a)[0]))){ 1,-1,-1,-1} * (a) * perm4((b),0,1,2,3))),   \
sum4(((quat(typeof((a)[0]))){ 1, 1, 1,-1} * (a) * perm4((b),1,0,3,2))),   \
sum4(((quat(typeof((a)[0]))){ 1,-1, 1, 1} * (a) * perm4((b),2,3,0,1))),   \
sum4(((quat(typeof((a)[0]))){ 1, 1,-1, 1} * (a) * perm4((b),3,2,1,0)))    \
}
