#include <vector>
#include <iostream>

int main()
{
  std::vector<int> a(3), b(4);
  a[0] = 11; a[1] = 12; a[2] = 13;
  b[0] = 21; b[1] = 22; b[2] = 23; b[3] = 24;

  a.insert(a.end(), b.begin(), b.end());

  for (int i = 0; i < a.size(); ++i)
    std::cout << "a[" << i << "] = " << a[i] << "\n";
}
