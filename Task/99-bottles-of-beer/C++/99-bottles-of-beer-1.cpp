#include <iostream>
using std::cout;

int main()
{
  for(int bottles(99); bottles > 0; bottles -= 1){
    cout << bottles << " bottles of beer on the wall\n"
         << bottles << " bottles of beer\n"
         << "Take one down, pass it around\n"
         << bottles - 1 << " bottles of beer on the wall\n\n";
  }
}
