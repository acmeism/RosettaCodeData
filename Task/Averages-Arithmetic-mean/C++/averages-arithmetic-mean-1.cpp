#include <vector>

double mean(const std::vector<double>& numbers)
{
     if (numbers.size() == 0)
          return 0;

     double sum = 0;
     for (std::vector<double>::iterator i = numbers.begin(); i != numbers.end(); i++)
          sum += *i;
     return sum / numbers.size();
}
