using System;
using System.Linq;

namespace CommaQuibbling
{
    internal static class Program
    {
        #region Static Members
	private static string Quibble(string[] input)
	{
            return
                String.Format("{{{0}}}",
                    String.Join("",
                        input.Reverse().Zip(
                            new [] { "", " and " }.Concat(Enumerable.Repeat(", ", int.MaxValue)),
                            (x, y) => x + y).Reverse()));
	}


        private static void Main()
        {
            Console.WriteLine( Quibble( new string[] {} ) );
            Console.WriteLine( Quibble( new[] {"ABC"} ) );
            Console.WriteLine( Quibble( new[] {"ABC", "DEF"} ) );
            Console.WriteLine( Quibble( new[] {"ABC", "DEF", "G", "H"} ) );

            Console.WriteLine( "< Press Any Key >" );
            Console.ReadKey();
        }

        #endregion
    }
}
