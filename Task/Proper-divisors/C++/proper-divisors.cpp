#include <vector>
#include <iostream>
#include <algorithm>

std::vector<int> properDivisors ( int number ) {
   std::vector<int> divisors ;
   for ( int i = 1 ; i < number / 2 + 1 ; i++ )
      if ( number % i == 0 )
	 divisors.push_back( i ) ;
   return divisors ;
}

int main( ) {
   std::vector<int> divisors ;
   unsigned int maxdivisors = 0 ;
   int corresponding_number = 0 ;
   for ( int i = 1 ; i < 11 ; i++ ) {
      divisors =  properDivisors ( i ) ;
      std::cout << "Proper divisors of " << i << ":\n" ;
      for ( int number : divisors ) {
	 std::cout << number << " " ;
      }
      std::cout << std::endl ;
      divisors.clear( ) ;
   }
   for ( int i = 11 ; i < 20001 ; i++ ) {
      divisors =  properDivisors ( i ) ;
      if ( divisors.size( ) > maxdivisors ) {
	 maxdivisors = divisors.size( ) ;
	 corresponding_number = i ;
      }
      divisors.clear( ) ;
   }

   std::cout << "Most divisors has " << corresponding_number <<
      " , it has " << maxdivisors << " divisors!\n" ;
   return 0 ;
}
