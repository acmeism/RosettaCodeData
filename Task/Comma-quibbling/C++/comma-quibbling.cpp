#include <iostream>

template<class T>
void quibble(std::ostream& o, T i, T e) {
  o << "{";
  if (e != i) {
    T n = i++;
    const char* more = "";
    while (e != i) {
      o << more << *n;
      more = ", ";
      n = i++;
    }
    o << (*more?" and ":"") << *n;
  }
  o << "}";
}

int main(int argc, char** argv) {
  char const* a[] = {"ABC","DEF","G","H"};
  for (int i=0; i<5; i++) {
    quibble(std::cout, a, a+i);
    std::cout << std::endl;
  }
  return 0;
}
