using System;
using System.IO;

class Program
{
    static void Main( string[] args )
    {
        foreach ( string dir in args )
        {
            Console.WriteLine( "'{0}' {1} empty", dir, IsDirectoryEmpty( dir ) ? "is" : "is not" );
        }
    }

    private static bool IsDirectoryEmpty( string dir )
    {
        return ( Directory.GetFiles( dir ).Length == 0 &&
            Directory.GetDirectories( dir ).Length == 0 );
    }
}
