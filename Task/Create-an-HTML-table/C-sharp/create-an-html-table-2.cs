using System;
using System.Text;
using System.Xml;

namespace N
{
	public class T
	{
		public static void Main()
		{
			var headers = new [] { "", "X", "Y", "Z" };
			
			var cols = headers.Select(name =>
				new XElement(
					"th",
					name,
					new XAttribute("text-align", "center")
				)
			);
		
			var rows = Enumerable.Range(0, 4).Select(ri =>
				new XElement(
					"tr",
					new XElement("td", ri),
					Enumerable.Range(0, 4).Select(ci =>
						new XElement(
							"td",
							ci,
							new XAttribute("text-align", "center")
						)
					)
				)
			);
				
			var xml = new XElement(
				"table",
				new XElement(
					"thead",
					new XElement("tr",    cols),
					new XElement("tbody", rows)
				)
			);
			
			Console.WriteLine(xml.ToString());
		}
	}
}
