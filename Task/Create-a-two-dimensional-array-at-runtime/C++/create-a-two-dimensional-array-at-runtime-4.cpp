#include <cstdlib>
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>

int main (const int argc, const char** argv) {
    if (argc > 2) {
        using namespace boost::numeric::ublas;

        matrix<double> m(atoi(argv[1]), atoi(argv[2])); // build
        for (unsigned i = 0; i < m.size1(); i++)
            for (unsigned j = 0; j < m.size2(); j++)
                m(i, j) = 1.0 + i + j; // fill
        std::cout << m << std::endl; // print
        return EXIT_SUCCESS;
    }

    return EXIT_FAILURE;
}
