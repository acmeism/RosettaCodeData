#include <set>
#include <algorithm>
#include <string>
#include <iostream>
#include <vector>
#include <numeric>

std::set<std::string> createPrefixes ( const std::string & s ) {
   std::set<std::string> result ;
   for ( int i = 1 ; i < s.size( ) + 1 ; i++ )
      result.insert( s.substr( 0 , i )) ;
   return result ;
}

std::set<std::string> findIntersection ( const std::set<std::string> & a ,
      const std::set<std::string> & b ) {
   std::set<std::string> intersection ;
   std::set_intersection( a.begin( ) , a.end( ) , b.begin( ) , b.end( ) ,
	 std::inserter ( intersection , intersection.begin( ) ) ) ;
   return intersection  ;
}

std::set<std::string> findCommonPrefixes( const std::vector<std::string> & theStrings ) {
   std::set<std::string> result ;
   if ( theStrings.size( ) == 1 ) {
      result.insert( *(theStrings.begin( ) ) ) ;
   }
   if ( theStrings.size( ) > 1 ) {
      std::vector<std::set<std::string>> prefixCollector ;
      for ( std::string s : theStrings )
	 prefixCollector.push_back( createPrefixes ( s ) ) ;
      std::set<std::string> neutralElement (createPrefixes( *(theStrings.begin( ) ) )) ;
      result = std::accumulate( prefixCollector.begin( ) , prefixCollector.end( ) ,
	    neutralElement , findIntersection ) ;
   }
   return result ;
}

std::string lcp( const std::vector<std::string> & allStrings ) {
   if ( allStrings.size( ) == 0 )
      return "" ;
   if ( allStrings.size( ) == 1 ) {
      return allStrings[ 0 ] ;
   }
   if ( allStrings.size( ) > 1 ) {
      std::set<std::string> prefixes( findCommonPrefixes ( allStrings ) ) ;
      if ( prefixes.empty( ) )
	 return "" ;
      else {
	 std::vector<std::string> common ( prefixes.begin( ) , prefixes.end( ) ) ;
	 std::sort( common.begin( ) , common.end( ) , [] ( const std::string & a,
		  const std::string & b ) { return a.length( ) > b.length( ) ; } ) ;
	 return *(common.begin( ) ) ;
      }
   }
}

int main( ) {
   std::vector<std::string> input { "interspecies" , "interstellar" , "interstate" } ;
   std::cout << "lcp(\"interspecies\",\"interstellar\",\"interstate\") = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "throne" ) ;
   input.push_back ( "throne" ) ;
   std::cout << "lcp( \"throne\" , \"throne\"" << ") = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "cheese" ) ;
   std::cout << "lcp( \"cheese\" ) = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   std::cout << "lcp(\"\") = " << lcp ( input ) << std::endl ;
   input.push_back( "prefix" ) ;
   input.push_back( "suffix" ) ;
   std::cout << "lcp( \"prefix\" , \"suffix\" ) = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "foo" ) ;
   input.push_back( "foobar" ) ;
   std::cout << "lcp( \"foo\" , \"foobar\" ) = " << lcp ( input ) << std::endl ;
   return 0 ;
}
