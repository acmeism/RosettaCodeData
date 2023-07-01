#include <algorithm>
#include <random>
#include <vector>
#include <iostream>
#include <numeric>
#include <iomanip>
using VecIt = std::vector<int>::const_iterator ;

//creates vector of length n, based on probability p for 1
std::vector<int> createVector( int n, double p ) {
   std::vector<int> result( n ) ;
   std::random_device rd ;
   std::mt19937 gen( rd( ) ) ;
   std::uniform_real_distribution<> dis( 0 , 1 ) ;
   for ( int i = 0 ; i < n ; i++ ) {
      double number = dis( gen ) ;
      if ( number <= p )
	 result[ i ] = 1 ;
      else
	 result[ i ] = 0 ;
   }
   return result ;
}

//find number of 1 runs in the vector
int find_Runs( const std::vector<int> & numberVector ) {
   int runs = 0 ;
   VecIt found = numberVector.begin( ) ;
   while ( ( found = std::find( found , numberVector.end( ) , 1 ) )
	 != numberVector.end( ) ) {
      runs++ ;
      while ( found != numberVector.end( ) && ( *found == 1 ) )
	 std::advance( found , 1 ) ;
      if ( found == numberVector.end( ) )
	 break ;
   }
   return runs ;
}

int main( ) {
   std::cout << "t = 100\n" ;
   std::vector<double> p_values { 0.1 , 0.3 , 0.5 , 0.7 , 0.9 } ;
   for ( double p : p_values ) {
      std::cout << "p = " << p << " , K(p) = " << p * ( 1 - p ) << std::endl ;
      for ( int n = 10 ; n < 100000 ; n *= 10 ) {
	 std::vector<double> runsFound ;
	 for ( int i = 0 ; i < 100 ; i++ ) {
	    std::vector<int> ones_and_zeroes = createVector( n , p ) ;
	    runsFound.push_back( find_Runs( ones_and_zeroes ) / static_cast<double>( n ) ) ;
	 }
	 double average = std::accumulate( runsFound.begin( ) , runsFound.end( ) , 0.0 ) / runsFound.size( ) ;
	 std::cout << "  R(" << std::setw( 6 ) << std::right << n << ", p) = " << average << std::endl ;
      }
   }
   return 0 ;
}
