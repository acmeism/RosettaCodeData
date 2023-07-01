using System;
using System.Collections;
using System.Linq;

namespace RosettaCodeTasks
{
	static class FlattenList
	{
		public static ArrayList Flatten(this ArrayList List)
		{
			ArrayList NewList = new ArrayList ( );

			NewList.AddRange ( List );

			while ( NewList.OfType<ArrayList> ( ).Count ( ) > 0 )
			{
				int index = NewList.IndexOf ( NewList.OfType<ArrayList> ( ).ElementAt ( 0 ) );
				ArrayList Temp = (ArrayList)NewList[index];
				NewList.RemoveAt ( index );
				NewList.InsertRange ( index, Temp );
			}
			
			return NewList;
		}
	}
}
