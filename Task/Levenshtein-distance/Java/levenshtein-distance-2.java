public class Levenshtein{
    public static int levenshtein(String s, String t){
        /* if either string is empty, difference is inserting all chars
         * from the other
         */
        if(s.length() == 0) return t.length();
        if(t.length() == 0) return s.length();

        /* if first letters are the same, the difference is whatever is
         * required to edit the rest of the strings
         */
        if(s.charAt(0) == t.charAt(0))
            return levenshtein(s.substring(1), t.substring(1));

        /* else try:
         *      changing first letter of s to that of t,
         *      remove first letter of s, or
         *      remove first letter of t
         */
        int a = levenshtein(s.substring(1), t.substring(1));
        int b = levenshtein(s, t.substring(1));
        int c = levenshtein(s.substring(1), t);

        if(a > b) a = b;
        if(a > c) a = c;

        //any of which is 1 edit plus editing the rest of the strings
        return a + 1;
    }

    public static void main(String[] args) {
        String s1 = "kitten";
        String s2 = "sitting";
        System.out.println("distance between '" + s1 + "' and '"
                + s2 + "': " + levenshtein(s1, s2));
        s1 = "rosettacode";
        s2 = "raisethysword";
        System.out.println("distance between '" + s1 + "' and '"
                + s2 + "': " + levenshtein(s1, s2));
        StringBuilder sb1 = new StringBuilder(s1);
        StringBuilder sb2 = new StringBuilder(s2);
        System.out.println("distance between '" + sb1.reverse() + "' and '"
                + sb2.reverse() + "': "
                + levenshtein(sb1.reverse().toString(), sb2.reverse().toString()));
    }
}
