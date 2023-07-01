#include <string>
#include <iostream>

std::string repeat( const std::string &word, uint times ) {
  return
    times == 0 ? "" :
    times == 1 ? word :
    times == 2 ? word + word :
    repeat(repeat(word, times / 2), 2) +
    repeat(word, times % 2);
}

int main( ) {
   std::cout << repeat( "Ha" , 5 ) << std::endl ;
   return 0 ;
}
