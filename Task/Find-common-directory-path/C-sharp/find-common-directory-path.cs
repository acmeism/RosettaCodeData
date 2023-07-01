using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RosettaCodeTasks
{

	class Program
	{
		static void Main ( string[ ] args )
		{
			FindCommonDirectoryPath.Test ( );
		}

	}

	class FindCommonDirectoryPath
	{
		public static void Test ( )
		{
			Console.WriteLine ( "Find Common Directory Path" );
			Console.WriteLine ( );
			List<string> PathSet1 = new List<string> ( );
			PathSet1.Add ( "/home/user1/tmp/coverage/test" );
			PathSet1.Add ( "/home/user1/tmp/covert/operator" );
			PathSet1.Add ( "/home/user1/tmp/coven/members" );
			Console.WriteLine("Path Set 1 (All Absolute Paths):");
			foreach ( string path in PathSet1 )
			{
				Console.WriteLine ( path );
			}
			Console.WriteLine ( "Path Set 1 Common Path: {0}", FindCommonPath ( "/", PathSet1 ) );
		}
		public static string FindCommonPath ( string Separator, List<string> Paths )
		{
			string CommonPath = String.Empty;
			List<string> SeparatedPath = Paths
				.First ( str => str.Length == Paths.Max ( st2 => st2.Length ) )
				.Split ( new string[ ] { Separator }, StringSplitOptions.RemoveEmptyEntries )
				.ToList ( );

			foreach ( string PathSegment in SeparatedPath.AsEnumerable ( ) )
			{
				if ( CommonPath.Length == 0 && Paths.All ( str => str.StartsWith ( PathSegment ) ) )
				{
					CommonPath = PathSegment;
				}
				else if ( Paths.All ( str => str.StartsWith ( CommonPath + Separator + PathSegment ) ) )
				{
					CommonPath += Separator + PathSegment;
				}
				else
				{
					break;
				}
			}
			
			return CommonPath;
		}
	}
}
