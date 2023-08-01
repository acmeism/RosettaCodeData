import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.net.URI;
import java.net.URL;
import java.security.KeyStore;
import java.util.Scanner;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;

public final class HTTPSClientAuthenticated {

	public static void main(String[] aArgs) throws Exception {
		final String keyStorePath = "the/path/to/keystore"; // The key store contains the client's certificate
		final String keyStorePassword = "my-password";
		
	    SSLContext sslContext = getSSLContext(keyStorePath, keyStorePassword);
	    URL url = new URI("https://somehost.com").toURL();
	    HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
	    connection.setSSLSocketFactory(sslContext.getSocketFactory());	
	
	    // Obtain response from the url
	    BufferedInputStream response = (BufferedInputStream) connection.getInputStream();
	    try ( Scanner scanner = new Scanner(response) ) {
	        String responseBody = scanner.useDelimiter("\\A").next();
	        System.out.println(responseBody);
	    }	
	}
	
	private static SSLContext getSSLContext(String aPath, String aPassword) throws Exception {
	    KeyStore keyStore = KeyStore.getInstance("pkcs12");
	    keyStore.load( new FileInputStream(aPath), aPassword.toCharArray());
	    KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance("PKIX");
	    keyManagerFactory.init(keyStore, aPassword.toCharArray());
	    SSLContext sslContext = SSLContext.getInstance("TLS");
	    sslContext.init(keyManagerFactory.getKeyManagers(), null, null);
	    return sslContext;
	}
	
}
