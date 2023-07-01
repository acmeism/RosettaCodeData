import java.util.LinkedList;
import java.util.List;

public class MTF{
	public static List<Integer> encode(String msg, String symTable){
		List<Integer> output = new LinkedList<Integer>();
		StringBuilder s = new StringBuilder(symTable);
		for(char c : msg.toCharArray()){
			int idx = s.indexOf("" + c);
			output.add(idx);
			s = s.deleteCharAt(idx).insert(0, c);
		}
		return output;
	}
	
	public static String decode(List<Integer> idxs, String symTable){
		StringBuilder output = new StringBuilder();
		StringBuilder s = new StringBuilder(symTable);
		for(int idx : idxs){
			char c = s.charAt(idx);
			output = output.append(c);
			s = s.deleteCharAt(idx).insert(0, c);
		}
		return output.toString();
	}
	
	private static void test(String toEncode, String symTable){
		List<Integer> encoded = encode(toEncode, symTable);
		System.out.println(toEncode + ": " + encoded);
		String decoded = decode(encoded, symTable);
		System.out.println((toEncode.equals(decoded) ? "" : "in") + "correctly decoded to " + decoded);
	}
	
	public static void main(String[] args){
		String symTable = "abcdefghijklmnopqrstuvwxyz";
		test("broood", symTable);
		test("bananaaa", symTable);
		test("hiphophiphop", symTable);
	}
}
