#include "stdafx.h"
#include <iostream>
#include <math.h>
using namespace std;

bool isPrime(double number)
{
    for (double i = number - 1; i >= 2; i--) {
        if (fmod(number, i) == 0)
        return false;
    }
    return true;
}
int main()
{
    double i = 42;
    int n = 0;
    while (n < 42)
    {
        if (isPrime(i))
        {
            n++;
        cout.width(1); cout << left << "n = " << n;
            //Only for Text Alignment
            if (n < 10)
        {
            cout.width(40); cout << right << i << endl;
        }
        else
        {
        cout.width(39); cout << right << i << endl;
        }
            i += i - 1;
    }
    i++;
    }
    return 0;
}
