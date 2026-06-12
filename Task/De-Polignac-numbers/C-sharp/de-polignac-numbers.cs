// De Polignac numbers
using System;

class Polignac
{
  static void Main()
  {
    const uint maxNumber = 500000; // maximum number we will consider
    const uint maxPower  =     20; // maximum power of 2 < maxNumber
    uint sqrtMaNumber = (uint)(Math.Sqrt(maxNumber));
    // sieve the primes to maxNumber
    bool[] prime = new bool[maxNumber + 1];
    prime[0] = false;
    prime[1] = false;
    prime[2] = true;
    for (uint i = 3; i < maxNumber; i += 2)
      prime[i] = true;
    for (uint i = 4; i < maxNumber; i += 2)
      prime[i]= false;
    for (uint i = 3; i < sqrtMaNumber; i += 2)
      if (prime[i])
        for (uint s = i * i; s < maxNumber; s += i + i)
          prime[s] = false;
    // Table of powersOf2 up to around 2000000
    // Increase the table size if maxNumber > 2000000
    uint[] powersOf2 = new uint[maxPower + 1];
    uint p2 = 1;
    powersOf2[0] = 1; // unused
    for (uint i = 1; i <= maxPower; i++)
    {
      p2 *= 2;
      powersOf2[i] = p2;
    }
    // The numbers must be odd and not of the form p + 2^n
    // Either p is odd and 2^n is even and hence n > 0 and p > 2
    // or 2^n is odd and p is even and hence n = 0 and p = 2
    // (the only even prime is 2, the only odd 2^n is 1).
    // n = 0, p = 2
    uint dpCount = 1;
    Console.Write(String.Format("{0,5}", 1)); // Or litteral "00001"
    // n > 0, p > 2
    for (uint i = 5; i < maxNumber; i += 2)
    {
      bool found = false;
      for (uint p = 1; p < maxPower && !found && i > powersOf2[p]; p++)
        found = prime[i - powersOf2[p]];
      if (!found)
      {
        dpCount++;
        if (dpCount <= 50)
        {
          Console.Write(String.Format("{0,5}", i));
          if (dpCount % 10 == 0)
            Console.WriteLine();
        }
        else if (dpCount == 1000 || dpCount == 10000)
          Console.WriteLine(String.Format("The {0,5}th de Polignac number is {1,7}", dpCount, i));
      }
    }
    Console.WriteLine("Found {0} de Polignac numbers up to {1}", dpCount, maxNumber);
  }
}
