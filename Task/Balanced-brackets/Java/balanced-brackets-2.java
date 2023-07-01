import java.util.ArrayDeque;
import java.util.Deque;

public class BalancedBrackets {
	
	public static boolean areSquareBracketsBalanced(String expr) {
		return isBalanced(expr, "", "", "[", "]", false);
	}
	public static boolean areBracketsBalanced(String expr) {
		return isBalanced(expr, "", "", "{([", "})]", false);
	}
	public static boolean areStringAndBracketsBalanced(String expr) {
		return isBalanced(expr, "'\"", "\\\\", "{([", "})]", true);
	}
	public static boolean isBalanced(String expr, String lit, String esc, String obr, String cbr, boolean other) {
		boolean[] inLit = new boolean[lit.length()];
		Deque<Character> stack = new ArrayDeque<Character>();
		for (int i=0; i<expr.length(); i+=1) {
			char c = get(expr, i);
			int x;
			if ((x = indexOf(inLit, true)) != -1) {
				if (c == get(lit, x) && get(expr, i-1) != get(esc, x)) inLit[x] = false;
			}
			else if ((x = indexOf(lit, c)) != -1)
				inLit[x] = true;
			else if ((x = indexOf(obr, c)) != -1)
				stack.push(get(cbr, x));
			else if (indexOf(cbr, c) != -1) {
				if (stack.isEmpty() || stack.pop() != c) return false;
			}
			else if (!other)
				return false;
		}
		return stack.isEmpty();
	}
	
	static int indexOf(boolean[] a, boolean b) {
		for (int i=0; i<a.length; i+=1) if (a[i] == b) return i;
		return -1;
	}
	static int indexOf(String s, char c) {
		return s.indexOf(c);
	}
	static char get(String s, int i) {
		return s.charAt(i);
	}

	public static void main(String[] args) {
		System.out.println("With areSquareBracketsBalanced:");
		for (String s: new String[] {
				"", "[]", "[][]", "[[][]]", "][", "][][", "[]][[]", "[", "]"
			}
		) {
			System.out.printf("%s: %s\n", s, areSquareBracketsBalanced(s));
		}
		System.out.println("\nBut also with areStringAndBracketsBalanced:");
		for (String s: new String[] {
				"x[]", "[x]", "[]x", "([{}])", "([{}]()", "([{ '([{\\'([{' \"([{\\\"([{\" }])",
			}
		) {
			System.out.printf("%s: %s\n", s, areStringAndBracketsBalanced(s));
		}
	}
}
