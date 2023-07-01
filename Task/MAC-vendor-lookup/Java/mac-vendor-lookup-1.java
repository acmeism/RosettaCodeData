package com.jamesdonnell.MACVendor;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/** MAC Vendor Lookup class.
 * www.JamesDonnell.com
 * @author James A. Donnell Jr. */
public class Lookup {
	/** Base URL for API. The API from www.macvendors.com was chosen. */
	private static final String baseURL = "http://api.macvendors.com/";

	/** Performs lookup on MAC address(es) supplied in arguments.
	 * @param args MAC address(es) to lookup. */
	public static void main(String[] args) {
		for (String arguments : args)
			System.out.println(arguments + ": " + get(arguments));
	}

	/** Performs lookup on supplied MAC address.
	 * @param macAddress MAC address to lookup.
	 * @return Manufacturer of MAC address. */
	private static String get(String macAddress) {
		try {
			StringBuilder result = new StringBuilder();
			URL url = new URL(baseURL + macAddress);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}
			rd.close();
			return result.toString();
		} catch (FileNotFoundException e) {
			// MAC not found
			return "N/A";
		} catch (IOException e) {
			// Error during lookup, either network or API.
			return null;
		}
	}
}
