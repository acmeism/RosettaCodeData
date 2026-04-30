/* aligned for powers of 2 supporting arbitrary types and length using
 * stdio not iostream to reduce binary size
 * change int to float to see SIMD difference with -O0/1 and -O3
 * g++ -march=native -mfpmath=<your SIMD> -ftree-vectorize -fopenmp -fopenmp-simd -O3 -std=<c|gnu>++23
 * for MSVC see https://learn.microsoft.com/en-us/cpp/parallel/openmp/openmp-simd?view=msvc-180
 */
#include <cstdlib>
#include <cstdio>
#include <cstddef>
#include <bit>
#include <array>

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow) __declspec(noalias) inline
#else
#define INLINE __attribute__((always_inline,flatten,nothrow,const)) inline
#endif

#define eol puts("")

template<typename T, size_t N, size_t N_POW2 = std::bit_ceil<size_t>(N)>
struct alignas((N == N_POW2 ? N : 1) * alignof(T)) vec : std::array<T,N>
{
};

template<typename T, size_t N, typename T_A = typeof((T)1 + (T)1), typename T_B = typeof((T)1 * (T)1)>
INLINE std::pair<T_A,T_B> sumprod(const vec<T,N>& src, T_A sum = (T_A)0, T_B prod = (T_B)1)
{
        #pragma omp simd reduction(+:sum) reduction(*:prod)
        for(size_t i = 0; i < src.size(); i++)
        {
                sum  += src[i];
                prod *= src[i];
        }

        return { sum, prod };
}

int main(int argc, char** argv)
{
        vec<int,5> arg = { 1, 2, 3, 4, 5 };
        auto       dst = sumprod(arg);

        printf("sum : %+e", (double)dst.first ); eol;
        printf("prod: %+e", (double)dst.second); eol;

        exit(EXIT_SUCCESS);
}
