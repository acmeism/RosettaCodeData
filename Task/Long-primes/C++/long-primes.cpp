#include <iomanip>
#include <iostream>
#include <list>
using namespace std;

void sieve(int limit, list<int> &primes)
{
  bool *c = new bool[limit + 1];
  for (int i = 0; i <= limit; i++)
    c[i] = false;
  // No need to process even numbers
  int p = 3, n = 0;
  int p2 = p * p;
  while (p2 <= limit)
  {
    for (int i = p2; i <= limit; i += 2 * p)
      c[i] = true;
    do
      p += 2;
    while (c[p]);
    p2 = p * p;
  }
  for (int i = 3; i <= limit; i += 2)
    if (!c[i])
      primes.push_back(i);
  delete [] c;
}

// Finds the period of the reciprocal of n
int findPeriod(int n)
{
  int r = 1, rr, period = 0;
  for (int i = 1; i <= n + 1; ++i)
    r = (10 * r) % n;
  rr = r;
  do
  {
    r = (10 * r) % n;
    period++;
  }
  while (r != rr);
  return period;
}

int main()
{
  int count = 0, index = 0;
  int numbers[] = {500, 1000, 2000, 4000, 8000, 16000, 32000, 64000};
  list<int> primes;
  list<int> longPrimes;
  int numberCount = sizeof(numbers) / sizeof(int);
  int *totals = new int[numberCount];
  cout << "Please wait." << endl << endl;
  sieve(64000, primes);
  for (list<int>::iterator iterPrime = primes.begin();
    iterPrime != primes.end();
    iterPrime++)
  {
    if (findPeriod(*iterPrime) == *iterPrime - 1)
      longPrimes.push_back(*iterPrime);
  }

  for (list<int>::iterator iterLongPrime = longPrimes.begin();
    iterLongPrime != longPrimes.end();
    iterLongPrime++)
  {
    if (*iterLongPrime > numbers[index])
      totals[index++] = count;
        ++count;
  }
  totals[numberCount - 1] = count;
  cout << "The long primes up to " << totals[0] << " are:" << endl;
  cout << "[";
  int i = 0;
  for (list<int>::iterator iterLongPrime = longPrimes.begin();
    iterLongPrime != longPrimes.end() && i < totals[0];
    iterLongPrime++, i++)
  {
    cout << *iterLongPrime << " ";
  }
  cout << "\b]" << endl;
  cout << endl << "The number of long primes up to:" << endl;
  for (int i = 0; i < 8; ++i)
    cout << "  " << setw(5) << numbers[i] << " is " << totals[i] << endl;
  delete [] totals;
}
