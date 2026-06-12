#include <iostream>
#include <iterator>
#include <vector>
#include <utility>
#include <cstdlib>
#include <algorithm>

//supposing example numbers are entered!
int main( ) {
   std::cout << "Enter some doubles, separated by blanks, e to end!\n" ;
   std::vector<double> numbers { std::istream_iterator<double>{ std::cin } ,
      std::istream_iterator<double>{} } ;
   std::vector<std::pair<int , int>> neighbours ;
   for ( int i = 0 ; i < numbers.size( ) - 1 ; i++ )
      neighbours.push_back( std::make_pair( numbers[i] , numbers[ i + 1 ] )) ;
   std::sort( neighbours.begin( ) , neighbours.end( ) , []( auto p1 , auto p2 ) {
         return std::abs( p1.first - p1.second ) > std::abs( p2.first - p2.second )
         ; } ) ;
   double maximum = std::abs( neighbours[0].first - neighbours[0].second ) ;
   int pos = 0 ;
   while ( std::abs(neighbours[pos].first - neighbours[pos].second ) == maximum ) {
      std::cout << neighbours[pos].first << ',' << neighbours[pos].second <<
         " ==> " << maximum << '\n' ;
      pos++ ;
      }
   return 0 ;
}
