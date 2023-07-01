#include <map>
#include <set>

bool happy(int number) {
  static std::map<int, bool> cache;

  std::set<int> cycle;
  while (number != 1 && !cycle.count(number)) {
    if (cache.count(number)) {
      number = cache[number] ? 1 : 0;
      break;
    }
    cycle.insert(number);
    int newnumber = 0;
    while (number > 0) {
      int digit = number % 10;
      newnumber += digit * digit;
      number /= 10;
    }
    number = newnumber;
  }
  bool happiness = number == 1;
  for (std::set<int>::const_iterator it = cycle.begin();
       it != cycle.end(); it++)
    cache[*it] = happiness;
  return happiness;
}

#include <iostream>

int main() {
  for (int i = 1; i < 50; i++)
    if (happy(i))
      std::cout << i << std::endl;
  return 0;
}
