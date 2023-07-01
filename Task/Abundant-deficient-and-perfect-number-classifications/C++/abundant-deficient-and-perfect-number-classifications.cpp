#include <iostream>
#include <algorithm>
#include <vector>

std::vector<int> findProperDivisors ( int n ) {
   std::vector<int> divisors ;
   for ( int i = 1 ; i < n / 2 + 1 ; i++ ) {
      if ( n % i == 0 )
	 divisors.push_back( i ) ;
   }
   return divisors  ;
}

int main( ) {
   std::vector<int> deficients , perfects , abundants , divisors ;
   for ( int n = 1 ; n < 20001 ; n++ ) {
      divisors = findProperDivisors( n ) ;
      int sum = std::accumulate( divisors.begin( ) , divisors.end( ) , 0 ) ;
      if ( sum < n ) {
	 deficients.push_back( n ) ;
      }
      if ( sum == n ) {
	 perfects.push_back( n ) ;
      }
      if ( sum > n ) {
	 abundants.push_back( n ) ;
      }
   }
   std::cout << "Deficient : " << deficients.size( ) << std::endl ;
   std::cout << "Perfect   : " << perfects.size( ) << std::endl ;
   std::cout << "Abundant  : " << abundants.size( ) << std::endl ;
   return 0 ;
}
