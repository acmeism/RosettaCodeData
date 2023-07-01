public class ScriptName {
	public static void main(String[] args) {
		String program = System.getProperty("sun.java.command").split(" ")[0];
		System.out.println("Program: " + program);
	}
}
