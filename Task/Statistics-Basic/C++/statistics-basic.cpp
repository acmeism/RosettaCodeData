#include <iostream>
#include <random>
#include <vector>
#include <cstdlib>
#include <algorithm>
#include <cmath>

void printStars ( int number ) {
   if ( number > 0 ) {
      for ( int i = 0 ; i < number + 1 ; i++ )
	 std::cout << '*' ;
   }
   std::cout << '\n' ;
}

int main( int argc , char *argv[] ) {
   const int numberOfRandoms = std::atoi( argv[1] ) ;
   std::random_device rd ;
   std::mt19937 gen( rd( ) ) ;
   std::uniform_real_distribution<> distri( 0.0 , 1.0 ) ;
   std::vector<double> randoms ;
   for ( int i = 0 ; i < numberOfRandoms + 1 ; i++ )
      randoms.push_back ( distri( gen ) ) ;
   std::sort ( randoms.begin( ) , randoms.end( ) ) ;
   double start = 0.0 ;
   for ( int i = 0 ;  i < 9 ; i++ ) {
      double to = start + 0.1 ;
      int howmany =  std::count_if ( randoms.begin( ) , randoms.end( ),
	        [&start , &to] ( double c ) { return c >= start
		  && c < to ; } ) ;
      if ( start == 0.0 ) //double 0.0 output as 0
	 std::cout << "0.0" << " - " << to << ": " ;
      else
	 std::cout << start << " - " << to << ": " ;
      if ( howmany > 50 ) //scales big interval numbers to printable length
	 howmany = howmany / ( howmany / 50 ) ;
      printStars ( howmany ) ;
      start += 0.1 ;
   }
   double mean = std::accumulate( randoms.begin( ) , randoms.end( ) , 0.0 ) / randoms.size( ) ;
   double sum = 0.0 ;
   for ( double num : randoms )
      sum += std::pow( num - mean , 2 ) ;
   double stddev = std::pow( sum / randoms.size( ) , 0.5 ) ;
   std::cout << "The mean is " << mean << " !" << std::endl ;
   std::cout << "Standard deviation is " << stddev << " !" << std::endl ;
   return 0 ;
}
