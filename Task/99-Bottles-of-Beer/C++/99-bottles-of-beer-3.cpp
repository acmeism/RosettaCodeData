#include <iostream>
using namespace std;
void rec(int bottles)
{
if ( bottles!=0)
 {
     cout << bottles << " bottles of beer on the wall" << endl;
        cout << bottles << " bottles of beer" << endl;
        cout << "Take one down, pass it around" << endl;
        cout << --bottles << " bottles of beer on the wall\n" << endl;
    rec(bottles);
 }
}

int main()
 {
rec(99);
system("pause");
return 0;
}
