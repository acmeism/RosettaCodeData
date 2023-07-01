//to cope with the big numbers , I used the Class Library for Numbers( CLN )
//if used prepackaged you can compile writing "g++ -std=c++11 -lcln yourprogram.cpp -o yourprogram"
#include <cln/integer.h>
#include <cln/integer_io.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <iomanip>
#include <sstream>
#include <string>
#include <cstdlib>
#include <cmath>
#include <map>
using namespace cln ;

class NextNum {
public :
   NextNum ( cl_I & a , cl_I & b ) : first( a ) , second ( b ) { }
   cl_I operator( )( ) {
      cl_I result = first + second ;
      first = second ;
      second = result ;
      return result ;
   }
private :
   cl_I first ;
   cl_I second ;
} ;

void findFrequencies( const std::vector<cl_I> & fibos , std::map<int , int> &numberfrequencies  ) {
   for ( cl_I bignumber : fibos ) {
      std::ostringstream os ;
      fprintdecimal ( os , bignumber ) ;//from header file cln/integer_io.h
      int firstdigit = std::atoi( os.str( ).substr( 0 , 1 ).c_str( )) ;
      auto result = numberfrequencies.insert( std::make_pair( firstdigit , 1 ) ) ;
      if ( ! result.second )
	 numberfrequencies[ firstdigit ]++ ;
   }
}

int main( ) {
   std::vector<cl_I> fibonaccis( 1000 ) ;
   fibonaccis[ 0 ] = 0 ;
   fibonaccis[ 1 ] = 1 ;
   cl_I a = 0 ;
   cl_I b = 1 ;
   //since a and b are passed as references to the generator's constructor
   //they are constantly changed !
   std::generate_n( fibonaccis.begin( ) + 2 , 998 , NextNum( a , b ) ) ;
   std::cout << std::endl ;
   std::map<int , int> frequencies ;
   findFrequencies( fibonaccis , frequencies ) ;
   std::cout << "                found                    expected\n" ;
   for ( int i = 1 ; i < 10 ; i++ ) {
      double found = static_cast<double>( frequencies[ i ] ) / 1000 ;
      double expected = std::log10( 1 + 1 / static_cast<double>( i )) ;
      std::cout << i << " :" << std::setw( 16 ) << std::right << found * 100 << " %" ;
      std::cout.precision( 3 ) ;
      std::cout << std::setw( 26 ) << std::right << expected * 100 << " %\n" ;
   }
   return 0 ;
}
