public class NonContinuousSubsequences {

    public static void main(String args[]) {
        seqR("1234", "", 0, 0);
    }

    private static void seqR(String s, String c, int i, int added) {
        if (i == s.length()) {
            if (c.trim().length() > added)
                System.out.println(c);
        } else {
            seqR(s, c + s.charAt(i), i + 1, added + 1);
            seqR(s, c + ' ', i + 1, added);
        }
    }
}
