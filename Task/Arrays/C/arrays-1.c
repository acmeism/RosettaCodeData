#ifdef _MSC_VER
#define ALIGN(x) __declspec(align(x)) /* only allows numeric constant (unsupported constexpr size_t). Use C++ instead and use alignas */
#define INLINE   __forceinline [[msvc::flatten]] [[msvc::forceinline]]
#define CONST    __declspec(noalias)
#define INTRIN   __declspec(intrin_type) /* misses operators useful with C++ std::array derived struct */
#else
#define ALIGN(x) __attribute__((aligned(x))) /* works with constexpr size_t and bitceil(x) but not with stdc_bit_ceil */
#define INLINE   __attribute__((always_inline,flatten,nothrow)) inline
#define CONST    __attribute__((const))
#define INTRIN   __attribute__((__may_alias__))
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
#define arr(n,t) INTRIN __typeof__(__typeof__(t)[n])
#else
#define arr(n,t) INTRIN ALIGN((n == bitceil(n) ? n : 1) * __alignof__(t)) __typeof__(__typeof__(t)[n])
#endif

/* reg128_t with crumb/nibble accessors in Intel SSE SIMD MSVC style */
#pragma pack(push,1)
typedef union INTRIN ALIGN(16) reg128
{
        struct
        {
                uint8_t c063 : 2;
                uint8_t c062 : 2;
                uint8_t c061 : 2;
                uint8_t c060 : 2;
                uint8_t c059 : 2;
                uint8_t c058 : 2;
                uint8_t c057 : 2;
                uint8_t c056 : 2;
                uint8_t c055 : 2;
                uint8_t c054 : 2;
                uint8_t c053 : 2;
                uint8_t c052 : 2;
                uint8_t c051 : 2;
                uint8_t c050 : 2;
                uint8_t c049 : 2;
                uint8_t c048 : 2;
                uint8_t c047 : 2;
                uint8_t c046 : 2;
                uint8_t c045 : 2;
                uint8_t c044 : 2;
                uint8_t c043 : 2;
                uint8_t c042 : 2;
                uint8_t c041 : 2;
                uint8_t c040 : 2;
                uint8_t c039 : 2;
                uint8_t c038 : 2;
                uint8_t c037 : 2;
                uint8_t c036 : 2;
                uint8_t c035 : 2;
                uint8_t c034 : 2;
                uint8_t c033 : 2;
                uint8_t c032 : 2;
                uint8_t c031 : 2;
                uint8_t c030 : 2;
                uint8_t c029 : 2;
                uint8_t c028 : 2;
                uint8_t c027 : 2;
                uint8_t c026 : 2;
                uint8_t c025 : 2;
                uint8_t c024 : 2;
                uint8_t c023 : 2;
                uint8_t c022 : 2;
                uint8_t c021 : 2;
                uint8_t c020 : 2;
                uint8_t c019 : 2;
                uint8_t c018 : 2;
                uint8_t c017 : 2;
                uint8_t c016 : 2;
                uint8_t c015 : 2;
                uint8_t c014 : 2;
                uint8_t c013 : 2;
                uint8_t c012 : 2;
                uint8_t c011 : 2;
                uint8_t c010 : 2;
                uint8_t c009 : 2;
                uint8_t c008 : 2;
                uint8_t c007 : 2;
                uint8_t c006 : 2;
                uint8_t c005 : 2;
                uint8_t c004 : 2;
                uint8_t c003 : 2;
                uint8_t c002 : 2;
                uint8_t c001 : 2;
                uint8_t c000 : 2;
        };
        struct
        {
                uint8_t n031 : 4;
                uint8_t n030 : 4;
                uint8_t n029 : 4;
                uint8_t n028 : 4;
                uint8_t n027 : 4;
                uint8_t n026 : 4;
                uint8_t n025 : 4;
                uint8_t n024 : 4;
                uint8_t n023 : 4;
                uint8_t n022 : 4;
                uint8_t n021 : 4;
                uint8_t n020 : 4;
                uint8_t n019 : 4;
                uint8_t n018 : 4;
                uint8_t n017 : 4;
                uint8_t n016 : 4;
                uint8_t n015 : 4;
                uint8_t n014 : 4;
                uint8_t n013 : 4;
                uint8_t n012 : 4;
                uint8_t n011 : 4;
                uint8_t n010 : 4;
                uint8_t n009 : 4;
                uint8_t n008 : 4;
                uint8_t n007 : 4;
                uint8_t n006 : 4;
                uint8_t n005 : 4;
                uint8_t n004 : 4;
                uint8_t n003 : 4;
                uint8_t n002 : 4;
                uint8_t n001 : 4;
                uint8_t n000 : 4;
        };
        union
        {
                 uint8_t u8[16];
                  int8_t i8[16];
                    char c8[16];
                    bool b8[16];
        };
        union
        {
                uint16_t u16[8];
                 int16_t i16[8];
        };
        union
        {
                uint32_t u32[4];
                 int32_t i32[4];
                   float f32[4];
        };
        union
        {
                uint64_t u64[2];
                 int64_t i64[2];
                  double f64[2];
        };
} reg128_t;
#pragma pack(pop)
