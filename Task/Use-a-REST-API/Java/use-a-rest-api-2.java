/*
 * In this class, You can see the diferent
 * ways of asking for events.
 * */


package src;

import java.util.Iterator;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;

public class Main {
	public static void main(String[] args) {
		
		String key_path = "API_key/api_key.txt"; 							//Path to API Key (api_key.txt)
		String key = "";
		String path_code = "/2/open_events";								//PathCode for get-events
																			//More PathCodes : http://www.meetup.com/meetup_api/docs/
		String events = "";
		
		EventGetter eventGetter = new EventGetter();
		key = eventGetter.getApiKey(key_path);
		
		/*
		 * 1-PARAMETER EXAMPLE :
		 */
		eventGetter.topic = "photo";										//Set the parameter "topic" to "photo"
		
		try {
			events = eventGetter.getEvent(path_code, key);					//Store the event response into a String
		} catch (Exception e) {e.printStackTrace();}
		DecodeJSON(events);													//Print JSON-parsed events info						
		
		/*
		 * 2-PARAMETER EXAMPLE :
		 */
		eventGetter.topic = "tech";											//Set parameters
		eventGetter.city = "Barcelona";										
		try{
			events = eventGetter.getEvent(path_code, key);
		}catch(Exception e){e.printStackTrace();}
		//System.out.println(events);											//Print the events list (JSON)
	
		
		/*
		 * MULTIPLE-TOPICS EXAMPLE :
		 * Separate topics by commas
		 */
		eventGetter.topic = "tech,photo,art";								//multiple topic separated by commas										
		eventGetter.city = "Barcelona";
		try{
			events = eventGetter.getEvent(path_code, key);
		}catch(Exception e){e.printStackTrace();}
		
	}
	
	public static void DecodeJSON(String events){
		
		try{
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(events);
			JSONArray results = (JSONArray) obj.get("results");
			System.out.println("Results : ");
			
			Iterator i = results.iterator();
			while(i.hasNext()){
				JSONObject event = (JSONObject) i.next();
				System.out.println("Name : "+event.get("name"));
				
				if(event.containsKey("venue")){
					JSONObject venue = (JSONObject) event.get("venue");
					System.out.println("Location (city) : "+venue.get("city"));
					System.out.println("Location (adress) : "+venue.get("adress_1"));
				}
				
				
				System.out.println("Url : "+event.get("event_url"));
				System.out.println("Time : "+event.get("time"));
				i.next();
			}
			
		}
		catch(Exception e){e.printStackTrace();}
	}

}
