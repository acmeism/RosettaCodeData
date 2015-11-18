#include <vector>
#include <iostream>

int sumDigits ( int number ) {
   int sum = 0 ;
   while ( number != 0 ) {
      sum += number % 10 ;
      number /= 10 ;
   }
   return sum ;
}

bool isHarshad ( int number ) {
   return number % ( sumDigits ( number ) ) == 0 ;
}

int main( ) {
   std::vector<int> harshads ;
   int i = 0 ;
   while ( harshads.size( ) != 20 ) {
      i++ ;
      if ( isHarshad ( i ) )
	 harshads.push_back( i ) ;
   }
   std::cout << "The first 20 Harshad numbers:\n" ;
   for ( int number : harshads )
      std::cout << number << " " ;
   std::cout << std::endl ;
   int start = 1001 ;
   while ( ! ( isHarshad ( start ) ) )
      start++ ;
   std::cout << "The smallest Harshad number greater than 1000 : " << start << '\n' ;
   return 0 ;
}
