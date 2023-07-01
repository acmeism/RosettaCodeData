using System;
using System.Linq;

namespace RosettaCode.Tasks
{
	public static class EthiopianMultiplication_Task
	{
		public static void Test ( )
		{
			Console.WriteLine ( "Ethiopian Multiplication" );
			int A = 17, B = 34;
			Console.WriteLine ( "Recursion: {0}*{1}={2}", A, B, EM_Recursion ( A, B ) );
			Console.WriteLine ( "Linq: {0}*{1}={2}", A, B, EM_Linq ( A, B ) );
			Console.WriteLine ( "Loop: {0}*{1}={2}", A, B, EM_Loop ( A, B ) );
			Console.WriteLine ( );
		}

		public static int Halve ( this int p_Number )
		{
			return p_Number >> 1;
		}
		public static int Double ( this int p_Number )
		{
			return p_Number << 1;
		}
		public static bool IsEven ( this int p_Number )
		{
			return ( p_Number % 2 ) == 0;
		}

		public static int EM_Recursion ( int p_NumberA, int p_NumberB )
		{
			//     Anchor Point,                Recurse to find the next row                                 Sum it with the second number according to the rules
			return p_NumberA == 1 ? p_NumberB : EM_Recursion ( p_NumberA.Halve ( ), p_NumberB.Double ( ) ) + ( p_NumberA.IsEven ( ) ? 0 : p_NumberB );
		}
		public static int EM_Linq ( int p_NumberA, int p_NumberB )
		{
			// Creating a range from 1 to x where x the number of times p_NumberA can be halved.
			// This will be 2^x where 2^x <= p_NumberA. Basically, ln(p_NumberA)/ln(2).
			return Enumerable.Range ( 1, Convert.ToInt32 ( Math.Log ( p_NumberA, Math.E ) / Math.Log ( 2, Math.E ) ) + 1 )
				// For every item (Y) in that range, create a new list, comprising the pair (p_NumberA,p_NumberB) Y times.
				.Select ( ( item ) => Enumerable.Repeat ( new { Col1 = p_NumberA, Col2 = p_NumberB }, item )
					// The aggregate method iterates over every value in the target list, passing the accumulated value and the current item's value.
					.Aggregate ( ( agg_pair, orig_pair ) => new { Col1 = agg_pair.Col1.Halve ( ), Col2 = agg_pair.Col2.Double ( ) } ) )
				// Remove all even items
				.Where ( pair => !pair.Col1.IsEven ( ) )
				// And sum!
				.Sum ( pair => pair.Col2 );
		}
		public static int EM_Loop ( int p_NumberA, int p_NumberB )
		{
			int RetVal = 0;
			while ( p_NumberA >= 1 )
			{
				RetVal += p_NumberA.IsEven ( ) ? 0 : p_NumberB;
				p_NumberA = p_NumberA.Halve ( );
				p_NumberB = p_NumberB.Double ( );
			}
			return RetVal;
		}
	}
}
