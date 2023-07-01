public class Main{
	public static void main(String[] args){
		String[] tests = {"", "   ", "2", "333", ".55", "tttTTT", "4444 444k"};
		for(String s:tests)
			analyze(s);
	}

	public static void analyze(String s){
		System.out.printf("Examining [%s] which has a length of %d:\n", s, s.length());
		if(s.length() > 1){
			char firstChar = s.charAt(0);
			int lastIndex = s.lastIndexOf(firstChar);
			if(lastIndex != 0){
				System.out.println("\tNot all characters in the string are the same.");
				System.out.printf("\t'%c' (0x%x) is different at position %d\n", firstChar, (int) firstChar, lastIndex);
				return;
			}
		}
		System.out.println("\tAll characters in the string are the same.");
	}
}
