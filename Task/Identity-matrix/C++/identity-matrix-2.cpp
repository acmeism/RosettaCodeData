#include <boost/numeric/ublas/matrix.hpp>

int main()
{
    using namespace boost::numeric::ublas;

    int nSize;
    std::cout << "Enter matrix size (N): ";
    std::cin >> nSize;

    identity_matrix<int> oMatrix( nSize );

    for ( unsigned int y = 0; y < oMatrix.size2(); y++ )
    {
        for ( unsigned int x = 0; x < oMatrix.size1(); x++ )
        {
            std::cout << oMatrix(x,y) << " ";
        }
        std::cout << std::endl;
    }

    return 0;
}
