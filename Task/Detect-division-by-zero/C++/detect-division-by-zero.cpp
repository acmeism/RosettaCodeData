#include<iostream>
#include<csignal> /* for signal */
#include<cstdlib>

using namespace std;

void fpe_handler(int signal)
{
    cerr << "Floating Point Exception: division by zero" << endl;
    exit(signal);
}

int main()
{
    // Register floating-point exception handler.
    signal(SIGFPE, fpe_handler);

    int a = 1;
    int b = 0;
    cout << a/b << endl;

    return 0;
}
