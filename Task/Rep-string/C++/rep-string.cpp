#include <string>
#include <vector>
#include <boost/regex.hpp>

bool is_repstring( const std::string & teststring , std::string & repunit ) {
   std::string regex( "^(.+)\\1+(.*)$" ) ;
   boost::regex e ( regex ) ;
   boost::smatch what ;
   if ( boost::regex_match( teststring , what , e , boost::match_extra ) ) {
      std::string firstbracket( what[1 ] ) ;
      std::string secondbracket( what[ 2 ] ) ;
      if ( firstbracket.length( ) >= secondbracket.length( ) &&
	    firstbracket.find( secondbracket ) != std::string::npos ) {
	 repunit = firstbracket  ;
      }
   }
   return !repunit.empty( ) ;
}

int main( ) {
   std::vector<std::string> teststrings { "1001110011" , "1110111011" , "0010010010" ,
      "1010101010" , "1111111111" , "0100101101" , "0100100" , "101" , "11" , "00" , "1" } ;
   std::string theRep ;
   for ( std::string myString : teststrings ) {
      if ( is_repstring( myString , theRep ) ) {
	 std::cout << myString << " is a rep string! Here is a repeating string:\n" ;
	 std::cout << theRep << " " ;
      }
      else {
	 std::cout << myString << " is no rep string!" ;
      }
      theRep.clear( ) ;
      std::cout << std::endl ;
   }
   return 0 ;
}
