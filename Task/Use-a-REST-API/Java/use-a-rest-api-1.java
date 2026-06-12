package src;

import java.io.BufferedReader;
import java.io.FileReader;
import java.net.URI;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;



public class EventGetter {
	

	String city = "";
	String topic = "";
	
	public String getEvent(String path_code,String key) throws Exception{
		String responseString = "";
		
		URI request = new URIBuilder()			//We build the request URI
			.setScheme("http")
			.setHost("api.meetup.com")
			.setPath(path_code)
			//List of parameters :
			.setParameter("topic", topic)
			.setParameter("city", city)
			//End of params
			.setParameter("key", key)
			.build();
		
		HttpGet get = new HttpGet(request);			//Assign the URI to the get request
		System.out.println("Get request : "+get.toString());
		
		CloseableHttpClient client = HttpClients.createDefault();
		CloseableHttpResponse response = client.execute(get);
		responseString = EntityUtils.toString(response.getEntity());
		
		return responseString;
	}
	
	public String getApiKey(String key_path){
		String key = "";
		
		try{
			BufferedReader reader = new BufferedReader(new FileReader(key_path));	//Read the file where the API Key is
			key = reader.readLine().toString();									//Store key
			reader.close();
		}
		catch(Exception e){System.out.println(e.toString());}
		
		return key;																//Return the key value.
	}
	
}
