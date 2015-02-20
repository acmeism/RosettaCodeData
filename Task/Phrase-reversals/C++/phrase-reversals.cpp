#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <boost/tokenizer.hpp>

void string_to_vector ( const std::string & input , std::vector<std::string> & words ) {
   boost::tokenizer<> tok( input ) ;
   for ( boost::tokenizer<>::iterator beg = tok.begin( ) ; beg != tok.end( ) ; ++beg )
      words.push_back( *beg ) ;
}

int main( ) {
   std::string startphrase ( "rosetta code phrase reversal" ) ;
   std::cout << "Input : " << startphrase << '\n' ;
   std::string local_copy ( startphrase ) ;
   std::reverse ( local_copy.begin( ) , local_copy.end( ) ) ;
   std::cout << "Input reversed : " << local_copy << '\n' ;
   std::vector<std::string> words ;
   string_to_vector ( startphrase , words ) ;
   //copy the vector with the original words to reverse their order later
   std::vector<std::string> original_words ( words ) ;
   //reverse each word in the string
   std::cout << "Each word reversed : " ;
   for ( std::string word : words ) {
      std::reverse ( word.begin( ) , word.end( ) ) ;
      std::cout << word << " " ;
   }
   std::cout << '\n' ;
   std::cout << "Original word order reversed : " ;
   for ( std::vector<std::string>::const_reverse_iterator cri = original_words.rbegin( ) ;
	 cri != original_words.rend( ) ; cri++ ) {
      std::cout << *cri << " " ;
   }
   std::cout << '\n' ;
   return 0 ;
}
