#include <cstdlib>
#include <cstdio>
#include <numeric>
#include <array>
#include <bit>

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wgnu-alignof-expression"
#endif

#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow) __declspec(noalias) inline
#else
#define INLINE __attribute__((always_inline)) __attribute__((flatten)) __attribute__((nothrow)) __attribute__((const)) inline
#endif

template<typename T, size_t N, size_t N_POW2 = std::bit_ceil<size_t>(N)>
struct alignas((N == N_POW2 ? N_POW2 : 1) * alignof(T)) vec : std::array<T,N>
{
};

/* n-dimensional dot/scalar product */
template<typename T, size_t N, typename T_O, size_t N_O>
INLINE T dot(const vec<T,N>& a, const vec<T_O,N_O>& b, T dst = (T)0)
{
        #pragma omp simd reduction(+:dst)
        for(size_t i = 0; i < N; i++) dst += a[i] * b[i];
        return dst;
}

int main()
{
    vec<int,3>        a = { 1,  3, -5    };
    vec<int,3>        b = { 4, -2, -1    };
    vec<int,4>        c = { 1,  2,  3, 4 };
    vec<vec<int,3>,3> d = { a,  b,  a    };
    vec<vec<int,4>,4> e = { c,  c,  c, c };

    printf("dot.product of {1,3,-5} and {4,-2,-1}: %d", dot(a,b)); puts("");
    printf("type                align/size"); puts("");
    printf("vec<int,3>           %4zu/%-4zu",alignof(a), sizeof(a)); puts("");
    printf("vec<int,4>           %4zu/%-4zu",alignof(c), sizeof(c)); puts("");
    printf("vec<vec<int,3>,3>    %4zu/%-4zu",alignof(d), sizeof(d)); puts("");
    printf("vec<vec<int,4>,4>    %4zu/%-4zu",alignof(e), sizeof(e)); puts("");

    exit(EXIT_SUCCESS);
}
