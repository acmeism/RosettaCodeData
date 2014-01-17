#include <iostream>
#include <boost/date_time/posix_time/posix_time.hpp>

int main( ) {
   boost::posix_time::ptime t ( boost::posix_time::second_clock::local_time( ) ) ;
   std::cout << to_simple_string( t ) << std::endl ;
   return 0 ;
}
