#include <iostream>
#include <string>
using namespace std;

int main()
{
     // while probably all current implementations have int wide enough for 75000, the C++ standard
     // only guarantees this for long int.
     long int integer_input;
     string string_input;
     cout << "Enter an integer:  ";
     cin >> integer_input;
     cout << "Enter a string:  ";
     cin >> string_input;
     return 0;
}
