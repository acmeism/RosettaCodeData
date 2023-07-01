  using System;
  class Powerset
  {
    static int count = 0, n = 4;
    static int [] buf = new int [n];

    static void Main()
    {
  	int ind = 0;
  	int n_1 = n - 1;
  	for (;;)
  	{
  	  for (int i = 0; i <= ind; ++i) Console.Write("{0, 2}", buf [i]);
  	  Console.WriteLine();
  	  count++;

  	  if (buf [ind] < n_1) { ind++; buf [ind] = buf [ind - 1] + 1; }
  	  else if (ind > 0) { ind--; buf [ind]++; }
  	  else break;
  	}
  	Console.WriteLine("n=" + n + "   count=" + count);
    }
  }
