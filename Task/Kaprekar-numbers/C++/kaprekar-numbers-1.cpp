#include <vector>
#include <string>
#include <iostream>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <utility>

long string2long( const std::string & s ) {
   long result ;
   std::istringstream( s ) >> result ;
   return result ;
}

bool isKaprekar( long number ) {
   long long squarenumber = ((long long)number) * number ;
   std::ostringstream numberbuf ;
   numberbuf << squarenumber ;
   std::string numberstring = numberbuf.str( ) ;
   for ( int i = 0 ; i < numberstring.length( ) ; i++ ) {
      std::string firstpart = numberstring.substr( 0 , i ) ,
                  secondpart = numberstring.substr( i ) ;
      //we do not accept figures ending in a sequence of zeroes
      if ( secondpart.find_first_not_of( "0" ) == std::string::npos ) {
	 return false ;
      }
      if ( string2long( firstpart ) + string2long( secondpart ) == number ) {
	 return true ;
      }
   }
   return false ;
}

int main( ) {
   std::vector<long> kaprekarnumbers ;
   kaprekarnumbers.push_back( 1 ) ;
   for ( int i = 2 ; i < 1000001 ; i++ ) {
      if ( isKaprekar( i ) )
	 kaprekarnumbers.push_back( i ) ;
   }
   std::vector<long>::const_iterator svi = kaprekarnumbers.begin( ) ;
   std::cout << "Kaprekar numbers up to 10000: \n" ;
   while ( *svi < 10000 ) {
      std::cout << *svi << " " ;
      svi++ ;
   }
   std::cout << '\n' ;
   std::cout << "All the Kaprekar numbers up to 1000000 :\n" ;
   std::copy( kaprekarnumbers.begin( ) , kaprekarnumbers.end( ) ,
	 std::ostream_iterator<long>( std::cout , "\n" ) ) ;
   std::cout << "There are " << kaprekarnumbers.size( )
      << " Kaprekar numbers less than one million!\n" ;
   return 0 ;
}
