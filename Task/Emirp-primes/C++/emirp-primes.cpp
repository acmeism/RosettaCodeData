#include <vector>
#include <iostream>
#include <algorithm>
#include <sstream>
#include <string>
#include <cmath>

bool isPrime ( int number ) {
   if ( number <= 1 )
      return false ;
   if ( number == 2 )
      return true ;
   for ( int i = 2 ; i <= std::sqrt( number ) ; i++ ) {
      if ( number % i == 0 )
	 return false ;
   }
   return true ;
}

int reverseNumber ( int n ) {
   std::ostringstream oss ;
   oss << n ;
   std::string numberstring ( oss.str( ) ) ;
   std::reverse ( numberstring.begin( ) , numberstring.end( ) ) ;
   return std::stoi ( numberstring ) ;
}

bool isEmirp ( int n ) {
   return isPrime ( n ) && isPrime ( reverseNumber ( n ) )
      && n != reverseNumber ( n ) ;
}

int main( ) {
   std::vector<int> emirps ;
   int i = 1 ;
   while ( emirps.size( ) < 20 ) {
      if ( isEmirp( i ) ) {
         emirps.push_back( i ) ;
      }
      i++ ;
   }
   std::cout << "The first 20 emirps:\n" ;
   for ( int i : emirps )
      std::cout << i << " " ;
   std::cout << '\n' ;
   int newstart = 7700 ;
   while ( newstart < 8001 ) {
      if ( isEmirp ( newstart ) )
	std::cout << newstart << '\n' ;
      newstart++ ;
   }
   while ( emirps.size( ) < 10000 ) {
      if ( isEmirp ( i ) ) {
	 emirps.push_back( i ) ;
      }
      i++ ;
   }
   std::cout << "the 10000th emirp is " << emirps[9999] << " !\n" ;

   return 0 ;
}
