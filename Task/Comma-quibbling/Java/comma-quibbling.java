public class Quibbler {

	public static String quibble(String[] words) {
		String qText = "{";
		for(int wIndex = 0; wIndex < words.length; wIndex++) {
			qText += words[wIndex] + (wIndex == words.length-1 ? "" :
						  wIndex == words.length-2 ? " and " :
						  ", ";
		}
		qText += "}";
		return qText;
	}
	
	public static void main(String[] args) {
		System.out.println(quibble(new String[]{}));
		System.out.println(quibble(new String[]{"ABC"}));
		System.out.println(quibble(new String[]{"ABC", "DEF"}));
		System.out.println(quibble(new String[]{"ABC", "DEF", "G"}));
		System.out.println(quibble(new String[]{"ABC", "DEF", "G", "H"}));
	}
}
