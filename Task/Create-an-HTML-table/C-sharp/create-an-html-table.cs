using System;
using System.Text;

namespace prog
{
	class MainClass
	{		
		public static void Main (string[] args)
		{
			StringBuilder s = new StringBuilder();
			Random rnd = new Random();
			
			s.AppendLine("<table>");
			s.AppendLine("<thead align = \"right\">");
			s.Append("<tr><th></th>");
			for(int i=0; i<3; i++)
				s.Append("<td>" + "XYZ"[i] + "</td>");
			s.AppendLine("</tr>");
			s.AppendLine("</thead>");
			s.AppendLine("<tbody align = \"right\">");
			for( int i=0; i<3; i++ )
			{
				s.Append("<tr><td>"+i+"</td>");
				for( int j=0; j<3; j++ )
					s.Append("<td>"+rnd.Next(10000)+"</td>");				
				s.AppendLine("</tr>");
			}
			s.AppendLine("</tbody>");
			s.AppendLine("</table>");
			
			Console.WriteLine( s );
		}
	}
}
