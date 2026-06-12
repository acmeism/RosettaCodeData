// Euclidean rhythm
#include <iostream>
#include <string>
#include <vector>
using namespace std;

string euclidean_rhythm(const unsigned int m, const unsigned int n)
{
  vector<string> r(n);
  unsigned int a_start = 0, a_end = m - 1, b_start = m, b_end = n - 1;
  for (unsigned int i = a_start; i <= a_end; i++)
    r[i] = "1";
  for (unsigned int i = b_start; i <= b_end; i++)
    r[i] = "0";
  while (a_end > a_start && b_end > b_start)
  {
    unsigned int a_pos = a_start, b_pos = b_start;
    while (a_pos <= a_end && b_pos <= b_end)
    {
      r[a_pos] += r[b_pos];
      a_pos++;
      b_pos++;
    }
    if (b_pos <= b_end)
      b_start = b_pos;
    else
    {
      b_start = a_pos;
      b_end = a_end;
      a_end = a_pos - 1;
    }
  }
  string result = "";
  for (unsigned int i = a_start; i <= a_end; i++)
    result += r[i];
  for (unsigned int i = b_start; i <= b_end; i++)
    result += r[i];
  return result;
}

int main()
{
  cout << euclidean_rhythm(5, 13) << "\n";
  cout << euclidean_rhythm(3, 8) << "\n";
}
