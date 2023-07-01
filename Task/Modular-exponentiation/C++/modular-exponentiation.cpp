#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>
#include <boost/multiprecision/integer.hpp>

int main() {
    using boost::multiprecision::cpp_int;
    using boost::multiprecision::pow;
    using boost::multiprecision::powm;
    cpp_int a("2988348162058574136915891421498819466320163312926952423791023078876139");
    cpp_int b("2351399303373464486466122544523690094744975233415544072992656881240319");
    std::cout << powm(a, b, pow(cpp_int(10), 40)) << '\n';
    return 0;
}
