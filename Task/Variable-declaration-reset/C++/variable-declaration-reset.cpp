#include <array>
#include <iostream>

int main()
{
  constexpr std::array s {1,2,2,3,4,4,5};

  if(!s.empty())
  {
    int previousValue = s[0];

    for(size_t i = 1; i < s.size(); ++i)
    {
      // in C++, variables in block scope are reset at each iteration
      const int currentValue = s[i];

      if(i > 0 && previousValue == currentValue)
      {
        std::cout << i << "\n";
      }

      previousValue = currentValue;
    }
  }
}
