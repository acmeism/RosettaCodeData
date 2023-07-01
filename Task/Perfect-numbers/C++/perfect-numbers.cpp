#include <iostream>
using namespace std ;

int divisor_sum( int number ) {
   int sum = 0 ;
   for ( int i = 1 ; i < number ; i++ )
      if ( number % i == 0 )
         sum += i ;
   return sum;
}

int main( ) {
   cout << "Perfect numbers from 1 to 33550337:\n" ;
   for ( int num = 1 ; num < 33550337 ; num++ ) {
      if (divisor_sum(num) == num)
         cout << num << '\n' ;
   }
   return 0 ;
}
