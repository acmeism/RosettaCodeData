#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <algorithm>
#include <utility>
#include <sstream>

std::string mostFreqKHashing ( const std::string & input , int k ) {
   std::ostringstream oss ;
   std::map<char, int> frequencies ;
   for ( char c : input ) {
      frequencies[ c ] = std::count ( input.begin( ) , input.end( ) , c ) ;
   }
   std::vector<std::pair<char , int>> letters ( frequencies.begin( ) , frequencies.end( ) ) ;
   std::sort ( letters.begin( ) , letters.end( ) , [input] ( std::pair<char, int> a ,
	         std::pair<char, int> b ) { char fc = std::get<0>( a ) ; char fs = std::get<0>( b ) ;
	         int o = std::get<1>( a ) ; int p = std::get<1>( b ) ; if ( o != p ) { return o > p ; }
	         else { return input.find_first_of( fc ) < input.find_first_of ( fs ) ; } } ) ;
   for ( int i = 0 ; i < letters.size( ) ; i++ ) {
      oss << std::get<0>( letters[ i ] ) ;
      oss << std::get<1>( letters[ i ] ) ;
   }
   std::string output ( oss.str( ).substr( 0 , 2 * k ) ) ;
   if ( letters.size( ) >= k ) {
      return output ;
   }
   else {
      return output.append( "NULL0" ) ;
   }
}

int mostFreqKSimilarity ( const std::string & first , const std::string & second ) {
   int i = 0 ;
   while ( i < first.length( ) - 1  ) {
      auto found = second.find_first_of( first.substr( i , 2 ) ) ;
      if ( found != std::string::npos )
	 return std::stoi ( first.substr( i , 2 )) ;
      else
	 i += 2 ;
   }
   return 0 ;
}

int mostFreqKSDF ( const std::string & firstSeq , const std::string & secondSeq , int num ) {
   return mostFreqKSimilarity ( mostFreqKHashing( firstSeq , num ) , mostFreqKHashing( secondSeq , num ) ) ;
}

int main( ) {
   std::string s1("LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV" ) ;
   std::string s2( "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG" ) ;
   std::cout << "MostFreqKHashing( s1 , 2 ) = " << mostFreqKHashing( s1 , 2 ) << '\n' ;
   std::cout << "MostFreqKHashing( s2 , 2 ) = " << mostFreqKHashing( s2 , 2 ) << '\n' ;
   return 0 ;
}
