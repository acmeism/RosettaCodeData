#include <iostream>
#include <array>

template<typename T, size_t N>
using vec = std::array<T,N>;

template<typename T, size_t N, size_t M = N>
using mat = std::array<vec<T,N>,M>;

/* generalized Kronecker delta - antisymmetrizer */
template<scalar T, size_t N>
constexpr int8_t gkd(const std::array<T,N>& v, const std::array<T,N>& orig)
{
        bool trans = 0;
        for(size_t i = 0; i < orig.size(); i++)
        {
                size_t cnt = 0;
                for(size_t j = 0; j < std::min<size_t>(i + 1,v.size()); j++)
                        if(orig[i] == v[j]) ++cnt;
                for(size_t j = i + 1; j < v.size(); j++)
                {
                        if(orig[i] == v[j]) ++cnt;
                        if(   v[i] >  v[j]) trans += -1;
                }
                if(cnt != 1) return 0;
        }
        return trans ? -1 : 1;
}

/* generalized permanent delta - complete symmetrizer *
 * equivalent to abs(gKd(v,orig)) or is_index_sequence */
template<scalar T, size_t N>
inline constexpr int8_t gpd(const std::array<T,N>& v, const std::array<T,N>& orig)
{
        for(auto& i : orig)
                if(std::count(v.begin(), v.end(), i) != 1) return 0;
        return 1;
}

template<typename T, size_t N>
constexpr auto minor(const mat<T,N>& a, size_t x, size_t y)->mat<T,N-1> requires(N > 0)
{
    mat<T,N-1> result;
    for (size_t i = 0; i < N-1; i++)
        for (size_t j = 0; j < N-1; j++)
                result[i][j] = (i <  x && j <  y) ? a[i    ][j    ] :
                               (i >= x && j <  y) ? a[i + 1][j    ] :
                               (i <  x && j >= y) ? a[i    ][j + 1] :
                                                    a[i + 1][j + 1] ;
    return result;
}

template<typename T, size_t N, bool SIGN = true>
constexpr double det(const mat<T,1>& a) requires(N == 1)
{
        return double(a[0][0]);
}

template<typename T, size_t N, bool SIGN = true>
constexpr double det(const mat<T,N>& a) requires(N > 1)
{
    double sum = 0;
    bool sign = true;

    for (size_t i = 0; i < a.size(); i++)
        sum += double((sign += -1) && SIGN ? -1 : 1) * double(a[0][i]) * det<T,N-1,SIGN>(minor(a,0,i));
    return sum;
}

template<typename T, size_t N>
inline constexpr double perm(const mat<T,N>& a) requires(N > 0) { return det<T,N,false>(a); }

template <typename T, size_t N, size_t M = N>
std::ostream &operator<<(std::ostream &os, const mat<T,N,M> &v)
{
    for(size_t i = 0; i < N; i++)
    {
        os << '[';
        for(size_t j = 0; j < M; j++)
        {
                printf("%+e", (double)v[i][j]);
                if( j < (M - 1)) os << ", ";
        }
        os << ']' << std::endl;
    }
    return os;
}

template<typename T, size_t N>
void test(const mat<T,N>& m)
{
        std::cout << m;
        printf("Permanent: %+f Determinant: %+f\n", perm(m), det(m));
}

int main()
{
    mat<int,2> A =
    {
            vec<int,2>{1,2},
            vec<int,2>{3,4}
    };
    mat<int,3> B =
    {
            vec<int,3>{-2, 2, -3},
            vec<int,3>{-1, 1,  3},
            vec<int,3>{ 2, 0, -1}
    };
    mat<int,4> C =
    {
            vec<int,4>{ 1, 2, 3, 4},
            vec<int,4>{ 4, 5, 6, 7},
            vec<int,4>{ 7, 8, 9,10},
            vec<int,4>{10,11,12,13}
    };
    mat<int,5> D =
    {
            vec<int,5>{ 0,  1,  2,  3,  4},
            vec<int,5>{ 5,  6,  7,  8,  9},
            vec<int,5>{10, 11, 12, 13, 14},
            vec<int,5>{15, 16, 17, 18, 19},
            vec<int,5>{20, 21, 22, 23, 24}
    };
    test(A);
    std::cout << std::endl;
    test(B);
    std::cout << std::endl;
    test(C);
    std::cout << std::endl;
    test(D);
    return 0;
}
