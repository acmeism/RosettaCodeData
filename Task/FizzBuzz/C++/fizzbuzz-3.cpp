#include <iostream>
using namespace std;

int main()
{
  for (int i = 0; i <= 100; ++i)
  {
    bool fizz = (i % 3) == 0;
    bool buzz = (i % 5) == 0;
    if (fizz)
      cout << "Fizz";
    if (buzz)
      cout << "Buzz";
    if (!fizz && !buzz)
      cout << i;
    cout << "\n";
  }
  return 0;
}
