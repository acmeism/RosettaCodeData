#include <iostream>
#include <cctype>
#include <functional>

using namespace std;

bool odd()
{
  function<void ()> prev = []{};
  while(true) {
    int c = cin.get();
    if (!isalpha(c)) {
      prev();
      cout.put(c);
      return c != '.';
    }
    prev = [=] { cout.put(c); prev();  };
  }
}

bool even()
{
  while(true) {
    int c;
    cout.put(c = cin.get());
    if (!isalpha(c)) return c != '.';
  }
}


int main()
{
  bool e = false;
  while( e ? odd() : even() ) e = !e;
  return 0;
}
