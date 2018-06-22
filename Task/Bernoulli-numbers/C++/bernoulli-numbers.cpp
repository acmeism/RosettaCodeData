/**
 * Configured with: --prefix=/Library/Developer/CommandLineTools/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
 * Apple LLVM version 9.1.0 (clang-902.0.39.1)
 * Target: x86_64-apple-darwin17.5.0
 * Thread model: posix
*/

#include <iostream> //std::cout
#include <iostream> //formatting
#include <vector> //Container
#include <boost/rational.hpp> // Rationals
#include <boost/multiprecision/cpp_int.hpp> //1024bit precision


typedef boost::rational<boost::multiprecision::int1024_t> rational; // reduce boilerplate

rational bernulli(size_t n){

     auto out = std::vector<rational>();

     for(size_t m=0;m<=n;m++){
         out.emplace_back(1,(m+1)); // automatically constructs object
         for (size_t j = m;j>=1;j--){
             out[j-1] = rational(j) * (out[j-1]-out[j]);
         }
     }
     return out[0];
 }

int main() {
    for(size_t n = 0; n <= 60;n+=n>=2?2:1){
        auto b = bernulli(n);
        std::cout << "B("<<std::right<<std::setw(2)<<n<<") = ";
        std::cout << std::right<<std::setw(44)<<b.numerator();
        std::cout << " / " << b.denominator() <<std::endl;
    }

    return 0;
}
