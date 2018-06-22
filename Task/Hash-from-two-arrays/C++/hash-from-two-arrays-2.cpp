#include <range/v3/view/zip.hpp>
#include <unordered_map>
#include <string>

int main()
{
  std::string keys[] = { "1", "2", "3" };
  std::string vals[] = { "foo", "bar", "baz" };

  std::unordered_map<std::string, std::string> hash(ranges::view::zip(keys, vals));
}
