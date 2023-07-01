#include <multiset>

std::multiset<int> m;     // empty multiset
m.insert(5);              // insert a 5
m.insert(7);              // insert a 7 (automatically placed after the 5)
m.insert(5);              // insert a second 5 (now m contains two 5s, followed by one 7)
