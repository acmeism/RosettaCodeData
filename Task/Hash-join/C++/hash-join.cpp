#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>

using tab_t = std::vector<std::vector<std::string>>;
tab_t tab1 {
// Age  Name
  {"27", "Jonah"}
, {"18", "Alan"}
, {"28", "Glory"}
, {"18", "Popeye"}
, {"28", "Alan"}
};

tab_t tab2 {
// Character  Nemesis
  {"Jonah", "Whales"}
, {"Jonah", "Spiders"}
, {"Alan", "Ghosts"}
, {"Alan", "Zombies"}
, {"Glory", "Buffy"}
};

std::ostream& operator<<(std::ostream& o, const tab_t& t) {
  for(size_t i = 0; i < t.size(); ++i) {
    o << i << ":";
    for(const auto& e : t[i])
      o << '\t' << e;
    o << std::endl;
  }
  return o;
}

tab_t Join(const tab_t& a, size_t columna, const tab_t& b, size_t columnb) {
  std::unordered_multimap<std::string, size_t> hashmap;
  // hash
  for(size_t i = 0; i < a.size(); ++i) {
    hashmap.insert(std::make_pair(a[i][columna], i));
  }
  // map
  tab_t result;
  for(size_t i = 0; i < b.size(); ++i) {
    auto range = hashmap.equal_range(b[i][columnb]);
    for(auto it = range.first; it != range.second; ++it) {
      tab_t::value_type row;
      row.insert(row.end() , a[it->second].begin() , a[it->second].end());
      row.insert(row.end() , b[i].begin()          , b[i].end());
      result.push_back(std::move(row));
    }
  }
  return result;
}

int main(int argc, char const *argv[])
{
  using namespace std;
  int ret = 0;
  cout << "Table A: "       << endl << tab1 << endl;
  cout << "Table B: "       << endl << tab2 << endl;
  auto tab3 = Join(tab1, 1, tab2, 0);
  cout << "Joined tables: " << endl << tab3 << endl;
  return ret;
}
