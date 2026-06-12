#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <set>
#include <string>
#include <vector>

#include "omp.h"

const std::string digits = "0123456789abcdef";

std::string convert_decimal_to_base(uint64_t number, const uint32_t& radix) {
    std::string result = "";
    while ( number > 0 ) {
        result += digits[number % radix];
        number /= radix;
    }
    std::reverse(result.begin(), result.end());
    return result;
}

int main() {
    const std::vector<uint32_t> largest_prime_factors = { 1, 2, 3, 2, 5, 3, 7, 2, 3, 5, 11, 3, 13, 7, 5 };

    for ( size_t radix = 2; radix <= 16; ++radix ) {
        std::vector<std::string> penholo = { };
        std::vector<std::string> penholo_squares = { };

        std::string radix_digits = digits.substr(1, radix - 1);
        uint32_t min = std::ceil(std::sqrt(std::stoll(radix_digits, nullptr, radix)));
        std::reverse(radix_digits.begin(), radix_digits.end());
        const uint32_t max = std::floor(std::sqrt(std::stoll(radix_digits, nullptr, radix)));
        const uint32_t divisor = largest_prime_factors[radix - 2];
        min += ( min % divisor == 0 ) ? 0 : ( divisor - min % divisor );

        #pragma omp parallel
        {
            std::vector<std::string> local_penholo;
            std::vector<std::string> local_penholo_squares;

            #pragma omp for schedule(dynamic)
            for ( uint64_t number = min; number <= max; number += divisor ) {
                std::string square = convert_decimal_to_base(number * number, radix);
                square.erase(std::remove(square.begin(), square.end(), '0'), square.end());
                if ( std::set<char>{ square.begin(), square.end() }.size() == radix - 1 ) {
                    local_penholo.emplace_back(convert_decimal_to_base(number, radix));
                    local_penholo_squares.emplace_back(square);
                }
            }

            #pragma omp critical
            {
                penholo.insert(penholo.end(), local_penholo.begin(), local_penholo.end());
                penholo_squares.insert(penholo_squares.end(), local_penholo_squares.begin(), local_penholo_squares.end());
            }
        }

        std::cout << "There is a total of " << penholo.size()
                  << " penholodigital squares in base " << radix << ":" << "\n";
        if ( radix <= 13 ) {
            for ( uint64_t i = 0; i < penholo.size(); ++i ) {
                std::cout << penholo[i] + "² = " + penholo_squares[i]
                    + (  i % 3 == 2 ? "\n" : "    " );
            }
            std::cout << ( penholo.size() % 3 == 0 ? "\n" : "\n\n" );
        } else {
            std::cout << penholo.front() << "² = " << penholo_squares.front() << " ... "
                << penholo.back() << "² = " << penholo_squares.back() << "\n\n";
        }
    }
}
