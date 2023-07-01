include <vector>
#include <algorithm>
#include <string>
#include <iostream>

int main( ) {
   std::vector<std::string> myStrings { "prepended to" , "my string" } ;
   std::string prepended = std::accumulate( myStrings.begin( ) ,
	 myStrings.end( ) , std::string( "" ) , []( std::string a ,
	    std::string b ) { return a + b ; } ) ;
   std::cout << prepended << std::endl ;
   return 0 ;
}
