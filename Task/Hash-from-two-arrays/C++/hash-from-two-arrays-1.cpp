#include <unordered_map>
#include <string>

int main()
{
  std::string keys[] = { "1", "2", "3" };
  std::string vals[] = { "a", "b", "c" };

  std::unordered_map<std::string, std::string> hash;
  for( int i = 0 ; i < 3 ; i++ )
     hash[ keys[i] ] = vals[i] ;
}
