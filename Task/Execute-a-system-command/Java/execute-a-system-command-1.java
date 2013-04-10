import java.util.Scanner;
import java.io.*;

public class Program {
    public static void main(String[] args) {    	
    	try {
    		Process p = Runtime.getRuntime().exec("cmd /C dir");//Windows command, use "ls -oa" for UNIX
    		Scanner sc = new Scanner(p.getInputStream());    		
    		while (sc.hasNext()) System.out.println(sc.nextLine());
    	}
    	catch (IOException e) {
    		System.out.println(e.getMessage());
    	}
    }
}
