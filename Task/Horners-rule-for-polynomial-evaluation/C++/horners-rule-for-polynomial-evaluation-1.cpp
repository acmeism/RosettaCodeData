#include <iostream>
#include <vector>

using namespace std;

double horner(vector<double> v, double x)
{
  double s = 0;

  for( vector<double>::const_reverse_iterator i = v.rbegin(); i != v.rend(); i++ )
    s = s*x + *i;
  return s;
}

int main()
{
  double c[] = { -19, 7, -4, 6 };
  vector<double> v(c, c + sizeof(c)/sizeof(double));
  cout << horner(v, 3.0) << endl;
  return 0;
}
