import java.util.ArrayList;
import java.util.List;

public class FactorizeStringIntoLyndonWords {

    public static void main(String[] args) {
    	// Create a 128 character Thue-Morse word
    	String thueMorse = "0";
        for ( int i = 0; i < 7; i++ ) {
            String thueMorseCopy = thueMorse;
            thueMorse = thueMorse.replace("0", "a");
            thueMorse = thueMorse.replace("1", "0");
            thueMorse = thueMorse.replace("a", "1");
            thueMorse = thueMorseCopy + thueMorse;
        }

        System.out.println("The Thue-Morse word to be factorised:");
        System.out.println(thueMorse);

        System.out.println();
        System.out.println("The factors are:");
        for ( String factor : duval(thueMorse) ) {
        	System.out.println(factor);
        }
    }

    // Duval's algorithm
    private static List<String> duval(String text) {
        List<String> factorisation = new ArrayList<String>();
        int i = 0;

        while ( i < text.length() ) {
            int j = i + 1;
            int k = i;

            while ( j < text.length() && text.charAt(k) <= text.charAt(j) ) {
                if ( text.charAt(k) < text.charAt(j) ) {
                    k = i;
                } else {
                    k += 1;
                }

                j += 1;
            }

            while ( i <= k ) {
                factorisation.addLast(text.substring(i, i + j - k));
                i += j - k;
            }
        }

        return factorisation;
    }

}
