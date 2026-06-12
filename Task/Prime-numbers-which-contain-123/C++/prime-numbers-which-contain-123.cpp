#include <iostream>
#include <string>
#include <vector>
#include <cmath>

bool isPrime( int number ) {
   if ( number < 2 ) {
      return false ;
   }
   int stop =  std::sqrt( static_cast<double>( number ) ) ;
   for ( int i = 2 ; i <= stop ; ++i )
      if ( number % i == 0 )
         return false ;
   return true ;
}

bool condition( int n ) {
   std::string numberstring { std::to_string( n ) } ;
   return isPrime( n ) && numberstring.find( "123" ) != std::string::npos ;
}

int main( ) {
   std::vector<int> wantedPrimes ;
   for ( int i = 1 ; i < 100000 ; i++ ) {
      if ( condition( i ) )
         wantedPrimes.push_back( i ) ;
   }
   int count = 0 ;
   for ( int i : wantedPrimes ) {
      std::cout << i << ' ' ;
      count++ ;
      if ( count % 10 == 0 ) {
         std::cout << std::endl ;
      }
   }
   count = wantedPrimes.size( ) ;
   for ( int i = wantedPrimes.back( ) + 1 ; i < 1000000 ; i++ ) {
      if ( condition ( i ) )
         count++ ;
   }
   std::cout << std::endl ;
   std::cout << "There are " << count << " such numbers below 1000000!\n" ;
   return 0 ;
}
