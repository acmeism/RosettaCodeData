public class VariableDeclarationReset {
    public static void main(String[] args) {
        int[] s = {1, 2, 2, 3, 4, 4, 5};

        // There is no output as 'prev' is created anew each time
        // around the loop and set to zero.
        for (int i = 0; i < s.length; ++i) {
            int curr = s[i];
            int prev = 0;
//          int prev; // triggers "error: variable prev might not have been initialized"
            if (i > 0 && curr == prev) System.out.println(i);
            prev = curr;
        }

        int gprev = 0;

        // Now 'gprev' is used and reassigned
        // each time around the loop producing the desired output.
        for (int i = 0; i < s.length; ++i) {
            int curr = s[i];
            if (i > 0 && curr == gprev) System.out.println(i);
            gprev = curr;
        }
    }
}
