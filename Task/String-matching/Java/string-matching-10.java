public class JavaApplication6 {
    public static void main(String[] args) {
        String strOne = "complexity";
        String strTwo = "udacity";
        stringMatch(strOne, strTwo);
    }

    public static void stringMatch(String one, String two) {
        boolean match = false;
        if (one.charAt(0) == two.charAt(0)) {
            System.out.println(match = true);   // returns true
        } else {
            System.out.println(match);       // returns false
        }
        for (int i = 0; i < two.length(); i++) {
            int temp = i;
            for (int x = 0; x < one.length(); x++) {
                if (two.charAt(temp) == one.charAt(x)) {
                    System.out.println(match = true);    //returns true
                    i = two.length();
                }
            }
        }
        int num1 = one.length() - 1;
        int num2 = two.length() - 1;
        if (one.charAt(num1) == two.charAt(num2)) {
            System.out.println(match = true);
        } else {
            System.out.println(match = false);
        }
    }
}
