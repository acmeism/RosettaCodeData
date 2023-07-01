//  Title:  Determine if a string is collapsible

public class StringCollapsible {

    public static void main(String[] args) {
        for ( String s : new String[] {
              "",
              "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
              "..1111111111111111111111111111111111111111111111111111111111111117777888",
              "I never give 'em hell, I just tell the truth, and they think it's hell. ",
              "                                                    --- Harry S Truman  ",
              "122333444455555666666777777788888888999999999",
              "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
              "headmistressship"}) {
            String result = collapse(s);
            System.out.printf("old:  %2d <<<%s>>>%nnew:  %2d <<<%s>>>%n%n", s.length(), s, result.length(), result);
        }
    }

    private static String collapse(String in) {
        StringBuilder sb = new StringBuilder();
        for ( int i = 0 ; i < in.length() ; i++ ) {
            if ( i == 0 || in.charAt(i-1) != in.charAt(i) ) {
                sb.append(in.charAt(i));
            }
        }
        return sb.toString();
    }

}
