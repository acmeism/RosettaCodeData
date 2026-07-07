#ifdef _MSC_VER
#define ALIGN(x) __declspec(align(x))
#define INLINE __force_inline __flatten __declspec(nothrow)
#define CONST __declspec(noalias)
#else
#define ALIGN(x) __attribute__((aligned(x)))
#define INLINE __attribute__((always_inline,flatten,nothrow)) inline
#define CONST __attribute__((const))
#endif

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
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

#ifdef _MSC_VER
#define arr(n,t) __typeof__(__typeof__(t)[n])
#else
#define arr(n,t) ALIGN((n == bitceil(n) ? n : 1) * __alignof__(t)) __typeof__(__typeof__(t)[n])
#endif
