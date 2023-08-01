import java.io.IOException;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;

public final class HTTPSAuthenticated {

	public static void main(String[] aArgs) throws IOException, InterruptedException, URISyntaxException {
		HttpClient client = HttpClient.newBuilder()
			.authenticator( new MyAuthenticator() )
			.build();

		HttpRequest request = HttpRequest.newBuilder()
			.GET()
			.uri( new URI("https://postman-echo.com/basic-auth") ) // This website requires authentication
			.build();

		HttpResponse<String> response = client.send(request, BodyHandlers.ofString());

		System.out.println("Status: " +  response.statusCode());
	}

}

final class MyAuthenticator extends Authenticator {
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		String username = "kingkong";
		String password = "test1234";
		return new PasswordAuthentication(username, password.toCharArray());
	}
	
}
