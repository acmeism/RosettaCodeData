#include<iostream>
#include<conio.h>
using namespace std;
typedef unsigned long ulong;

int ith_digit_finder(long long n, long b, long i){
 /**
     n = number whose digits we need to extract
     b = radix in which the number if represented
     i = the ith bit (ie, index of the bit that needs to be extracted)
 **/
    while(i>0){
        n/=b;
        i--;
    }
    return (n%b);
}

long eeuclid(long m, long b, long *inverse){        /// eeuclid( modulus, num whose inv is to be found, variable to put inverse )
    /// Algorithm used from Stallings book
    long A1 = 1, A2 = 0, A3 = m,
         B1 = 0, B2 = 1, B3 = b,
         T1, T2, T3, Q;

         cout<<endl<<"eeuclid() started"<<endl;

        while(1){
            if(B3 == 0){
                *inverse = 0;
                return A3;      // A3 = gcd(m,b)
            }

            if(B3 == 1){
                *inverse = B2; // B2 = b^-1 mod m
                return B3;      // A3 = gcd(m,b)
            }

            Q = A3/B3;

            T1 = A1 - Q*B1;
            T2 = A2 - Q*B2;
            T3 = A3 - Q*B3;

            A1 = B1; A2 = B2; A3 = B3;
            B1 = T1; B2 = T2; B3 = T3;

       }
    cout<<endl<<"ending eeuclid() "<<endl;
}

long long mon_red(long m, long m_dash, long T, int n, long b = 2){
/**
    m = modulus
    m_dash = m' = -m^-1 mod b
    T = number whose modular reduction is needed, the o/p of the function is TR^-1 mod m
    n = number of bits in m (2n is the number of bits in T)
    b = radix used (for practical implementations, is equal to 2, which is the default value)
**/
    long long A,ui, temp, Ai;       // Ai is the ith bit of A, need not be llong long probably
    if( m_dash < 0 ) m_dash = m_dash + b;
    A = T;
    for(int i = 0; i<n; i++){
    ///    ui = ( (A%b)*m_dash ) % b;        // step 2.1; A%b gives ai (MISTAKE -- A%b will always give the last digit of A if A is represented in base b); hence we need the function ith_digit_finder()
        Ai = ith_digit_finder(A, b, i);
        ui = ( ( Ai % b) * m_dash ) % b;
        temp  = ui*m*power(b, i);
        A = A + temp;
    }
    A = A/power(b, n);
    if(A >= m) A = A - m;
    return A;
}

int main(){
    long a, b, c, d=0, e, inverse = 0;
    cout<<"m >> ";
    cin >> a;
    cout<<"T >> ";
    cin>>b;
    cout<<"Radix b >> ";
    cin>>c;
    eeuclid(c, a, &d);      // eeuclid( modulus, num whose inverse is to be found, address of variable which is to store inverse)
    e = mon_red(a, -d, b, length_finder(a, c), c);
    cout<<"Montgomery domain representation = "<<e;
    return 0;
}
