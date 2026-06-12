import java.util.Scanner;

public class Main {

	public static int doStuff(int a, int b){
	    int sum = a+b;
	    return sum;
	}

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);

		int n = in.nextInt();
		for(int i=0; i<n; i++){
			int a = in.nextInt();
			int b= in.nextInt();
			int result = doStuff(a, b);
			System.out.println(result);
		}
	}
}
