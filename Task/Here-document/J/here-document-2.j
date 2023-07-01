package rosettacode.heredoc;
public class MainApp {
	public static void main(String[] args) {
		String hereDoc = """
				This is a multiline string.
				It includes all of this text,
				but on separate lines in the code.
				 """;
		System.out.println(hereDoc);
	}
}
