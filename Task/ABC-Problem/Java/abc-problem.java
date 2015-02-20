import java.util.Arrays;

public class ABC{
	private static void swap(int i, int j, Object... arr){
		Object tmp = arr[i];
		arr[i] = arr[j];
		arr[j] = tmp;
	}
	
	public static boolean canMakeWord(String word, String... blocks) {
	    if(word.length() == 0)
	        return true;
	
	    char c = Character.toUpperCase(word.charAt(0));
	    for(int i = 0; i < blocks.length; i++) {
	    	String b = blocks[i];
	        if(Character.toUpperCase(b.charAt(0)) != c && Character.toUpperCase(b.charAt(1)) != c)
	            continue;
	        swap(0, i, blocks);
	        if(canMakeWord(word.substring(1), Arrays.copyOfRange(blocks, 1, blocks.length)))
	            return true;
	        swap(0, i, blocks);
	    }
	
	    return false;
	}
	
	public static void main(String[] args){
		String[] blocks = {"BO", "XK", "DQ", "CP", "NA",
				"GT", "RE", "TG", "QD", "FS",
				"JW", "HU", "VI", "AN", "OB",
				"ER", "FS", "LY", "PC", "ZM"};

		System.out.println("\"\": " + canMakeWord("", blocks));
		System.out.println("A: " + canMakeWord("A", blocks));
		System.out.println("BARK: " + canMakeWord("BARK", blocks));
		System.out.println("book: " + canMakeWord("book", blocks));
		System.out.println("treat: " + canMakeWord("treat", blocks));
		System.out.println("COMMON: " + canMakeWord("COMMON", blocks));
		System.out.println("SQuAd: " + canMakeWord("SQuAd", blocks));
		System.out.println("CONFUSE: " + canMakeWord("CONFUSE", blocks));
		
	}
}
