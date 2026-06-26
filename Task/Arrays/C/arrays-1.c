#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow)
#define CONST __declspec(noalias)
#else
#define INLINE __attribute__((always_inline,flatten,nothrow)) inline
#define CONST __attribute__((const))
#endif

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#if defined(__GNUC__) && !defined(__clang__) && !defined(_MSC_VER)
#define arr(n,t) __attribute__((aligned((n == stdc_bit_ceil((size_t)n) ? n : 1) * __alignof__(t)))) __typeof__(__typeof__(t)[n])
#else
#define arr(n,t) __typeof__(__typeof__(t)[n])
#endif
