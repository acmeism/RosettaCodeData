#include <iostream>
#include <iomanip>
#include <cmath>
#include <string>
#include <vector>
#include <algorithm>

bool isPrime( int n ) {
   if ( n == 2 )
      return true ;
   else {
      int limit = static_cast<int>( floor ( std::sqrt( static_cast<int>(
                     n ) ) ) ) ;
      for ( int i = 2 ; i < limit + 1 ; i++ ) {
         if ( n % i == 0 )
            return false ;
      }
      return true ;
   }
}

int concatenate( int a , int b ) {
   std::string firstNum { std::to_string( a ) } ;
   std::string secondNum { std::to_string( b ) } ;
   std::string concat { firstNum + secondNum } ;
   return std::stoi( concat ) ;
}

int main( ) {
   std::vector<int> primes, concatPrimes ;
   for ( int i = 2 ; i < 100 ; i++ ) {
      if ( isPrime( i ) )
         primes.push_back( i ) ;
   }
   int len = primes.size( ) ;
   for ( int i = 0 ; i < len  ; i++ ) {
      for ( int j = 0 ; j < len ; j++ ) {
         int k = concatenate( primes[i] , primes[j] ) ;
         if ( isPrime( k ) )
            concatPrimes.push_back( k ) ;
      }
   }
   std::cout << "There are " << concatPrimes.size( ) << " concatenated "
      << "primes , each part under 100!\n" ;
   int count = 0 ;
   std::sort( concatPrimes.begin( ) , concatPrimes.end( ) ) ;
   for ( int num : concatPrimes ) {
      std::cout << std::right << std::setw( 5 ) << num ;
      count++ ;
      if ( count == 10 ) {
         std::cout << '\n' ;
         count = 0 ;
      }
   }
   std::cout << '\n' ;
   return 0 ;
}
