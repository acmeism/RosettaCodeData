#include <iostream>
#include <iomanip>
#include <boost/multiprecision/cpp_dec_float.hpp>
#include <boost/math/constants/constants.hpp>
typedef boost::multiprecision::cpp_dec_float_50 decfloat;

int main()
{
    const decfloat ln_two = boost::math::constants::ln_two<decfloat>();
    decfloat numerator = 1, denominator = ln_two;

    for(int n = 1; n <= 17; n++) {
        decfloat h = (numerator *= n) / (denominator *= ln_two) / 2;
        decfloat tenths_dig = floor((h - floor(h)) * 10);
        std::cout << "h(" << std::setw(2) << n << ") = " << std::setw(25) << std::fixed << h <<
            (tenths_dig == 0 || tenths_dig == 9 ? " is " : " is NOT ") << "an almost-integer.\n";
    }
}
