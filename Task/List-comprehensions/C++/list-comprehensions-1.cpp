#include <vector>
#include <cmath>
#include <iostream>
#include <algorithm>
#include <iterator>

void list_comprehension( std::vector<int> & , int ) ;

int main( ) {
   std::vector<int> triangles ;
   list_comprehension( triangles , 20 ) ;
   std::copy( triangles.begin( ) , triangles.end( ) ,
	 std::ostream_iterator<int>( std::cout , " " ) ) ;
   std::cout << std::endl ;
   return 0 ;
}

void list_comprehension( std::vector<int> & numbers , int upper_border ) {
   for ( int a = 1 ; a < upper_border ; a++ ) {
      for ( int b = a + 1 ; b < upper_border ; b++ ) {
	 double c = pow( a * a + b * b , 0.5 ) ; //remembering Mr. Pythagoras
	 if ( ( c * c ) < pow( upper_border , 2 ) + 1 ) {
	    if ( c == floor( c ) ) {
	       numbers.push_back( a ) ;
	       numbers.push_back( b ) ;	
	       numbers.push_back( static_cast<int>( c ) ) ;
	    }
	 }
      }
   }
}
