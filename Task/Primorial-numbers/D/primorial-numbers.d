import std.stdio;
import std.format;
import std.bigint;
import std.math;
import std.algorithm;


int sieveLimit = 1300_000;

bool[] notPrime;

void main()
{
  // initialize
  sieve(sieveLimit);

  // output 1	
  foreach (i; 0..10)
    writefln("primorial(%d): %d", i, primorial(i));

  // output 2
  foreach (i; 1..6)
    writefln("primorial(10^%d) has length %d", i, count(format("%d", primorial(pow(10, i)))));

}

BigInt primorial(int n)
{
  if (n == 0) return BigInt(1);

  BigInt result = BigInt(1);
  for (int i = 0; i < sieveLimit && n > 0; i++)
  {
    if (notPrime[i]) continue;
    result *= BigInt(i);
    n--;
  }
  return result;
}

void sieve(int limit)
{
  notPrime = new bool[limit];
  notPrime[0] = notPrime[1] = true;

  auto max = sqrt(cast (float) limit);
  for (int n = 2; n <= max; n++)
  {
    if (!notPrime[n])
    {
      for (int k = n * n; k < limit; k += n)
      {
        notPrime[k] = true;
      }
    }
  }
}
