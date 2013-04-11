import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

public class LetterFreq {
	public static int[] countLetters(String filename) throws IOException{
		int[] freqs = new int[26];
		BufferedReader in = new BufferedReader(new FileReader(filename));
		String line;
		while((line = in.readLine()) != null){
			line = line.toUpperCase();
			for(char ch:line.toCharArray()){
				if(Character.isLetter(ch)){
					freqs[ch - 'A']++;
				}
			}
		}
		in.close();
		return freqs;
	}
	
	public static void main(String[] args) throws IOException{
		System.out.println(Arrays.toString(countLetters("filename.txt")));
	}
}
