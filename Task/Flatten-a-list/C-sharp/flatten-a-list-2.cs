using System;
using System.Collections;

namespace RosettaCodeTasks
{
	class Program
	{
		static void Main ( string[ ] args )
		{

			ArrayList Parent = new ArrayList ( );
			Parent.Add ( new ArrayList ( ) );
			((ArrayList)Parent[0]).Add ( 1 );
			Parent.Add ( 2 );
			Parent.Add ( new ArrayList ( ) );
			( (ArrayList)Parent[2] ).Add ( new ArrayList ( ) );
			( (ArrayList)( (ArrayList)Parent[2] )[0] ).Add ( 3 );
			( (ArrayList)( (ArrayList)Parent[2] )[0] ).Add ( 4 );
			( (ArrayList)Parent[2] ).Add ( 5 );
			Parent.Add ( new ArrayList ( ) );
			( (ArrayList)Parent[3] ).Add ( new ArrayList ( ) );
			( (ArrayList)( (ArrayList)Parent[3] )[0] ).Add ( new ArrayList ( ) );
			Parent.Add ( new ArrayList ( ) );
			( (ArrayList)Parent[4] ).Add ( new ArrayList ( ) );
			( (ArrayList)( (ArrayList)Parent[4] )[0] ).Add ( new ArrayList ( ) );

			( (ArrayList)( (ArrayList)( (ArrayList)( (ArrayList)Parent[4] )[0] )[0] ) ).Add ( 6 );
			Parent.Add ( 7 );
			Parent.Add ( 8 );
			Parent.Add ( new ArrayList ( ) );


			foreach ( Object o in Parent.Flatten ( ) )
			{
				Console.WriteLine ( o.ToString ( ) );
			}
		}

	}
}
