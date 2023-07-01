#include <list>

std::list<int> l;         // empty list
l.push_back(5);           // insert a 5 at the end
l.push_front(7);          // insert a 7 at the beginning
std::list::iterator i = l.begin();
++l;
l.insert(i, 6);           // insert a 6 in the middle
