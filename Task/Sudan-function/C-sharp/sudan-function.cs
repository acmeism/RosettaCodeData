//Aamrun, 11th July 2022

using System;

namespace Sudan
{
  class Sudan
  {
  	static int F(int n,int x,int y) {
  		if (n == 0) {
    		return x + y;
  		}

  		else if (y == 0) {
    		return x;
  		}

  		return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
	}

    static void Main(string[] args)
    {
      Console.WriteLine("F(1,3,3) = " + F(1,3,3));
    }
  }
}
