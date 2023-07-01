public class Trims{
    public static String ltrim(String s) {
        int i = 0;
        while (i < s.length() && Character.isWhitespace(s.charAt(i))) {
            i++;
        }
        return s.substring(i);
    }

    public static String rtrim(String s) {
        int i = s.length() - 1;
        while (i > 0 && Character.isWhitespace(s.charAt(i))) {
            i--;
        }
        return s.substring(0, i + 1);
    }

    public static String trim(String s) {
    	return rtrim(ltrim(s));
    }

    public static void main(String[] args) {
        String s = " \t \r \n String with spaces \u2009 \t  \r  \n  ";
        System.out.printf("[%s]\n", ltrim(s));
        System.out.printf("[%s]\n", rtrim(s));
        System.out.printf("[%s]\n", trim(s));
    }
}
