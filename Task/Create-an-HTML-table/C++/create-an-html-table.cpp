#include <fstream>
#include <boost/array.hpp>
#include <string>
#include <cstdlib>
#include <ctime>
#include <sstream>

void makeGap( int gap , std::string & text ) {
   for ( int i = 0 ; i < gap ; i++ )
      text.append( " " ) ;
}

int main( ) {
   boost::array<char , 3> chars = { 'X' , 'Y' , 'Z' } ;
   int headgap = 3 ;
   int bodygap = 3 ;
   int tablegap = 6 ;
   int rowgap = 9 ;
   std::string tabletext( "<html>\n" ) ;
   makeGap( headgap , tabletext ) ;
   tabletext += "<head></head>\n" ;
   makeGap( bodygap , tabletext ) ;
   tabletext += "<body>\n" ;
   makeGap( tablegap , tabletext ) ;
   tabletext += "<table>\n" ;
   makeGap( tablegap + 1 , tabletext ) ;
   tabletext += "<thead align=\"right\">\n" ;
   makeGap( tablegap, tabletext ) ;
   tabletext += "<tr><th></th>" ;
   for ( int i = 0 ; i < 3 ; i++ ) {
      tabletext += "<td>" ;
      tabletext += *(chars.begin( ) + i ) ;
      tabletext += "</td>" ;
   }
   tabletext += "</tr>\n" ;
   makeGap( tablegap + 1 , tabletext ) ;
   tabletext += "</thead>" ;
   makeGap( tablegap + 1 , tabletext ) ;
   tabletext += "<tbody align=\"right\">\n" ;
   srand( time( 0 ) ) ;
   for ( int row = 0 ; row < 5 ; row++ ) {
      makeGap( rowgap , tabletext ) ;
      std::ostringstream oss ;
      tabletext += "<tr><td>" ;
      oss << row ;
      tabletext += oss.str( ) ;
      for ( int col = 0 ; col < 3 ; col++ ) {
	 oss.str( "" ) ;
	 int randnumber = rand( ) % 10000 ;
	 oss << randnumber ;
	 tabletext += "<td>" ;
	 tabletext.append( oss.str( ) ) ;
	 tabletext += "</td>" ;
      }
      tabletext += "</tr>\n" ;
   }
   makeGap( tablegap + 1 , tabletext ) ;
   tabletext += "</tbody>\n" ;
   makeGap( tablegap , tabletext ) ;
   tabletext += "</table>\n" ;
   makeGap( bodygap , tabletext ) ;
   tabletext += "</body>\n" ;
   tabletext += "</html>\n" ;
   std::ofstream htmltable( "testtable.html" , std::ios::out | std::ios::trunc ) ;
   htmltable << tabletext ;
   htmltable.close( ) ;
   return 0 ;
}
