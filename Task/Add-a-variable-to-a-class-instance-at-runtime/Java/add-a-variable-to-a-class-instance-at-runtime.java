import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public final class AddVariableToClassInstanceAtRuntime {

	public static void main(String[] args) {
		Demonstration demo = new Demonstration();
	    System.out.println("Create two variables at runtime: ");
	    Scanner scanner = new Scanner(System.in);
	    for ( int i = 1; i <= 2; i++ ) {	    	
	        System.out.println("    Variable number " + i + ":");
	        System.out.print("        Enter name: ");
	        String name = scanner.nextLine();
	        System.out.print("        Enter value: ");
	        String value = scanner.nextLine();
	        demo.runtimeVariables.put(name, value);
	        System.out.println();
	    }
	    scanner.close();
	
	    System.out.println("Two new runtime variables appear to have been created.");
	    for ( Map.Entry<String, Object> entry : demo.runtimeVariables.entrySet() ) {
	    	System.out.println("Variable " + entry.getKey() + " = " + entry.getValue());
	    }	
	}

}

final class Demonstration {
	
	Map<String, Object> runtimeVariables = new HashMap<String, Object>();
	
}
