using System;
using System.Collections.Generic;
using System.Linq;

namespace ConvertSecondsToCompoundDuration
{
  class Program
  {
    static void Main( string[] args )
    {
      foreach ( string arg in args )
      {
        int duration ;
        bool isValid = int.TryParse( arg , out duration ) ;

        if ( !isValid     ) { Console.Error.WriteLine( "ERROR: Not an integer: {0}"           , arg ) ; }
        if ( duration < 0 ) { Console.Error.WriteLine( "ERROR: duration must be non-negative" , arg ) ; }

        Console.WriteLine();
        Console.WriteLine( "{0:#,##0} seconds ==> {1}" , duration , FormatAsDuration(duration) ) ;

      }
    }

    private static string FormatAsDuration( int duration )
    {
      if ( duration < 0 ) throw new ArgumentOutOfRangeException("duration") ;
      return string.Join( ", " , GetDurationParts(duration)  ) ;
    }

    private static IEnumerable<string> GetDurationParts( int duration )
    {
      var parts = new[]
      {
        new { Name="wk" , Length = 7*24*60*60*1 , } ,
        new { Name="d"  , Length =   24*60*60*1 , } ,
        new { Name="h"  , Length =      60*60*1 , } ,
        new { Name="m"  , Length =         60*1 , } ,
        new { Name="s"  , Length =            1 , } ,
      } ;

      foreach ( var part in parts )
      {
        int n = Math.DivRem( duration , part.Length , out duration ) ;
        if ( n > 0 ) yield return string.Format( "{0} {1}" , n , part.Name ) ;
      }

    }

  }

}
