#include <algorithm>
#include <cmath>    // ::sqrt()
#include <fstream>
#include <iomanip>  // setprecision()
#include <iostream>
#include <string>
#include <vector>

int main()
{
  try {
    // prepare test data
    double x[] = {1, 2, 3, 1e11};
    const size_t xsize = sizeof(x) / sizeof(*x);
    std::vector<double> y(xsize);
    std::transform(&x[0], &x[xsize], y.begin(), ::sqrt);

    // write file using default precisions
    writedat("sqrt.dat", &x[0], &x[xsize], y.begin(), y.end());

    // print the result file
    std::ifstream f("sqrt.dat");
    for (std::string line; std::getline(f, line); )
      std::cout << line << std::endl;
  }
  catch(std::exception& e) {
    std::cerr << "writedat: exception: '" << e.what() << "'\n";
    return 1;
  }
  return 0;
}
