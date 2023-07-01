#include <string>
#include <map>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <iomanip>

double log2( double number ) {
   return ( log( number ) / log( 2 ) ) ;
}

double find_entropy( std::string & fiboword ) {
   std::map<char , int> frequencies ;
   std::for_each( fiboword.begin( ) , fiboword.end( ) ,
	 [ & frequencies ]( char c ) { frequencies[ c ]++ ; } ) ;
   int numlen = fiboword.length( ) ;
   double infocontent = 0 ;
   for ( std::pair<char , int> p : frequencies ) {
      double freq = static_cast<double>( p.second ) / numlen ;
      infocontent += freq * log2( freq ) ;
   }
   infocontent *= -1 ;
   return infocontent ;
}

void printLine( std::string &fiboword , int n ) {
   std::cout << std::setw( 5 ) << std::left << n ;
   std::cout << std::setw( 12 ) << std::right << fiboword.size( ) ;
   std::cout << "  " << std::setw( 16 ) << std::setprecision( 13 )
      << std::left << find_entropy( fiboword ) ;
   std::cout << "\n" ;
}

int main( ) {
   std::cout << std::setw( 5 ) << std::left << "N" ;
   std::cout << std::setw( 12 ) << std::right << "length" ;
   std::cout << "  " << std::setw( 16 ) << std::left << "entropy" ;
   std::cout << "\n" ;
   std::string firststring ( "1" ) ;
   int n = 1 ;
   printLine( firststring , n ) ;
   std::string secondstring( "0" ) ;
   n++ ;
   printLine( secondstring , n ) ;
   while ( n < 37 ) {
      std::string resultstring = firststring + secondstring ;
      firststring.assign( secondstring ) ;
      secondstring.assign( resultstring ) ;
      n++ ;
      printLine( resultstring , n ) ;
   }
   return 0 ;
}
