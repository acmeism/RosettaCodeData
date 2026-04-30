#pragma once
/* -std=<c|gnu>++26
 * -march=native
 * -mfpmath=<your simd>
 * -O3
 * -ftree-vectorize -fopenmp-simd
 * -ffunction-sections -fdata-sections
 * -Wl,--gc-sections -Wl,--print-gc-sections -Wl,-s
 *
 * For MSVC see: https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180
 *
 * Uses cstdio instead of iostream to avoid binary size increase.
 */

#include <cstdlib>
#include <cstddef>
#include <cstdio>
#include <array>
#include <bit>

#ifdef _MSC_VER
#define FORCE_INLINE __forceinline
#define FLATTEN __flatten
#else
#define FORCE_INLINE __attribute__((always_inline))
#define FLATTEN __attribute__((flatten))
#endif

#ifdef __x86_64__
#define REGPARM __attribute__((sseregparm))
#elif __defined__(__i386__)
#define REGPARM __attribute__((regparm(8)))
#else
#define REGPARM
#endif

/*
 * end of line with operating system specific newline character
 * used as a replacement for std::cout << std::endl;
 */
inline constexpr FORCE_INLINE FLATTEN void eol(FILE* stream = stdout) { fputs("\n", stream); }

enum class alg
{
unk = 0,
sca = 1,
vec = 2,
std = 3
};

template< typename T, size_t N, enum alg A = alg::std, size_t N_POW2 = std::bit_ceil<size_t>(N)>
struct alignas(((N == N_POW2) || (A == alg::vec) ? N_POW2 : 1) * alignof(T)) vec : std::array<T,N>
{
        template<enum alg A_DST = alg::std>
        inline FORCE_INLINE FLATTEN operator vec<T,N,A_DST>() { return *reinterpret_cast<vec<T,N,A_DST>*>(this); }

        /* permute vector according to input indices */
        template<typename... I>
        inline FORCE_INLINE FLATTEN constexpr vec<T, sizeof...(I),A> permute(const I... args) const { return vec<T,sizeof...(I),A>{ (*this)[args % N]... }; }

        template<typename T_RHS, size_t N_RHS, enum alg A_RHS = alg::std>
        inline FORCE_INLINE FLATTEN vec<T,N>& operator-=(const vec<T_RHS,N_RHS>& rhs)
        {
                #pragma omp simd
                for(size_t i = 0; i < std::min<size_t>(N,N_RHS); i++)
                        (*this)[i] -= rhs[i];
                return (*this);
        }

        template<typename T_RHS, size_t N_RHS, enum alg A_RHS = alg::std>
        inline FORCE_INLINE FLATTEN vec<T,N>& operator*=(const vec<T_RHS,N_RHS>& rhs)
        {
                #pragma omp simd
                for(size_t i = 0; i < std::min<size_t>(N,N_RHS); i++)
                        (*this)[i] *= rhs[i];
                return (*this);
        }
        inline FORCE_INLINE FLATTEN void print(const char* prefix = "", const char* suffix = "", size_t n = N, FILE* stream = stdout)
        {
                n = std::min(n,N);
                fprintf(stream, "%s[", prefix);
                for(size_t i = 0; i < n; i++)
                        fprintf(stream, "%+e%s", (double)(*this)[i], i != (n - 1) ? " " : "]");
                fprintf(stream, "%s", suffix);
        }
        inline FORCE_INLINE FLATTEN void println(const char* prefix = "", const char* suffix = "", size_t n = N, FILE* stream = stdout)
        {
                print(prefix,suffix,n,stream);
                eol():
        }

};

template<typename T_LHS, size_t N_LHS, enum alg A_LHS = alg::std, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 - (T_RHS)1), size_t N_DST = std::max(N_LHS,N_RHS)>
constexpr inline FORCE_INLINE FLATTEN vec<T_DST,N_DST> operator-(const vec<T_LHS, N_LHS>& lhs, const vec<T_RHS,N_RHS>& rhs)
{
        vec<T_DST, N_DST> dst{lhs};
        dst -= rhs;
        return dst;
}
template<typename T_LHS, size_t N_LHS, enum alg A_LHS = alg::std, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 * (T_RHS)1), size_t N_DST = std::max(N_LHS,N_RHS)>
constexpr inline FORCE_INLINE FLATTEN vec<T_DST,N_DST> operator*(const vec<T_LHS, N_LHS>& lhs, const vec<T_RHS,N_RHS>& rhs)
{
        vec<T_DST, N_DST> dst{lhs};
        dst *= rhs;
        return dst;
}

template<typename T_LHS, size_t N_LHS, enum alg A_LHS, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 * (T_RHS)1 - (T_LHS)1 * (T_RHS)1)>
constexpr inline FORCE_INLINE FLATTEN vec<T_DST, 3> cross3(const vec<T_LHS, N_LHS, A_LHS>& lhs, const vec<T_RHS,N_RHS,A_RHS>& rhs) requires((N_LHS > 2) && (N_RHS > 2))
{
        return vec<T_DST,3>{ lhs.permute(1,2,0) * rhs.permute(2,0,1)
                           - rhs.permute(1,2,0) * lhs.permute(2,0,1) };
}
template<typename T_LHS, size_t N_LHS, enum alg A_LHS, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 * (T_RHS)1 + (T_LHS)1 * (T_RHS)1)>
inline FORCE_INLINE FLATTEN T_DST dot(const vec<T_LHS, N_LHS, A_LHS>& lhs, const vec<T_RHS,N_RHS,A_RHS>& rhs)
{
        T_DST dst;
#pragma omp simd reduction(+:dst)
        for(size_t i = 0; i < std::min(N_LHS, N_RHS); i++)
                dst += lhs[i] * rhs[i];
        return dst;
}

template<typename T_LHS, size_t N_LHS, enum alg A_LHS, typename T_B, size_t N_B, enum alg A_B = alg::std, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 * (T_RHS)1 - (T_B)1 * (T_RHS)1)>
constexpr inline FORCE_INLINE FLATTEN vec<T_DST, 3> triplevec3(const vec<T_LHS, N_LHS, A_LHS>& lhs, const vec<T_B,N_B,A_B>& b, const vec<T_RHS,N_RHS,A_RHS>& rhs) requires((N_LHS > 2) && (N_RHS > 2) && (N_B > 2))
{
        return cross3(lhs,cross3(b,rhs));
}

template<typename T_LHS, size_t N_LHS, enum alg A_LHS, typename T_B, size_t N_B, enum alg A_B = alg::std, typename T_RHS, size_t N_RHS, enum alg A_RHS = A_LHS, typename T_DST = decltype((T_LHS)1 * (T_B)1 - (T_RHS)1 * (T_LHS)1)>
constexpr inline FORCE_INLINE FLATTEN T_DST triplesca3(const vec<T_LHS, N_LHS, A_LHS>& lhs, const vec<T_B,N_B,A_B>& b, const vec<T_RHS,N_RHS,A_RHS>& rhs) requires((N_LHS > 2) && (N_RHS > 2) && (N_B > 2))
{
        return dot(lhs,cross3(b,rhs));
}
