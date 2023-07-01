#include <vector>
#include <string>
#include <iostream>
#include <boost/tuple/tuple.hpp>
#include <set>

int findBestPack( const std::vector<boost::tuple<std::string , int , int> > & ,
      std::set<int> & , const int  ) ;

int main( ) {
   std::vector<boost::tuple<std::string , int , int> > items ;
   //===========fill the vector with data====================
   items.push_back( boost::make_tuple( "" , 0  ,  0 ) ) ;
   items.push_back( boost::make_tuple( "map" , 9 , 150 ) ) ;
   items.push_back( boost::make_tuple( "compass" , 13 , 35 ) ) ;
   items.push_back( boost::make_tuple( "water" , 153 , 200 ) ) ;
   items.push_back( boost::make_tuple( "sandwich", 50 , 160 ) ) ;
   items.push_back( boost::make_tuple( "glucose" , 15 , 60 ) ) ;
   items.push_back( boost::make_tuple( "tin", 68 , 45 ) ) ;
   items.push_back( boost::make_tuple( "banana", 27 , 60 ) ) ;
   items.push_back( boost::make_tuple( "apple" , 39 , 40 ) ) ;
   items.push_back( boost::make_tuple( "cheese" , 23 , 30 ) ) ;
   items.push_back( boost::make_tuple( "beer" , 52 , 10 ) ) ;
   items.push_back( boost::make_tuple( "suntan creme" , 11 , 70 ) ) ;
   items.push_back( boost::make_tuple( "camera" , 32 , 30 ) ) ;
   items.push_back( boost::make_tuple( "T-shirt" , 24 , 15 ) ) ;
   items.push_back( boost::make_tuple( "trousers" , 48 , 10 ) ) ;
   items.push_back( boost::make_tuple( "umbrella" , 73 , 40 ) ) ;
   items.push_back( boost::make_tuple( "waterproof trousers" , 42 , 70 ) ) ;
   items.push_back( boost::make_tuple( "waterproof overclothes" , 43 , 75 ) ) ;
   items.push_back( boost::make_tuple( "note-case" , 22 , 80 ) ) ;
   items.push_back( boost::make_tuple( "sunglasses" , 7 , 20 ) ) ;
   items.push_back( boost::make_tuple( "towel" , 18 , 12 ) ) ;
   items.push_back( boost::make_tuple( "socks" , 4 , 50 ) ) ;
   items.push_back( boost::make_tuple( "book" , 30 , 10 ) ) ;
   const int maximumWeight = 400 ;
   std::set<int> bestItems ; //these items will make up the optimal value
   int bestValue = findBestPack( items , bestItems , maximumWeight ) ;
   std::cout << "The best value that can be packed in the given knapsack is " <<
      bestValue << " !\n" ;
   int totalweight = 0 ;
   std::cout << "The following items should be packed in the knapsack:\n" ;
   for ( std::set<int>::const_iterator si = bestItems.begin( ) ;
	 si != bestItems.end( ) ; si++ ) {
      std::cout << (items.begin( ) + *si)->get<0>( ) << "\n" ;
      totalweight += (items.begin( ) + *si)->get<1>( ) ;
   }
   std::cout << "The total weight of all items is " << totalweight << " !\n" ;
   return 0 ;
}

int findBestPack( const std::vector<boost::tuple<std::string , int , int> > & items ,std::set<int> & bestItems , const int weightlimit ) {
   //dynamic programming approach sacrificing storage space for execution
   //time , creating a table of optimal values for every weight and a
   //second table of sets with the items collected so far in the knapsack
   //the best value is in the bottom right corner of the values table,
   //the set of items in the bottom right corner of the sets' table.
   const int n = items.size( ) ;
   int bestValues [ n ][ weightlimit ] ;
   std::set<int> solutionSets[ n ][ weightlimit ] ;
   std::set<int> emptyset ;
   for ( int i = 0 ; i < n ; i++ ) {
      for ( int j = 0 ; j < weightlimit  ; j++ ) {
	 bestValues[ i ][ j ] = 0 ;
	 solutionSets[ i ][ j ] = emptyset ;
       }
    }
    for ( int i = 0 ; i < n ; i++ ) {
       for ( int weight = 0 ; weight < weightlimit ; weight++ ) {
	  if ( i == 0 )
	     bestValues[ i ][ weight ] = 0 ;
	  else  {
	     int itemweight = (items.begin( ) + i)->get<1>( ) ;
	     if ( weight < itemweight ) {
		bestValues[ i ][ weight ] = bestValues[ i - 1 ][ weight ] ;
		solutionSets[ i ][ weight ] = solutionSets[ i - 1 ][ weight ] ;
	     } else { // weight >= itemweight
		if ( bestValues[ i - 1 ][ weight - itemweight ] +
		   (items.begin( ) + i)->get<2>( ) >
		        bestValues[ i - 1 ][ weight ] ) {
		   bestValues[ i ][ weight ] =
		       bestValues[ i - 1 ][ weight - itemweight ] +
	        	(items.begin( ) + i)->get<2>( ) ;
		  solutionSets[ i ][ weight ] =
		      solutionSets[ i - 1 ][ weight - itemweight ] ;
		  solutionSets[ i ][ weight ].insert( i ) ;
	     }
	     else {
		bestValues[ i ][ weight ] = bestValues[ i - 1 ][ weight ] ;
		solutionSets[ i ][ weight ] = solutionSets[ i - 1 ][ weight ] ;
	     }
	  }
       }
      }
    }
    bestItems.swap( solutionSets[ n - 1][ weightlimit - 1 ] ) ;
    return bestValues[ n - 1 ][ weightlimit - 1 ] ;
}
