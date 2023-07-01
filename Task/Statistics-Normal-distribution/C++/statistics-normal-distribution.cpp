#include <random>
#include <map>
#include <string>
#include <iostream>
#include <cmath>
#include <iomanip>

int main( ) {
   std::random_device myseed ;
   std::mt19937 engine ( myseed( ) ) ;
   std::normal_distribution<> normDistri ( 2 , 3 ) ;
   std::map<int , int> normalFreq ;
   int sum = 0 ; //holds the sum of the randomly created numbers
   double mean = 0.0 ;
   double stddev = 0.0 ;
   for ( int i = 1 ; i < 10001 ; i++ )
      ++normalFreq[ normDistri ( engine ) ] ;
   for ( auto MapIt : normalFreq ) {
      sum += MapIt.first * MapIt.second ;
   }
   mean = sum / 10000 ;
   stddev = sqrt( sum / 10000 ) ;
   std::cout << "The mean of the distribution is " << mean << " , the " ;
   std::cout << "standard deviation " << stddev << " !\n" ;
   std::cout << "And now the histogram:\n" ;
   for ( auto MapIt : normalFreq ) {
      std::cout << std::left << std::setw( 4 ) << MapIt.first <<
	 std::string( MapIt.second / 100 , '*' ) << std::endl ;
   }
   return 0 ;
}
