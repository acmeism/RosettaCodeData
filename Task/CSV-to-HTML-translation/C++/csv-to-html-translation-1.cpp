#include <string>
#include <boost/regex.hpp>
#include <iostream>

std::string csvToHTML( const std::string & ) ;

int main( ) {
   std::string text = "Character,Speech\n"
                            "The multitude,The messiah! Show us the messiah!\n"
			    "Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>\n"
	                    "The multitude,Who are you?\n"
		            "Brians mother,I'm his mother; that's who!\n"
		            "The multitude,Behold his mother! Behold his mother!\n" ;
  std::cout << csvToHTML( text ) ;
  return 0 ;
}

std::string csvToHTML( const std::string & csvtext ) {
   //the order of the regexes and the replacements is decisive!
   std::string regexes[ 5 ] = { "<" , ">" , "^(.+?)\\b" , "," , "\n" } ;
   const char* replacements [ 5 ] = { "&lt;" , "&gt;" , "    <TR><TD>$1" , "</TD><TD>", "</TD></TR>\n"  } ;
   boost::regex e1( regexes[ 0 ] ) ;
   std::string tabletext = boost::regex_replace( csvtext , e1 ,
     replacements[ 0 ] , boost::match_default | boost::format_all ) ;
   for ( int i = 1 ; i < 5 ; i++ ) {
      e1.assign( regexes[ i ] ) ;
      tabletext = boost::regex_replace( tabletext , e1 , replacements[ i ] , boost::match_default | boost::format_all ) ;
   }
   tabletext = std::string( "<TABLE>\n" ) + tabletext ;
   tabletext.append( "</TABLE>\n" ) ;
   return tabletext ;
}
