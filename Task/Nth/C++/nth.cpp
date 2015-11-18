#include <string>
#include <iostream>

using namespace std;

string Suffix(int num)
{
    switch (num % 10)
    {
        case 1 : if(num % 100 != 11) return "st";
           break;
        case 2 : if(num % 100 != 12) return "nd";
           break;
        case 3 : if(num % 100 != 13) return "rd";
    }

    return "th";
}

int main()
{
    cout << "Set [0,25]:" << endl;
    for (int i = 0; i < 26; i++)
        cout << i << Suffix(i) << " ";

    cout << endl;

    cout << "Set [250,265]:" << endl;
    for (int i = 250; i < 266; i++)
        cout << i << Suffix(i) << " ";

    cout << endl;

    cout << "Set [1000,1025]:" << endl;
    for (int i = 1000; i < 1026; i++)
        cout << i << Suffix(i) << " ";

    cout << endl;

    return 0;
}
