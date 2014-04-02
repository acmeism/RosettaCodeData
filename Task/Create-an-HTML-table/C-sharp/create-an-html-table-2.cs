using System;
using System.Text;
using System.Xml;

namespace N
{
	public class T
	{
		public static void Main()
		{
			var headerNames = new [] { "", "X", "Y", "Z" };
			
			var headerColumns = headerNames.Select(name =>
				new XElement
				(
					"th",
					name,
					new XAttribute("text-align", "center")
				)
			);
		
			var rows = Enumerable.Range(0, 4)
				.Select
				(
					rowIndex =>
						new XElement
						(
							"tr",
							new XElement("td", rowIndex),
							Enumerable.Range(0, 4)
							.Select
							(
								colIndex =>
								new XElement
								(
									"td",
									colIndex,
									new XAttribute("text-align", "center")
								)
							)
					)
				);
				
			var xml = new XElement
			(
				"table",
				new XElement
				(
					"thead",
					new XElement("tr", headerColumns),
					new XElement("tbody", rows)
				)
			);
			
			Console.WriteLine(xml.ToString());
		}
	}
}
