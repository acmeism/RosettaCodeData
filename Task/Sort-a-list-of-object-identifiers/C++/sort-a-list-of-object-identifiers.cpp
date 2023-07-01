#include <string>
#include <vector>
#include <algorithm>
#include <boost/tokenizer.hpp>
#include <iostream>

std::vector<std::string> splitOnChar ( std::string & s , const char c ) {
   typedef boost::tokenizer<boost::char_separator<char>> tokenizer ;
   std::vector<std::string> parts ;
   boost::char_separator<char> sep( &c ) ;
   tokenizer tokens( s , sep ) ;
   for ( auto it = tokens.begin( ) ; it != tokens.end( ) ; it++ )
      parts.push_back( *it ) ;
   return parts ;
}

bool myCompare ( const std::string & s1 , const std::string & s2 ) {
   std::string firstcopy( s1 ) ;
   std::string secondcopy ( s2 ) ;
   std::vector<std::string> firstparts( splitOnChar ( firstcopy, '.' ) ) ;
   std::vector<std::string> secondparts( splitOnChar ( secondcopy, '.' ) ) ;
   std::vector<int> numbers1( firstparts.size( ) ) ;
   std::vector<int> numbers2( secondparts.size( ) ) ;
   std::transform( firstparts.begin( ) , firstparts.end( ) , numbers1.begin( ) ,
	 []( std::string st ) { return std::stoi( st , nullptr ) ; } ) ;
   std::transform( secondparts.begin( ) , secondparts.end( ) , numbers2.begin( ) ,
	 []( std::string st ) { return std::stoi( st , nullptr ) ; } ) ;
   auto it1 = numbers1.begin( ) ;
   auto it2 = numbers2.begin( ) ;
   while ( *it1 == *it2 ) {
      it1++ ;
      it2++ ;
   }
   if ( it1 == numbers1.end( )  || it2 == numbers2.end( )  )
      return std::lexicographical_compare( s1.begin( ) , s1.end( ) , s2.begin( ) , s2.end( ) ) ;
   return *it1 < *it2 ;
}

int main( ) {
   std::vector<std::string> arrayOID { "1.3.6.1.4.1.11.2.17.19.3.4.0.10" ,
      "1.3.6.1.4.1.11.2.17.5.2.0.79" ,
      "1.3.6.1.4.1.11.2.17.19.3.4.0.4" ,
      "1.3.6.1.4.1.11150.3.4.0.1" ,
      "1.3.6.1.4.1.11.2.17.19.3.4.0.1" ,
      "1.3.6.1.4.1.11150.3.4.0" } ;
   std::sort( arrayOID.begin( ) , arrayOID.end( ) , myCompare ) ;
   for ( std::string s : arrayOID )
      std::cout << s << '\n' ;
   return 0 ;
}
