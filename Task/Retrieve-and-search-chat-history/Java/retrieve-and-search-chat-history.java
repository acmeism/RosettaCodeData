import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;

public final class RetrieveAndSearchChatHistory {

	public static void main(String[] aArgs) throws URISyntaxException, IOException {		
		String subjectOfSearch = aArgs[0]; // The string 'available' was used to produce the displayed output.

		ZonedDateTime now = ZonedDateTime.now(ZoneId.of("Europe/Berlin"));
		LocalDate tomorrow = now.toLocalDate().plusDays(1);
		LocalDate testDate = tomorrow.minusDays(10);

		while ( ! testDate.equals(tomorrow ) ) {
	        URL address = new URI("http://tclers.tk/conferences/tcl/" + testDate + ".tcl").toURL();	
	        HttpURLConnection connection = (HttpURLConnection) address.openConnection();
	        BufferedReader reader = new BufferedReader( new InputStreamReader(connection.getInputStream()) );
	
	        System.out.println("Searching chat logs for " + testDate);	
	        String line = "";
	        while ( ( line = reader.readLine() ).contains(subjectOfSearch) ) {
	        	System.out.println(line);
	        }
	
	        reader.close();
	        connection.disconnect();
	        testDate = testDate.plusDays(1);
		}
	}

}
