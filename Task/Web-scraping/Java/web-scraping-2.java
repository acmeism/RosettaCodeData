import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

public final class WebScraping {
	
    public static void main(String[] aArgs) {
	    try {
	        URI uri = new URI("https://www.rosettacode.org/wiki/Talk:Web_scraping").parseServerAuthority();	
	        URL address = uri.toURL();
	        HttpURLConnection connection = (HttpURLConnection) address.openConnection();
	        BufferedReader reader = new BufferedReader( new InputStreamReader(connection.getInputStream()) );
	
	        final int responseCode = connection.getResponseCode();
	        System.out.println("Response code: " + responseCode);
	
	        String line;
	        while ( ! ( line = reader.readLine() ).contains("UTC") ) {
	        	/* Empty block */
	        }
	
	        final int index = line.indexOf("UTC");	
	        System.out.println(line.substring(index - 16, index + 4));
	
	        reader.close();
	        connection.disconnect();
	    } catch (IOException ioe) {
	        System.err.println("Error connecting to server: " + ioe.getCause());
	    } catch (URISyntaxException use) {
	    	System.err.println("Unable to connect to URI: " + use.getCause());
		}
	}

}
