import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.regex.Pattern;

import javax.xml.bind.DatatypeConverter;

/**
 * Parses ipv4 and ipv6 addresses. Emits each described IP address as a
 * hexadecimal integer representing the address, the address space, and the port
 * number specified, if any.
 */
public class IPParser {
	/*
	 * Using regex to ensure that the address is a valid one. This allows for
	 * separating by format and ensures that the operations done on a format
	 * will be valid.
	 */
	// 0.0.0.0-255.255.255.255
	private final String ipv4segment =
			"(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";

	// 0-65535
	private final String portsegment =
			":(?:6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|"
					+ "6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{1,3}|[0-9])";
	private final String ipv4address = "(" + ipv4segment + "\\.){3,3}"
			+ ipv4segment;
	private final String ipv4addressWithPort = ipv4address + portsegment + "?";
	private final String ipv6segment = "[a-fA-F0-9]{1,4}";
	private final String ipv6address = "(" +
	// 1:2:3:4:5:6:7:8
			"(" + ipv6segment + ":){7,7}" + ipv6segment + "|" +
	// 1::, 1:2:3:4:5:6:7::
			"(" + ipv6segment + ":){1,7}:|" +
			// 1::8, 1:2:3:4:5:6::8, 1:2:3:4:5:6::8
			"(" + ipv6segment + ":){1,6}:" + ipv6segment + "|" +
			// 1::7:8, 1:2:3:4:5::7:8, 1:2:3:4:5::8
			"(" + ipv6segment + ":){1,5}(:" + ipv6segment + "){1,2}|" +
			// 1::6:7:8, 1:2:3:4::6:7:8, 1:2:3:4::8
			"(" + ipv6segment + ":){1,4}(:" + ipv6segment + "){1,3}|" +
			// 1::5:6:7:8, 1:2:3::5:6:7:8, 1:2:3::8
			"(" + ipv6segment + ":){1,3}(:" + ipv6segment + "){1,4}|" +
			// # 1::4:5:6:7:8, 1:2::4:5:6:7:8, 1:2::8
			"(" + ipv6segment + ":){1,2}(:" + ipv6segment + "){1,5}|" +
			// # 1::3:4:5:6:7:8, 1::3:4:5:6:7:8, 1::8
			ipv6segment + ":((:" + ipv6segment + "){1,6})|" +
			// ::2:3:4:5:6:7:8, ::2:3:4:5:6:7:8, ::8, ::
			":((:" + ipv6segment + "){1,7}|:)|" +
			// fe80::7:8%eth0, fe80::7:8%1 (link-local IPv6 addresses with
			// zone index)
			"fe80:(:" + ipv6segment + "){0,4}%[0-9a-zA-Z]{1,}|" +
			// ::255.255.255.255, ::ffff:255.255.255.255,
			// ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and
			// IPv4-translated addresses)
			"::(ffff(:0{1,4}){0,1}:){0,1}" + ipv4address + "|" +
			// 2001:db8:3:4::192.0.2.33, 64:ff9b::192.0.2.33 (IPv4-Embedded
			// IPv6 Address)
			"(" + ipv6segment + ":){1,4}:" + ipv4address + ")";

	private final String ipv6addressWithPort = "\\[" + ipv6address + "\\]"
			+ portsegment + "?";

	/**
	 * Parses ipv4 and ipv6 addresses. Emits each described IP address as a
	 * hexadecimal integer representing the address, the address space, and the
	 * port number specified, if any.
	 *
	 * @param address the address to analyze
	 */
	public void parse(String address) {

		// Used for storing values to be printed
		String space = "";// ipv4, ipv6, or unknown
		String hex = "";// hex value of the address
		String port = "";// the port or unknown

		// Try to match the pattern with one of the 2 types, with or without a
		// port
		if (Pattern.matches("^" + ipv4address + "$", address)) {
			InetAddress a;
			space = "IPv4";
			try {
				a = InetAddress.getByName(address);
				hex = DatatypeConverter.printHexBinary(a.getAddress());
			}
			catch (UnknownHostException e) {
				e.printStackTrace();
				hex = "Invalid";
			}
			port = "Absent";
		}
		else if (Pattern.matches("^" + ipv4addressWithPort + "$", address)) {
			String[] parts = address.split("\\.");
			port = parts[3].split(":")[1];
			parts[3] = parts[3].split(":")[0];
			InetAddress a;
			space = "IPv4";
			try {
				address = parts[0] + parts[1] + parts[2] + parts[3];
				a = InetAddress.getByName(address);
				hex = DatatypeConverter.printHexBinary(a.getAddress());
			}
			catch (UnknownHostException e) {
				e.printStackTrace();
				hex = "Invalid";
			}
		}
		else if (Pattern.matches("^" + ipv6address + "$", address)) {
			InetAddress a;
			space = "IPv6";
			try {
				a = Inet6Address.getByName(address);
				hex = DatatypeConverter.printHexBinary(a.getAddress());
			}
			catch (UnknownHostException e) {
				e.printStackTrace();
				hex = "Invalid";
			}
			port = "Absent";
		}
		else if (Pattern.matches("^" + ipv6addressWithPort + "$", address)) {
			String[] parts = address.split(":");
			InetAddress a;
			space = "IPv6";
			address =
					address.replace("[", "").replace("]", "")
							.replaceAll(portsegment + "$", "");
			try {
				a = Inet6Address.getByName(address);
				hex = DatatypeConverter.printHexBinary(a.getAddress());
			}
			catch (UnknownHostException e) {
				e.printStackTrace();
				hex = "Invalid";
			}
			port = parts[parts.length - 1];
		}
		else {
			// Not a valid address
			hex = "Invalid";
			space = "Invalid";
			port = "Invalid";
		}

		// Output the findings to the console
		System.out.println("Test case: '" + address + "'");
		System.out.println("Space:      " + space);
		System.out.println("Address:    " + hex);
		System.out.println("Port:       " + port);
		System.out.println();

	}

	/**
	 * Tests the parser using various addresses.
	 *
	 * @param args arguments for the program
	 */
	public static void main(String[] args) {
		IPParser parser = new IPParser();

		// The "localhost" IPv4 address
		parser.parse("127.0.0.1");
		// The "localhost" IPv4 address, with a specified port (80)
		parser.parse("127.0.0.1:80");
		// The "localhost" IPv6 address
		parser.parse("::1");
		// The "localhost" IPv6 address, with a specified port (80)
		parser.parse("[::1]:80");
		// Rosetta Code's primary server's public IPv6 address
		parser.parse("2605:2700:0:3::4713:93e3");
		// Rosetta Code's primary server's public IPv6 address, with a specified
		// port (80)
		parser.parse("[2605:2700:0:3::4713:93e3]:80");

		// ipv6 space
		parser.parse("::ffff:192.168.173.22");
		// ipv6 space with port
		parser.parse("[::ffff:192.168.173.22]:80");
		// trailing compression
		parser.parse("1::");
		// trailing compression with port
		parser.parse("[1::]:80");
		// 'any' address compression
		parser.parse("::");
		// 'any' address compression with port
		parser.parse("[::]:80");
	}
}
