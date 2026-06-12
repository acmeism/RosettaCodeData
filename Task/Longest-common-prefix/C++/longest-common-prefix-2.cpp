#include <algorithm>
#include <string>
#include <iostream>
#include <vector>

std::string lcp( const std::vector<std::string> & allStrings ) {
	if (allStrings.empty()) return std::string();
	const std::string &s0 = allStrings.front();
	auto end = s0.cend();
	for(auto it=std::next(allStrings.cbegin()); it != allStrings.cend(); it++){
		auto loc = std::mismatch(s0.cbegin(), s0.cend(), it->cbegin(), it->cend());
		if (std::distance(loc.first, end)>0) end = loc.first;
	}
	return std::string(s0.cbegin(), end);
}

int main( ) {
   std::vector<std::string> input { "interspecies" , "interstellar" , "interstate" } ;
   std::cout << "lcp(\"interspecies\",\"interstellar\",\"interstate\") = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "throne" ) ;
   input.push_back ( "throne" ) ;
   std::cout << "lcp( \"throne\" , \"throne\"" << ") = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "cheese" ) ;
   std::cout << "lcp( \"cheese\" ) = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   std::cout << "lcp(\"\") = " << lcp ( input ) << std::endl ;
   input.push_back( "prefix" ) ;
   input.push_back( "suffix" ) ;
   std::cout << "lcp( \"prefix\" , \"suffix\" ) = " << lcp ( input ) << std::endl ;
   input.clear( ) ;
   input.push_back( "foo" ) ;
   input.push_back( "foobar" ) ;
   std::cout << "lcp( \"foo\" , \"foobar\" ) = " << lcp ( input ) << std::endl ;
   return 0 ;
}
