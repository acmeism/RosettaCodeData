#include <string>
#include <iostream>
using namespace std;

// Compute Levenshtein Distance
// Martin Ettl, 2012-10-05

size_t uiLevenshteinDistance(const string &s1, const string &s2)
{
  const size_t
    m(s1.size()),
    n(s2.size());

  if( m==0 ) return n;
  if( n==0 ) return m;

  // allocation below is not ISO-compliant,
  // it won't work with -pedantic-errors.
  size_t costs[n + 1];

  for( size_t k=0; k<=n; k++ ) costs[k] = k;

  size_t i { 0 };
  for (char const &c1 : s1)
  {
    costs[0] = i+1;
    size_t corner { i },
           j      { 0 };
    for (char const &c2 : s2)
    {
      size_t upper { costs[j+1] };
      if( c1 == c2 ) costs[j+1] = corner;
      else {
        size_t t(upper<corner? upper: corner);
        costs[j+1] = (costs[j]<t?costs[j]:t)+1;
      }

      corner = upper;
      j++;
    }
    i++;
  }

  return costs[n];
}

int main()
{
  string s0 { "rosettacode" },
         s1 { "raisethysword" };
  cout << "distance between " << s0 << " and " << s1 << " : "
    << uiLevenshteinDistance(s0,s1) << endl;

  return 0;
}
