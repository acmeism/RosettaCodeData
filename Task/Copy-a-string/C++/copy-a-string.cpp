#include <iostream>
#include <string>
#include <algorithm>

int main( ) {
   std::string original ( "This is the original" ) ;
   std::string mycopy( original.length( ) , ' ' ) ;
   std::copy ( original.begin( ) , original.end( ) , mycopy.begin( ) ) ;
   std::cout << "This is the copy: " << mycopy << std::endl ;
   original.assign( "Now we change the original! " ) ;
   std::cout << "mycopy still is " << mycopy << std::endl ;
   return 0 ;
}
