#include <iostream>
#include <vector>
#include <algorithm>

bool isUpsideDown( int n ) {
   std::vector<int> digits ;
   while ( n != 0 ) {
      digits.push_back( n % 10 ) ;
      n /= 10 ;
   }
   if ( std::find ( digits.begin( ) , digits.end( ) , 0 ) != digits.end( ) )
      return false ;
   int forward = 0 ;
   int backward = digits.size( ) - 1 ;
   while ( forward <= backward ) {
      if ( digits[forward] + digits[backward] != 10 )
         return false ;
      forward++ ;
      if ( backward > 0 ) {
         backward-- ;
      }
   }
   return true ;
}

int main( ) {
   int current = 0 ;
   int sum = 0 ;
   std::vector<int> solution ;
   while ( sum != 5000 ) {
      current++ ;
      if ( isUpsideDown( current ) ) {
         solution.push_back( current ) ;
         sum++ ;
      }
   }
   std::cout << "The first 50 upside-down numbers:\n" ;
   std::cout << "(" ;
   for ( int i = 0 ; i < 50 ; i++ )
      std::cout << solution[ i ] << ' ' ;
   std::cout << ")\n" ;
   std::cout << "The five hundredth such number: " << solution[499] << '\n' ;
   std::cout << "The five thousandth such number: " << solution[4999] << '\n' ;
   return 0 ;
}
