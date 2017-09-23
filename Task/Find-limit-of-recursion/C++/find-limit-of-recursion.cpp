#include <iostream>

void recurse(unsigned int i)
{
  std::cout<<i<<"\n";
  recurse(i+1);
}

int main()
{
  recurse(0);
}
