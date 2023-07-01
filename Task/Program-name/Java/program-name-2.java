public class ScriptName {
	public static void main(String[] args) {
		Class c = new Object(){}.getClass().getEnclosingClass();
		System.out.println("Program: " + c.getName());
	}
}
