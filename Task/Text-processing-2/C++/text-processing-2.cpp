#include <boost/regex.hpp>
#include <fstream>
#include <iostream>
#include <vector>
#include <string>
#include <set>
#include <cstdlib>
#include <algorithm>
using namespace std ;

boost::regex e ( "\\s+" ) ;

int main( int argc , char *argv[ ] ) {
   ifstream infile( argv[ 1 ] ) ;
   vector<string> duplicates ;
   set<string> datestamps ; //for the datestamps
   if ( ! infile.is_open( ) ) {
      cerr << "Can't open file " << argv[ 1 ] << '\n' ;
      return 1 ;
   }
   int all_ok = 0  ;//all_ok for lines in the given pattern e
   int pattern_ok = 0 ; //overall field pattern of record is ok
   while ( infile ) {
      string eingabe ;
      getline( infile , eingabe ) ;
      boost::sregex_token_iterator i ( eingabe.begin( ), eingabe.end( ) , e , -1 ), j  ;//we tokenize on empty fields
      vector<string> fields( i, j ) ;
      if ( fields.size( ) == 49 ) //we expect 49 fields in a record
         pattern_ok++ ;
      else
         cout << "Format not ok!\n" ;
      if ( datestamps.insert( fields[ 0 ] ).second ) { //not duplicated
         int howoften = ( fields.size( ) - 1 ) / 2 ;//number of measurement
                                                    //devices and values
         for ( int n = 1 ; atoi( fields[ 2 * n ].c_str( ) ) >= 1 ; n++ ) {
            if ( n == howoften ) {
               all_ok++ ;
               break ;
            }
         }
      }
      else {
         duplicates.push_back( fields[ 0 ] ) ;//first field holds datestamp
      }
   }
   infile.close( ) ;
   cout << "The following " << duplicates.size() << " datestamps were duplicated:\n" ;
   copy( duplicates.begin( ) , duplicates.end( ) ,
         ostream_iterator<string>( cout , "\n" ) ) ;
   cout << all_ok << " records were complete and ok!\n" ;
   return 0 ;
}
