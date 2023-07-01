#include <fstream>
#include <string>
#include <iostream>

int main( int argc , char** argv ) {
   int linecount = 0 ;
   std::string line  ;
   std::ifstream infile( argv[ 1 ] ) ; // input file stream
   if ( infile ) {
      while ( getline( infile , line ) ) {
	 std::cout << linecount << ": "
                   << line      << '\n' ;  //supposing '\n' to be line end
	 linecount++ ;
      }
   }
   infile.close( ) ;
   return 0 ;
}
