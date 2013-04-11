#include <string>
#include <iostream>
#include "Poco/SHA1Engine.h"
#include "Poco/DigestStream.h"

using Poco::DigestEngine ;
using Poco::SHA1Engine ;
using Poco::DigestOutputStream ;

int main( ) {
   std::string myphrase ( "Rosetta Code" ) ;
   SHA1Engine sha1 ;
   DigestOutputStream outstr( sha1 ) ;
   outstr << myphrase ;
   outstr.flush( ) ; //to pass everything to the digest engine
   const DigestEngine::Digest& digest = sha1.digest( ) ;
   std::cout << myphrase << " as a sha1 digest :" << DigestEngine::digestToHex( digest )
      << " !" << std::endl ;
   return 0 ;
}
