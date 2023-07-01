public class LongestCommonSubstring {

    public static void main(String[] args) {
        System.out.println(lcs("testing123testing", "thisisatest"));
        System.out.println(lcs("test", "thisisatest"));
        System.out.println(lcs("testing", "sting"));
        System.out.println(lcs("testing", "thisisasting"));
    }

    static String lcs(String a, String b) {
        if (a.length() > b.length())
            return lcs(b, a);

        String res = "";
        for (int ai = 0; ai < a.length(); ai++) {
            for (int len = a.length() - ai; len > 0; len--) {

                for (int bi = 0; bi <= b.length() - len; bi++) {

                    if (a.regionMatches(ai, b, bi, len) && len > res.length()) {
                        res = a.substring(ai, ai + len);
                    }
                }
            }
        }
        return res;
    }
}
