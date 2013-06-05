// Use <functional> for C++11
#include <tr1/functional>
#include <iostream>

using namespace std;
using namespace std::tr1;

void first(function<void()> f)
{
  f();
}

void second()
{
  cout << "second\n";
}

int main()
{
  first(second);
}
