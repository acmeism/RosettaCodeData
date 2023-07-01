import java.util.Arrays;
import java.util.Comparator;

public class FileExt{
	public static void main(String[] args){
		String[] tests = {"text.txt", "text.TXT", "test.tar.gz", "test/test2.exe", "test\\test2.exe", "test", "a/b/c\\d/foo"};
		String[] exts = {".txt",".gz","",".bat"};
		
		System.out.println("Extensions: " + Arrays.toString(exts) + "\n");
		
		for(String test:tests){
			System.out.println(test +": " + extIsIn(test, exts));
		}
	}
	
	public static boolean extIsIn(String test, String... exts){
		int lastSlash = Math.max(test.lastIndexOf('/'), test.lastIndexOf('\\')); //whichever one they decide to use today
		String filename = test.substring(lastSlash + 1);//+1 to get rid of the slash or move to index 0 if there's no slash
		
		//end of the name if no dot, last dot index otherwise
		int lastDot = filename.lastIndexOf('.') == -1 ? filename.length() : filename.lastIndexOf('.');
		String ext = filename.substring(lastDot);//everything at the last dot and after is the extension
		
		Arrays.sort(exts);//sort for the binary search
		
		return Arrays.binarySearch(exts, ext, new Comparator<String>() { //just use the built-in binary search method
			@Override                                                //it will let us specify a Comparator and it's fast enough
			public int compare(String o1, String o2) {
				return o1.compareToIgnoreCase(o2);
			}
		}) >= 0;//binarySearch returns negative numbers when it's not found
	}
}
