#include <vector>
#include <iostream>
#include <algorithm>
#include <iterator>

int main( ) {
   std::vector< int > intVec( 10 ) ;
   std::iota( intVec.begin( ) , intVec.end( ) , 1 ) ;//fill the vector
   std::transform( intVec.begin( ) , intVec.end( ) , intVec.begin( ) ,
	 [ ] ( int i ) { return i * i ; } ) ; //transform it with closures
   std::copy( intVec.begin( ) , intVec.end( ) ,
	 std::ostream_iterator<int> ( std::cout , " " ) ) ;
   std::cout << std::endl ;
   return 0 ;
}
