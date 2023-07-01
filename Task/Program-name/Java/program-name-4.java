public class ScriptName {
	public static void main(String[] args) {
		String program = Thread.currentThread().getStackTrace()[1].getClassName();
		System.out.println("Program: " + program);
	}
}
