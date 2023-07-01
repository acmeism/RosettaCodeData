#include <iostream>
#include <vector>
#include <iterator>

class Hofstadter
{
public:
  static int F(int n) {
    if ( n == 0 ) return 1;
    return n - M(F(n-1));
  }
  static int M(int n) {
    if ( n == 0 ) return 0;
    return n - F(M(n-1));
  }
};

using namespace std;

int main()
{
  int i;
  vector<int> ra, rb;

  for(i=0; i < 20; i++) {
    ra.push_back(Hofstadter::F(i));
    rb.push_back(Hofstadter::M(i));
  }
  copy(ra.begin(), ra.end(),
       ostream_iterator<int>(cout, " "));
  cout << endl;
  copy(rb.begin(), rb.end(),
       ostream_iterator<int>(cout, " "));
  cout << endl;
  return 0;
}
