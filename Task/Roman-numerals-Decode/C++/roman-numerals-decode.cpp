#include <iostream>
#include <string>
#include <algorithm>
#include <map>

static std::map<char , int> Romans;

int RomanToInt( const std::string &roman ) {
   int number = 0 ;
   // look for all the letters in the array
   for ( std::string::const_iterator i = roman.begin( ) ; i != roman.end( ) ; i++ ) {
      std::map<char , int>::const_iterator it1 = Romans.find( *i ) ;
      if ( it1 == Romans.end( ) ) {
         std::cerr << *i << " not a valid Roman numeral character." << std::endl ;
         return -1 ;
      }
      int pos1 = it1->second ;
      if ( i + 1 != roman.end( ) ) {
         std::map<char , int>::const_iterator it2 = Romans.find( *( i + 1 ) );
         if ( it2 == Romans.end( ) ) {
            std::cerr << *( i + 1 ) << " not a valid Roman numeral character." << std::endl ;
            return -1 ;
         }
         int pos2 = it2->second ;
         if ( pos2 > pos1 ) {
            number += pos2 - pos1 ;
            i++ ;
            continue ;
         }
      }
      number += pos1 ;
   }
   return number ;
}

int main( ) {
   Romans[ 'I' ] = 1 ;
   Romans[ 'V' ] = 5 ;
   Romans[ 'X' ] = 10 ;
   Romans[ 'L' ] = 50 ;
   Romans[ 'C' ] = 100 ;
   Romans[ 'D' ] = 500 ;
   Romans[ 'M' ] = 1000 ;

   std::cout << "MCMXC in Roman numerals is " << RomanToInt( "MCMXC" ) << " in Arabic!\n" ;
   std::cout << "And MDCLXVI for the Romans is " << RomanToInt( "MDCLXVI" ) << " in better known Arabic figures!\n" ;
   return 0 ;
}
