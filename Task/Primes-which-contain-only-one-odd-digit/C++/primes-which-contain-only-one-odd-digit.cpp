#include <vector>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <iterator>

bool isPrime( int n ) {
   int limit = static_cast<int>( std::floor( std::sqrt( static_cast<double>( n ) ) ) ) ;
   for ( int i = 2 ; i < limit + 1 ; i++ ) {
      if ( n % i == 0 ) {
         return false ;
      }
   }
   return true ;
}

bool hasOneOdd( int n ) {
   std::vector<int> digits ;
   while ( n != 0 ) {
      digits.push_back( n % 10 ) ;
      n /= 10 ;
   }
   return std::count_if( digits.begin( ) , digits.end( ) , []( int i ) { return
         i % 2 == 1 ; } ) == 1 ;
}

bool condition( int n ) {
   return isPrime( n ) && hasOneOdd( n ) ;
}

int main( ) {
   std::vector<int> primes ;
   for ( int i = 2 ; i < 1000 ; i++ ) {
      if ( condition( i ) )
         primes.push_back( i ) ;
   }
   std::cout << "Primes under 1000 with only one odd digit :\n" ;
   std::copy( primes.begin( ) , primes.end( ) , std::ostream_iterator<int>( std::cout ,
            " " ) ) ;
   for ( int i = 1000 ; i < 1000000 ; i++ ) {
      if ( condition( i ) )
         primes.push_back( i ) ;
   }
   std::cout << "\nThe number of primes under 1000000 with only one odd digit is " <<
      primes.size( ) << " !\n " ;
   return 0 ;
}
