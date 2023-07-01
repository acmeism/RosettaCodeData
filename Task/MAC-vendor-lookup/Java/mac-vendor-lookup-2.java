import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.concurrent.TimeUnit;

public final class MacVendorLookup {

	public static void main(String[] aArgs) throws InterruptedException, IOException {		
		for ( String macAddress : macAddresses ) {
			HttpResponse<String> response = getMacVendor(macAddress);
			System.out.println(macAddress + "  " + response.statusCode() + "  " + response.body());
			
			TimeUnit.SECONDS.sleep(2);
		}		
	}

	private static HttpResponse<String> getMacVendor(String aMacAddress) throws IOException, InterruptedException {				
		URI uri = URI.create(BASE_URL + aMacAddress);
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest
			.newBuilder()
		    .uri(uri)
		    .header("accept", "application/json")
		    .GET()
		    .build();
		
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		
		return response;
	}
	
	private static final String BASE_URL = "http://api.macvendors.com/";
	
	private static final List<String> macAddresses = List.of("88:53:2E:67:07:BE",
															 "D4:F4:6F:C9:EF:8D",
															 "FC:FB:FB:01:FA:21",
															 "4c:72:b9:56:fe:bc",
															 "00-14-22-01-23-45"
															 );	
	
}
