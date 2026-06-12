#include <iostream>
#include <vector>
#include <numeric>

std::vector<int> divisors( int n ) {
   std::vector<int> divisors ;
   for ( int i = 1 ; i < n + 1 ; i++ ) {
      if ( n % i == 0 )
         divisors.push_back( i ) ;
   }
   return divisors ;
}

int main( ) {
   std::vector<int> multi_perfect ;
   for ( int i = 1 ; i < 501 ; i++ ) {
      std::vector<int> divis { divisors( i ) } ;
      if ( std::accumulate( divis.begin( ) , divis.end( ) , 1 ,
               std::multiplies<int>() ) == (i * i ) )
         multi_perfect.push_back( i ) ;
   }
   std::cout << '(' ;
   int count = 1 ;
   for ( int i : multi_perfect ) {
      std::cout << i << ' ' ;
      if ( count % 15 == 0 )
         std::cout << '\n' ;
      count++ ;
   }
   std::cout << ")\n" ;
   return 0 ;
}
