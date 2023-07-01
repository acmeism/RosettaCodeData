using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RosettaCodeTasks.FourBitAdder
{
	public struct BitAdderOutput
	{
		public bool S { get; set; }
		public bool C { get; set; }
		public override string ToString ( )
		{
			return "S" + ( S ? "1" : "0" ) + "C" + ( C ? "1" : "0" );
		}
	}
	public struct Nibble
	{
		public bool _1 { get; set; }
		public bool _2 { get; set; }
		public bool _3 { get; set; }
		public bool _4 { get; set; }
		public override string ToString ( )
		{
			return ( _4 ? "1" : "0" )
				+ ( _3 ? "1" : "0" )
				+ ( _2 ? "1" : "0" )
				+ ( _1 ? "1" : "0" );
		}
	}
	public struct FourBitAdderOutput
	{
		public Nibble N { get; set; }
		public bool C { get; set; }
		public override string ToString ( )
		{
			return N.ToString ( ) + "c" + ( C ? "1" : "0" );
		}
	}

	public static class LogicGates
	{
		// Basic Gates
		public static bool Not ( bool A ) { return !A; }
		public static bool And ( bool A, bool B ) { return A && B; }
		public static bool Or ( bool A, bool B ) { return A || B; }

		// Composite Gates
		public static bool Xor ( bool A, bool B ) {	return Or ( And ( A, Not ( B ) ), ( And ( Not ( A ), B ) ) ); }
	}

	public static class ConstructiveBlocks
	{
		public static BitAdderOutput HalfAdder ( bool A, bool B )
		{
			return new BitAdderOutput ( ) { S = LogicGates.Xor ( A, B ), C = LogicGates.And ( A, B ) };
		}

		public static BitAdderOutput FullAdder ( bool A, bool B, bool CI )
		{
			BitAdderOutput HA1 = HalfAdder ( CI, A );
			BitAdderOutput HA2 = HalfAdder ( HA1.S, B );

			return new BitAdderOutput ( ) { S = HA2.S, C = LogicGates.Or ( HA1.C, HA2.C ) };
		}

		public static FourBitAdderOutput FourBitAdder ( Nibble A, Nibble B, bool CI )
		{

			BitAdderOutput FA1 = FullAdder ( A._1, B._1, CI );
			BitAdderOutput FA2 = FullAdder ( A._2, B._2, FA1.C );
			BitAdderOutput FA3 = FullAdder ( A._3, B._3, FA2.C );
			BitAdderOutput FA4 = FullAdder ( A._4, B._4, FA3.C );

			return new FourBitAdderOutput ( ) { N = new Nibble ( ) { _1 = FA1.S, _2 = FA2.S, _3 = FA3.S, _4 = FA4.S }, C = FA4.C };
		}

		public static void Test ( )
		{
			Console.WriteLine ( "Four Bit Adder" );

			for ( int i = 0; i < 256; i++ )
			{
				Nibble A = new Nibble ( ) { _1 = false, _2 = false, _3 = false, _4 = false };
				Nibble B = new Nibble ( ) { _1 = false, _2 = false, _3 = false, _4 = false };
				if ( (i & 1) == 1)
				{
					A._1 = true;
				}
				if ( ( i & 2 ) == 2 )
				{
					A._2 = true;
				}
				if ( ( i & 4 ) == 4 )
				{
					A._3 = true;
				}
				if ( ( i & 8 ) == 8 )
				{
					A._4 = true;
				}
				if ( ( i & 16 ) == 16 )
				{
					B._1 = true;
				}
				if ( ( i & 32 ) == 32)
				{
					B._2 = true;
				}
				if ( ( i & 64 ) == 64 )
				{
					B._3 = true;
				}
				if ( ( i & 128 ) == 128 )
				{
					B._4 = true;
				}

				Console.WriteLine ( "{0} + {1} = {2}", A.ToString ( ), B.ToString ( ), FourBitAdder( A, B, false ).ToString ( ) );

			}

			Console.WriteLine ( );
		}

	}
}
