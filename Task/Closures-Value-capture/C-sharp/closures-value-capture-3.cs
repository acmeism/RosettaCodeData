using System;
using System.Collections.Generic;

class Program
{
    static void Main( string[] args )
    {
        List<Func<int>> l = new List<Func<int>>();
        for ( int i = 0; i < 10; ++i )
        {
            // This is key to avoiding the closure trap, because
            // the anonymous delegate captures a reference to
            // outer variables, not their value.  So we create 10
            // variables, and each created anonymous delegate
            // has references to that variable, not the loop variable
            var captured_val = i;
            l.Add( delegate() { return captured_val * captured_val; } );
        }

        l.ForEach( delegate( Func<int> f ) { Console.WriteLine( f() ); } );
    }
}
