#include <iostream>
#include <boost/multiprecision/gmp.hpp>
#include <string>

namespace mp = boost::multiprecision;

int main(int argc, char const *argv[])
{
    // We could just use (1 << 18) instead of tmpres, but let's point out one
    // pecularity with gmp and hence boost::multiprecision: they won't accept
    // a second mpz_int with pow(). Therefore, if we stick to multiprecision
    // pow we need to convert_to<uint64_t>().
    uint64_t tmpres = mp::pow(mp::mpz_int(4)
                            , mp::pow(mp::mpz_int(3)
                                    , 2).convert_to<uint64_t>()
                                      ).convert_to<uint64_t>();
    mp::mpz_int res = mp::pow(mp::mpz_int(5), tmpres);
    std::string s = res.str();
    std::cout << s.substr(0, 20)
              << "..."
              << s.substr(s.length() - 20, 20) << std::endl;
    return 0;
}
