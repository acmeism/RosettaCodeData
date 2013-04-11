#include <map>       // for std::map
#include <algorithm> // for std::transform
#include <string>    // for std::string
#include <utility>   // for std::make_pair

int main()
{
  std::string keys[] = { "one", "two", "three" };
  std::string vals[] = { "foo", "bar", "baz" };

  std::map<std::string, std::string> hash;

  std::transform(keys, keys+3,
                 vals,
                 std::inserter(hash, hash.end()),
                 std::make_pair<std::string, std::string>);
}
