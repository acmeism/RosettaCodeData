import java.io.*;

public class AplusB {
	public static void main(String[] args) {
		try {
			StreamTokenizer in = new StreamTokenizer(new FileReader("input.txt"));
			in.nextToken();
			int a = (int) in.nval;
			in.nextToken();
			int b = (int) in.nval;
			FileWriter outFile = new FileWriter("output.txt");
			outFile.write(Integer.toString(a + b));
			outFile.close();
		}
		catch (IOException e) {
			System.out.println("IO error");
		}
	}
}
