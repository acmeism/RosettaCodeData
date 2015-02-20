#include <iostream>
#include <boost/date_time/gregorian/gregorian.hpp>
#include <cstdlib>

int main( int argc , char* argv[ ] ) {
   using namespace boost::gregorian ;

   int year =  std::atoi( argv[ 1 ] ) ;
   for ( int i = 1 ; i < 13 ; i++ ) {
      try {
	 date d( year , i , 1  ) ;
	 d = d.end_of_month( ) ;
	 day_iterator d_itr ( d ) ;
	 while ( d_itr->day_of_week( ) != Sunday ) {
	    --d_itr ;
	 }
	 std::cout << to_simple_string ( *d_itr ) << std::endl ;
      } catch ( bad_year by ) {
	  std::cout << "Terminated because of " << by.what( ) << "\n" ;
      }
   }
   return 0 ;
}
