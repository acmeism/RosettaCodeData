import java.util.Scanner;

public class Main {
	public static void doStuff(String word){
	   System.out.println(word);
	}

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int n = Integer.parseInt(in.nextLine());  //doesn't use nextInt() so nextLine doesn't just read newline character
		for(int i=0; i<n; i++){		
			String word = in.nextLine();
			doStuff(word);
		}
	}
}
