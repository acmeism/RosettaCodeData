#include <string>
#include <iostream>
#include <boost/algorithm/string.hpp>
#include <map>
#include <algorithm>
#include <cctype>
using namespace boost::algorithm ;

bool isValid ( const std::string &ibanstring ) {

   static std::map<std::string, int> countrycodes
                           { {"AL" , 28} , {"AD" , 24} , {"AT" , 20} , {"AZ" , 28 } ,
			   {"BE" , 16} , {"BH" , 22} , {"BA" , 20} , {"BR" , 29 } ,
			   {"BG" , 22} , {"CR" , 21} , {"HR" , 21} , {"CY" , 28 } ,
			   {"CZ" , 24} , {"DK" , 18} , {"DO" , 28} , {"EE" , 20 } ,
			   {"FO" , 18} , {"FI" , 18} , {"FR" , 27} , {"GE" , 22 } ,
                           {"DE" , 22} , {"GI" , 23} , {"GR" , 27} , {"GL" , 18 } ,
                           {"GT" , 28} , {"HU" , 28} , {"IS" , 26} , {"IE" , 22 } ,
			   {"IL" , 23} , {"IT" , 27} , {"KZ" , 20} , {"KW" , 30 } ,
			   {"LV" , 21} , {"LB" , 28} , {"LI" , 21} , {"LT" , 20 } ,
			   {"LU" , 20} , {"MK" , 19} , {"MT" , 31} , {"MR" , 27 } ,
			   {"MU" , 30} , {"MC" , 27} , {"MD" , 24} , {"ME" , 22 } ,
			   {"NL" , 18} , {"NO" , 15} , {"PK" , 24} , {"PS" , 29 } ,
			   {"PL" , 28} , {"PT" , 25} , {"RO" , 24} , {"SM" , 27 } ,
			   {"SA" , 24} , {"RS" , 22} , {"SK" , 24} , {"SI" , 19 } ,
			   {"ES" , 24} , {"SE" , 24} , {"CH" , 21} , {"TN" , 24 } ,
			   {"TR" , 26} , {"AE" , 23} , {"GB" , 22} , {"VG" , 24 } } ;
   std::string teststring( ibanstring ) ;
   erase_all( teststring , " " ) ; //defined in boost/algorithm/string.hpp
   if ( countrycodes.find( teststring.substr(0 , 2 )) == countrycodes.end( ) )
      return false ;
   if ( teststring.length( ) != countrycodes[ teststring.substr( 0 , 2 ) ] )
      return false ;
   if ( ! ( all ( teststring , is_alnum( ) ) ) )
      return false ;
   to_upper( teststring ) ;
   teststring = teststring.append( teststring.substr( 0 , 4 ) ) ;
   teststring.assign( teststring.substr( 4 ) ) ;
   std::string numberstring ;//will contain the letter substitutions
   for ( int i = 0 ; i < teststring.length( ) ; i++ ) {
      if ( std::isdigit( teststring[ i ] ) )
	 numberstring = numberstring +  teststring[ i ]  ;
      if ( std::isupper( teststring[ i ] ) )
	 numberstring = numberstring +  std::to_string( static_cast<int>( teststring[ i ] ) - 55 ) ;
   }
   //implements a stepwise check for mod 97 in chunks of 9 at the first time
   // , then in chunks of seven prepended by the last mod 97 operation converted
   //to a string
   int segstart = 0 ;
   int step = 9 ;
   std::string prepended ;
   long number = 0 ;
   while ( segstart  < numberstring.length( ) - step ) {
      number = std::stol( prepended + numberstring.substr( segstart , step ) ) ;
      int remainder = number % 97 ;
      prepended =  std::to_string( remainder ) ;
      if ( remainder < 10 )
	 prepended = "0" + prepended ;
      segstart = segstart + step ;
      step = 7 ;
   }
   number = std::stol( prepended + numberstring.substr( segstart )) ;
   return ( number % 97 == 1 ) ;
}

int main( ) {
   std::cout << "GB82 WEST 1234 5698 7654 32 is " << ( isValid( "GB82 WEST 1234 5698 7654 32" ) ? "" : "not " )
      << "valid!" << std::endl ;
   std::cout << "GB82TEST12345698765432 is " << ( isValid( "GB82TEST12345698765432" ) ? "" : "not " )
	 << "valid!" << std::endl ;
   return 0 ;
}
