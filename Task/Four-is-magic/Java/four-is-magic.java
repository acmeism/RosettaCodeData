public class FourIsMagic {

    public static void main(String[] args) {
        for ( long n : new long[] {6, 60, 89, 300, 670, 2000, 2467, 20000, 24500,200000, 230000, 246571, 2300000, 2465712, 20000000, 24657123, 230000000, 245000000, -246570000, 123456789712345l, 8777777777777777777L, Long.MAX_VALUE}) {
            String magic = fourIsMagic(n);
            System.out.printf("%d = %s%n", n, toSentence(magic));
        }
    }

    private static final String toSentence(String s) {
        return s.substring(0,1).toUpperCase() + s.substring(1) + ".";
    }

    private static final String[] nums = new String[] {
            "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
            "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    };

    private static final String[] tens = new String[] {"zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};

    private static final String fourIsMagic(long n) {
        if ( n == 4 ) {
            return numToString(n) + " is magic";
        }
        String result = numToString(n);
        return result + " is " + numToString(result.length()) + ", " + fourIsMagic(result.length());
    }

    private static final String numToString(long n) {
        if ( n < 0 ) {
            return "negative " + numToString(-n);
        }
        int index = (int) n;
        if ( n <= 19 ) {
            return nums[index];
        }
        if ( n <= 99 ) {
            return tens[index/10] + (n % 10 > 0 ? " " + numToString(n % 10) : "");
        }
        String label = null;
        long factor = 0;
        if ( n <= 999 ) {
            label = "hundred";
            factor = 100;
        }
        else if ( n <= 999999) {
            label = "thousand";
            factor = 1000;
        }
        else if ( n <= 999999999) {
            label = "million";
            factor = 1000000;
        }
        else if ( n <= 999999999999L) {
            label = "billion";
            factor = 1000000000;
        }
        else if ( n <= 999999999999999L) {
            label = "trillion";
            factor = 1000000000000L;
        }
        else if ( n <= 999999999999999999L) {
            label = "quadrillion";
            factor = 1000000000000000L;
        }
        else {
            label = "quintillion";
            factor = 1000000000000000000L;
        }
        return numToString(n / factor) + " " + label + (n % factor > 0 ? " " + numToString(n % factor ) : "");
    }

}
