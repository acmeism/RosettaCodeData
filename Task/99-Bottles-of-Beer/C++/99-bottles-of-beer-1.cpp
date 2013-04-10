#include <iostream>
using namespace std;

int main()
{
 int bottles = 99;
   do {
     cout << bottles << " bottles of beer on the wall" << endl;
     cout << bottles << " bottles of beer" << endl;
     cout << "Take one down, pass it around" << endl;
     cout << --bottles << " bottles of beer on the wall\n" << endl;
   } while (bottles > 0);
}
