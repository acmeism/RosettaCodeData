#include <vector>
#include <algorithm>
#include <iterator>
#include <iostream>

using namespace std;

int main() {
  vector<int> ary = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  vector<int> evens;

  copy_if(ary.begin(), ary.end(), back_inserter(evens),
      [](int i) { return i % 2 == 0; });

  // print result
  copy(evens.begin(), evens.end(), ostream_iterator<int>(cout, "\n"));
}
