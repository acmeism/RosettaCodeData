#include "mat.hpp"

template<size_t N, size_t M = N, enum alg A = alg::std>
using i32 = mat<int,N,M,A>;

template<typename T, size_t N, size_t M = N, enum alg A = alg::std>
constexpr inline bool test(mat<T,N,M,A>& src);

int main()
{
        i32<2,2> A =
        {
                { 1, 2},
                { 3, 4}
        };
        i32<3,3> B =
        {
                {-2, 2,-3},
                {-1, 1, 3},
                { 2, 0,-1}
        };
        i32<4,4> C =
        {
                { 1, 2, 3, 4},
                { 4, 5, 6, 7},
                { 7, 8, 9,10},
                {10,11,12,13}
        };
        i32<5,5> D =
        {
                { 0,  1,  2,  3,  4},
                { 5,  6,  7,  8,  9},
                {10, 11, 12, 13, 14},
                {15, 16, 17, 18, 19},
                {20, 21, 22, 23, 24}
        };

        exit(test(A) && test(B) && test(C) && test(D) ? EXIT_SUCCESS : EXIT_FAILURE);
}

template<typename T, size_t N, size_t M, enum alg A>
constexpr inline bool test(mat<T,N,M,A>& src)
{
        src.println();
        printf("  permanent: %+e\n",               (flt)src.perm());
        printf("determinant: %+e\n",                (flt)src.det());
        printf(" align/size: %zu/%zu\n", alignof(src), sizeof(src));
        puts("");
        return true;
}
