#include <string>
#include <iostream>

std::string repeat( const std::string &word, int times ) {
   std::string result ;
   result.reserve(times*word.length()); // avoid repeated reallocation
   for ( int a = 0 ; a < times ; a++ )
      result += word ;
   return result ;
}

int main( ) {
   std::cout << repeat( "Ha" , 5 ) << std::endl ;
   return 0 ;
}
