#include <map>
#include <string>

int
main( int argc, char* argv[] )
{
 std::string keys[] = { "1", "2", "3" } ;
 std::string vals[] = { "a", "b", "c" } ;

 std::map< std::string, std::string > hash ;

 for( int i = 0 ; i < 3 ; i++ )
 {
  hash[ keys[i] ] = vals[i] ;
 }
}
