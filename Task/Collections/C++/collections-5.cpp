#include <set>

std::set<int> s;          // empty set
s.insert(5);              // insert a 5
s.insert(7);              // insert a 7 (automatically placed after the 5)
s.insert(5);              // try to insert another 5 (will not change the set)
