using SYS = System;
using SCG = System.Collections.Generic;

//
// Basically a port of the C++ solution as posted
// 2017-11-12.
//
namespace FibonacciWord
{
  class Program
  {
    static void Main( string[] args )
    {
      PrintHeading();
      string firstString = "1";
      int n = 1;
      PrintLine( n, firstString );
      string secondString = "0";
      ++n;
      PrintLine( n, secondString );
      while ( n < 37 )
      {
        string resultString = firstString + secondString;
        firstString = secondString;
        secondString = resultString;
        ++n;
        PrintLine( n, resultString );
      }
    }

    private static void PrintLine( int n, string result )
    {
      SYS.Console.Write( "{0,-5}", n );
      SYS.Console.Write( "{0,12}", result.Length );
      SYS.Console.WriteLine( "  {0,-16}", GetEntropy( result ) );
    }

    private static double GetEntropy( string result )
    {
      SCG.Dictionary<char, int> frequencies = new SCG.Dictionary<char, int>();
      foreach ( char c in result )
      {
        if ( frequencies.ContainsKey( c ) )
        {
          ++frequencies[c];
        }
        else
        {
          frequencies[c] = 1;
        }
      }

      int length = result.Length;
      double entropy = 0;
      foreach ( var keyValue in frequencies )
      {
        double freq = (double)keyValue.Value / length;
        entropy += freq * SYS.Math.Log( freq, 2 );
      }

      return -entropy;
    }

    private static void PrintHeading()
    {
      SYS.Console.Write( "{0,-5}", "N" );
      SYS.Console.Write( "{0,12}", "Length" );
      SYS.Console.WriteLine( "  {0,-16}", "Entropy" );
    }
  }
}
