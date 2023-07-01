#include <vector>
#include <iostream>
#include <cmath>
#include <algorithm>

std::vector<int> decompose( int n ) {
   std::vector<int> digits ;
   while ( n != 0 ) {
      digits.push_back( n % 10 ) ;
      n /= 10 ;
   }
   std::reverse( digits.begin( ) , digits.end( ) ) ;
   return digits ;
}

bool isDisarium( int n ) {
   std::vector<int> digits( decompose( n ) ) ;
   int exposum = 0 ;
   for ( int i = 1 ; i < digits.size( ) + 1 ; i++ ) {
      exposum += static_cast<int>( std::pow(
               static_cast<double>(*(digits.begin( ) + i - 1 )) ,
               static_cast<double>(i) )) ;
   }
   return exposum == n ;
}

int main( ) {
   std::vector<int> disariums ;
   int current = 0 ;
   while ( disariums.size( ) != 18 ){
      if ( isDisarium( current ) )
         disariums.push_back( current ) ;
      current++ ;
   }
   for ( int d : disariums )
      std::cout << d << " " ;
   std::cout << std::endl ;
   return 0 ;
}
