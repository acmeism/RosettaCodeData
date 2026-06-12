import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.TimeUnit;

public final class StartingAWebBrowser {

	public static void main(String[] args) throws IOException, InterruptedException, URISyntaxException {
		List<String> addresses = List.of(
	        "Plataanstraat 5",
	        "Straat 12",
	        "Straat 12 II",
	        "Dr. J. Straat   12",
	        "Dr. J. Straat 12 a",
	        "Dr. J. Straat 12-14",
	        "Laan 1940 - 1945 37",
	        "Plein 1940 2",
	        "1213-laan 11",
	        "16 april 1944 Pad 1",
	        "1e Kruisweg 36",
	        "Laan 1940-'45 66",
	        "Laan '40-'45",
	        "Langeloërduinen 3 46",
	        "Marienwaerdt 2e Dreef 2",
	        "Provincialeweg N205 1",
	        "Rivium 2e Straat 59.",
	        "Nieuwe gracht 20rd",
	        "Nieuwe gracht 20rd 2",
	        "Nieuwe gracht 20zw /2",
	        "Nieuwe gracht 20zw/3",
	        "Nieuwe gracht 20 zw/4",
	        "Bahnhofstr. 4",
	        "Wertstr. 10",
	        "Lindenhof 1",
	        "Nordesch 20",
	        "Weilstr. 6",
	        "Harthauer Weg 2",
	        "Mainaustr. 49",
	        "August-Horch-Str. 3",
	        "Marktplatz 31",
	        "Schmidener Weg 3",
	        "Karl-Weysser-Str. 6"
	   );
		
		String htmlHeader = """
	    <html>
	    <head>
	    <title>Rosetta Code - Start a Web Browser</title>
	    <meta charset="UTF-8">
	    </head>
	    <body bgcolor="#e6e6ff">
	    <p align="center">
	    <font face="Arial, sans-serif" size="5">Split the house number from the street name</font>
	    </p>
	    <p align="center">
	    <table border="2"> <tr bgcolor="#9bbb59">
	    <th>Address</th><th>Street</th><th>House Number</th>
	    """;	
		
		String htmlFooter = """
	    </table>
	    </p>
	    </body>
	    </html>
	    """;
	
		StringBuilder builder = new StringBuilder(htmlHeader);
		for ( int i = 0; i < addresses.size(); i++ ) {
			String colour = ( i % 2 == 0 ) ? "#d8e4bc" : "#ebf1de";
			Tuple result = separateStreetAndHouse(addresses.get(i));
			builder.append("<tr bgcolor=" + colour + "><td>" + addresses.get(i) + "</td><td>"
				+ result.street + "</td><td>" + result.house + "</td></tr>" + System.lineSeparator());
		}
		builder.append(htmlFooter);
		
		String filePath = "test.html";
		Files.write(Paths.get(filePath), builder.toString().getBytes());
	
		openBrowser(filePath);
		TimeUnit.SECONDS.sleep(5);	
		Files.delete(Paths.get(filePath));	
	}
	
	private static void openBrowser(String url) throws IOException, URISyntaxException {
        if ( Desktop.isDesktopSupported() ) {
            Desktop desktop = Desktop.getDesktop();
            desktop.browse( new URI(url) );
        } else {
            Runtime runtime = Runtime.getRuntime();
            runtime.exec( new String[] { "xdg-open " + url, null, null } );
        }
	}
	
	private static Tuple separateStreetAndHouse(String address) {
		String house = "";
		
	    String[] fields = address.split("\\s+");
	    String last = fields[fields.length - 1];
	    String penultimate = fields[fields.length - 2];
	    if ( Character.isDigit(last.charAt(0) ) ) {
	    	final boolean isDigit = Character.isDigit(penultimate.charAt(0));
	    	if ( fields.length > 2 && isDigit && ! penultimate.startsWith("194") ) {
	    		house = penultimate + " " + last;
	    	} else {
	    		house = last;
	    	}
	    } else if ( fields.length > 2 ) {
	    	house = penultimate + " " + last;
	    }
	
	    String street = address.substring(0, address.length() - house.length()).stripTrailing();
	    return new Tuple(street, house);
	}
	
	private static record Tuple(String street, String house) {}
	
}
