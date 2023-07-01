#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>

int main()
{
  using namespace boost::numeric::ublas;

  matrix<double> m(3,3);

  for(int i=0; i!=m.size1(); ++i)
    for(int j=0; j!=m.size2(); ++j)
      m(i,j)=3*i+j;

  std::cout << trans(m) << std::endl;
}
