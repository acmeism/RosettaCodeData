public class ScriptName {
	public static void main(String[] args) {
		Class c = System.getSecurityManager().getClassContext()[0];
		System.out.println("Program: " + c.getName());
	}
}
