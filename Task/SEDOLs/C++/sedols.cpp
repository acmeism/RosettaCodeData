#include <numeric>
#include <cctype>
#include <iostream>
#include <string>


template<typename result_sink_t>
auto sedol_checksum(std::string const& sedol, result_sink_t result_sink)
{
    if(sedol.size() != 6)
        return result_sink(0, "length of sedol string != 6");

    const char * valid_chars = "BCDFGHJKLMNPQRSTVWXYZ0123456789";
    if(sedol.find_first_not_of(valid_chars) != std::string::npos)
        return result_sink(0, "sedol string contains disallowed characters");

    const int weights[] = {1,3,1,7,3,9};
    auto weighted_sum = std::inner_product(sedol.begin(), sedol.end(), weights, 0
                                           , [](int acc, int prod){ return acc + prod; }
                                           , [](char c, int weight){ return (std::isalpha(c) ? c -'A' + 10 : c - '0') * weight; }
                                             );
    return result_sink((10 - (weighted_sum % 10)) % 10, nullptr);
}

int main()
{
    using namespace std;
    string inputs[] = {
       "710889", "B0YBKJ", "406566", "B0YBLH", "228276", "B0YBKL",
       "557910", "B0YBKR", "585284", "B0YBKT", "B00030"
   };
   for(auto const & sedol : inputs)
   {
        sedol_checksum(sedol, [&](auto sum, char const * errorMessage)
        {
            if(errorMessage)
                cout << "error for sedol: " << sedol << " message: " <<  errorMessage << "\n";
            else
                cout << sedol << sum << "\n";
        });
   }
   return 0;
}
