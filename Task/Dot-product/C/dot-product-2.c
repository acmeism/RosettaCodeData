/*************************************************************************************************
 * C preprocessor macro vector/array types                                                       *
 *                                                                                               *
 * vec(T,N) - padded to bitceil(N) with operators/accessors                                      *
 *                                                                                               *
 * arr(T,N) - alignas((N == bitceil(N) ? N : 1) * alignof(T))                                    *
 *                                                                                               *
 * vla(T)   - flexible/variable length default alignment                                         *
 *                                                                                               *
 * CFLAGS="                                                                                      *
 * -march=native                                                                                 *
 * -O3                                                                                           *
 * -std=<c|gnu>23                                                                                *
 * -mfpmath=<your SIMD implementation>                                                           *
 * -ftree-vectorize                                                                              *
 * -fopenmp                                                                                      *
 * -fopenmp-simd"                                                                                *
 *                                                                                               *
 * For MSVC see: https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180 *
 *************************************************************************************************/
#pragma once
#include <stdio.h>
#include <stdlib.h>
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

#define BITOP_RUP01__(x) (             (x) | (             (x) >>  1))
#define BITOP_RUP02__(x) (BITOP_RUP01__(x) | (BITOP_RUP01__(x) >>  2))
#define BITOP_RUP04__(x) (BITOP_RUP02__(x) | (BITOP_RUP02__(x) >>  4))
#define BITOP_RUP08__(x) (BITOP_RUP04__(x) | (BITOP_RUP04__(x) >>  8))
#define BITOP_RUP16__(x) (BITOP_RUP08__(x) | (BITOP_RUP08__(x) >> 16))

#define bitceil(x) (const uint32_t)(BITOP_RUP16__(((uint32_t)(x)) - 1) + 1)

/* arr(T,N) aligned array type */
#define arr(t,n) alignas((n == bitceil(n) ? n : 1) * alignof(t)) typeof(t[n])
#define countof(a) sizeof((a))/sizeof(typeof((a)[0]))
#define isarray(a) __builtin_choose_expr(__builtin_types_compatible_p(typeof((a)[0]) [], typeof((a))), true, false)

#define rc_arr(src,n) (*(arr(typeof((src)[0]),n)*)&src)
#define rc_vec(src,n) (*(vec(typeof((src)[0]),n)*)&src)

/* vec(T,N) for LLVM SIMD Vector Extension */
#if defined(__clang__)
#define vec(T,N) typeof(T __attribute__((ext_vector_type(N))))
#define vec_countof(a) __builtin_vectorelements(rc_vec(a,countof(a)))
#define isvector(a) !isarray(a) && \
__builtin_choose_expr( \
bitceil(vec_countof(a)) == countof(a),true,false)

/* vec(T,N) for GCC SIMD Vector Extension */
#elif defined(__GNUC__)
#define vec(T,N) typeof(T __attribute__((vector_size(bitceil(N) * alignof(T)))))
#define vec_countof(a) countof(a)
#define isvector(a) !isarray(a) && \
_Generic(__builtin_convertvector(rc_vec(a,vec_countof(a)), \
         vec(float,bitceil(vec_countof(a)))), \
         vec(float,bitceil(vec_countof(a))): true, \
         default: false)
/* vec_ext(T,N) for other compilers */
#else
#define vec(T,N) arr(T,N)
#warn "Your compiler doens't support vector extensions."
#warn "Using aligned arrays without operators instead."
#endif
