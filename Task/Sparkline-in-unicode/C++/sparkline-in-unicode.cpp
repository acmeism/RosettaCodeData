#include <iostream>
#include <sstream>
#include <vector>
#include <cmath>
#include <algorithm>
#include <locale>

class Sparkline {
    public:
        Sparkline(std::wstring &cs) : charset( cs ){
        }
        virtual ~Sparkline(){
        }

        void print(std::string spark){
            const char *delim = ", ";
            std::vector<float> data;
            // Get first non-delimiter
            std::string::size_type last = spark.find_first_not_of(delim, 0);
            // Get end of token
            std::string::size_type pos = spark.find_first_of(delim, last);

            while( pos != std::string::npos || last != std::string::npos ){
                std::string tok = spark.substr(last, pos-last);
                // Convert to float:
                std::stringstream ss(tok);
                float entry;
                ss >> entry;

                data.push_back( entry );

                last = spark.find_first_not_of(delim, pos);
                pos = spark.find_first_of(delim, last);
            }

            // Get range of dataset
            float min = *std::min_element( data.begin(), data.end() );
            float max = *std::max_element( data.begin(), data.end() );

            float skip = (charset.length()-1) / (max - min);

            std::wcout<<L"Min: "<<min<<L"; Max: "<<max<<L"; Range: "<<(max-min)<<std::endl;

            std::vector<float>::const_iterator it;
            for(it = data.begin(); it != data.end(); it++){
                float v = ( (*it) - min ) * skip;
                std::wcout<<charset[ (int)floor( v ) ];
            }
            std::wcout<<std::endl;

        }
    private:
        std::wstring &charset;
};

int main( int argc, char **argv ){
    std::wstring charset = L"\u2581\u2582\u2583\u2584\u2585\u2586\u2587\u2588";

    // Mainly just set up utf-8, so wcout won't narrow our characters.
    std::locale::global(std::locale("en_US.utf8"));

    Sparkline sl(charset);

    sl.print("1 2 3 4 5 6 7 8 7 6 5 4 3 2 1");
    sl.print("1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5");

    return 0;
}
