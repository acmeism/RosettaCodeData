#include <iomanip>
#include <iostream>
using namespace std;

const int pasTriMax = 61;

uint64_t pasTri[pasTriMax + 1];

void pascalTriangle(unsigned long n)
// Calculate the n'th line 0.. middle
{
    unsigned long j, k;

    pasTri[0] = 1;
    j = 1;
    while (j <= n)
    {
        j++;
        k = j / 2;
        pasTri[k] = pasTri[k - 1];
        for ( ;k >= 1; k--)
            pasTri[k] += pasTri[k - 1];
    }
}

bool isPrime(unsigned long n)
{
    if (n > pasTriMax)
    {
        cout << n << " is out of range" << endl;
        exit(1);
    }

    pascalTriangle(n);
    bool res = true;
    int i = n / 2;
    while (res && (i > 1))
    {
        res = res && (pasTri[i] % n == 0);
        i--;
    }
    return res;
}

void expandPoly(unsigned long n)
{
    const char vz[] = {'+', '-'};

    if (n > pasTriMax)
    {
        cout << n << " is out of range" << endl;
        exit(1);
    }

    switch (n)
    {
        case 0:
            cout << "(x-1)^0 = 1" << endl;
            break;
        case 1:
            cout << "(x-1)^1 = x-1" << endl;
            break;
        default:
            pascalTriangle(n);
            cout << "(x-1)^" << n << " = ";
            cout << "x^" << n;
            bool bVz = true;
            int nDiv2 = n / 2;
            for (unsigned long j = n - 1; j > nDiv2; j--, bVz = !bVz)
                cout << vz[bVz] << pasTri[n - j] << "*x^" << j;
            for (unsigned long j = nDiv2; j > 1; j--, bVz = !bVz)
                cout << vz[bVz] << pasTri[j] << "*x^" << j;
            cout << vz[bVz] << pasTri[1] << "*x";
            bVz = !bVz;
            cout << vz[bVz] << pasTri[0] << endl;
            break;
    }
}

int main()
{
    for (unsigned long n = 0; n <= 9; n++)
        expandPoly(n);
    for (unsigned long n = 2; n <= pasTriMax; n++)
        if (isPrime(n))
            cout << setw(3) << n;
    cout << endl;
}
