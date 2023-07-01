#include <vector>
#include <iostream>
#include <cmath>
#include <utility>
#include <map>
#include <iomanip>

bool isPrime( int i ) {
   int stop = std::sqrt( static_cast<double>( i ) ) ;
   for ( int d = 2 ; d <= stop ; d++ )
      if ( i % d == 0 )
	 return false ;
   return true ;
}

class Compare {
public :
   Compare( ) {
   }

   bool operator( ) ( const std::pair<int , int> & a , const std::pair<int, int> & b ) {
      if ( a.first != b.first )
	 return a.first < b.first ;
      else
	 return a.second < b.second ;
   }
};

int main( ) {
   std::vector<int> primes {2} ;
   int current = 3 ;
   while ( primes.size( ) < 1000000 ) {
      if ( isPrime( current ) )
	 primes.push_back( current ) ;
      current += 2 ;
   }
   Compare myComp ;
   std::map<std::pair<int, int>, int , Compare> conspiracy (myComp) ;
   for ( int i = 0 ; i < primes.size( ) -1 ; i++ ) {
      int a = primes[i] % 10 ;
      int b = primes[ i + 1 ] % 10 ;
      std::pair<int , int> numbers { a , b} ;
      conspiracy[numbers]++ ;
   }
   std::cout << "1000000 first primes. Transitions prime % 10 → next-prime % 10.\n" ;
   for ( auto it = conspiracy.begin( ) ; it != conspiracy.end( ) ; it++ ) {
      std::cout << (it->first).first << " -> " << (it->first).second << " count:" ;
      int frequency = it->second ;
      std::cout << std::right << std::setw( 15 ) << frequency << " frequency: " ;
      std::cout.setf(std::ios::fixed, std::ios::floatfield ) ;
      std::cout.precision( 2 ) ;
      std::cout << (static_cast<double>(frequency) / 1000000.0) * 100 << " %\n" ;
   }
   return 0 ;
}
