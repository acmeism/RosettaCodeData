import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintStream;

class Csv2Html {

	public static String escapeChars(String lineIn) {
		StringBuilder sb = new StringBuilder();
		int lineLength = lineIn.length();
		for (int i = 0; i < lineLength; i++) {
			char c = lineIn.charAt(i);
			switch (c) {
				case '"':
					sb.append("&quot;");
					break;
				case '&':
					sb.append("&amp;");
					break;
				case '\'':
					sb.append("&apos;");
					break;
				case '<':
					sb.append("&lt;");
					break;
				case '>':
					sb.append("&gt;");
					break;
				default: sb.append(c);
			}
		}
		return sb.toString();
	}

	public static void tableHeader(PrintStream ps, String[] columns) {
		ps.print("<tr>");
		for (int i = 0; i < columns.length; i++) {
			ps.print("<th>");
			ps.print(columns[i]);
			ps.print("</th>");
		}
		ps.println("</tr>");
	}
	
	public static void tableRow(PrintStream ps, String[] columns) {
		ps.print("<tr>");
		for (int i = 0; i < columns.length; i++) {
			ps.print("<td>");
			ps.print(columns[i]);
			ps.print("</td>");
		}
		ps.println("</tr>");
	}
	
	public static void main(String[] args) throws Exception {
		boolean withTableHeader = (args.length != 0);
		
		InputStreamReader isr = new InputStreamReader(System.in);
		BufferedReader br = new BufferedReader(isr);
		PrintStream stdout = System.out;
		
		stdout.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
		stdout.println("<html xmlns=\"http://www.w3.org/1999/xhtml\">");
		stdout.println("<head><meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\"/>");
		stdout.println("<title>Csv2Html</title>");
		stdout.println("<style type=\"text/css\">");
		stdout.println("body{background-color:#FFF;color:#000;font-family:OpenSans,sans-serif;font-size:10px;}");
		stdout.println("table{border:0.2em solid #2F6FAB;border-collapse:collapse;}");
		stdout.println("th{border:0.15em solid #2F6FAB;padding:0.5em;background-color:#E9E9E9;}");
		stdout.println("td{border:0.1em solid #2F6FAB;padding:0.5em;background-color:#F9F9F9;}</style>");
		stdout.println("</head><body><h1>Csv2Html</h1>");

		stdout.println("<table>");
		String stdinLine;
		boolean firstLine = true;
		while ((stdinLine = br.readLine()) != null) {
			String[] columns = escapeChars(stdinLine).split(",");
			if (withTableHeader == true && firstLine == true) {
				tableHeader(stdout, columns);
				firstLine = false;
			} else {
				tableRow(stdout, columns);
			}
		}
		stdout.println("</table></body></html>");
	}
}
