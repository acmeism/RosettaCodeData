#include <iostream>

int main( ) {
   int current = 0 ;
   while ( ( current * current ) % 1000000 != 269696 )
      current++ ;
   std::cout << "The square of " << current << " is " << (current * current) << " !\n" ;
   return 0 ;
}
