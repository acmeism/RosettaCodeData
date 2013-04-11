#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include <boost/lexical_cast.hpp>
#include <boost/algorithm/string.hpp>

using std::cout;
using std::endl;
const int NumFlags = 24;

int main()
{
    std::fstream file("readings.txt");

    int badCount = 0;
    std::string badDate;
    int badCountMax = 0;
    while(true)
    {
        std::string line;
        getline(file, line);
        if(!file.good())
            break;

        std::vector<std::string> tokens;
        boost::algorithm::split(tokens, line, boost::is_space());

        if(tokens.size() != NumFlags * 2 + 1)
        {
            cout << "Bad input file." << endl;
            return 0;
        }

        double total = 0.0;
        int accepted = 0;
        for(size_t i = 1; i < tokens.size(); i += 2)
        {
            double val = boost::lexical_cast<double>(tokens[i]);
            int flag = boost::lexical_cast<int>(tokens[i+1]);
            if(flag > 0)
            {
                total += val;
                ++accepted;
                badCount = 0;
            }
            else
            {
                ++badCount;
                if(badCount > badCountMax)
                {
                    badCountMax = badCount;
                    badDate = tokens[0];
                }
            }
        }

        cout << tokens[0];
        cout << "  Reject: " << std::setw(2) << (NumFlags - accepted);
        cout << "  Accept: " << std::setw(2) << accepted;
        cout << "  Average: " << std::setprecision(5) << total / accepted << endl;
    }
    cout << endl;
    cout << "Maximum number of consecutive bad readings is " << badCountMax << endl;
    cout << "Ends on date " << badDate << endl;
}
