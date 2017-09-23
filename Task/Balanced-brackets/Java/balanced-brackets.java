public class BalancedBrackets {

    public static boolean hasBalancedBrackets(String str) {
        int brackets = 0;
        for (char ch : str.toCharArray()) {
            if (ch == '[') {
                brackets++;
            } else if (ch == ']') {
                brackets--;
            } else {
                return false;   // non-bracket chars
            }
            if (brackets < 0) {   // closing bracket before opening bracket
                return false;
            }
        }
        return brackets == 0;
    }

    public static String generateBalancedBrackets(int n) {
        assert n % 2 == 0;   // if n is odd we can't match brackets
        char[] ans = new char[n];
        int openBracketsLeft = n / 2;
        int unclosed = 0;
        for (int i = 0; i < n; i++) {
            if (Math.random() >= 0.5 && openBracketsLeft > 0 || unclosed == 0) {
                ans[i] = '[';
                openBracketsLeft--;
                unclosed++;
            } else {
                ans[i] = ']';
                unclosed--;
            }
        }
        return String.valueOf(ans);
    }

    public static void main(String[] args) {
        for (int i = 0; i <= 16; i += 2) {
            String brackets = generateBalancedBrackets(i);
            System.out.println(brackets + ": " + hasBalancedBrackets(brackets));
        }

        String[] tests = {"", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]"};
        for (String test : tests) {
            System.out.println(test + ": " + hasBalancedBrackets(test));
        }
    }
}
