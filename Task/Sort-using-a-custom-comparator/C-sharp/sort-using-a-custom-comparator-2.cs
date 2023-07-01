using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaCode
{
	class SortCustomComparator
	{
		// Driver program
		public void CustomSort()
		{
			List<string> list = new List<string> { "Here", "are", "some", "sample", "strings", "to", "be", "sorted" };

			DisplayList("Unsorted", list);

			var descOrdered = from l in list
					  orderby l.Length descending
					  select l;
			DisplayList("Descending Length", descOrdered);

			var ascOrdered = from l in list
					 orderby l
					 select l;
			DisplayList("Ascending order", ascOrdered);
		}

		// Output routine
		public void DisplayList(String header, IEnumerable<string> theList)
		{
			Console.WriteLine(header);
			Console.WriteLine("".PadLeft(header.Length, '*'));
			foreach (String str in theList)
			{
				Console.WriteLine(str);
			}
			Console.WriteLine();
		}
	}
}
