#include <iostream>
using namespace std;
/* passing arguments by reference */
void f(int &y) /* variable is now passed by reference */
{
y++;
}
int main()
{
int x = 0;
cout<<"x = "<<x<<endl; /* should produce result "x = 0" */
f(x);                  /* call function f */
cout<<"x = "<<x<<endl; /* should produce result "x = 1" */
}
