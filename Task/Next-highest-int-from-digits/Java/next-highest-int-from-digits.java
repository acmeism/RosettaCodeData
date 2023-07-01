import java.math.BigInteger;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NextHighestIntFromDigits {

    public static void main(String[] args) {
        for ( String s : new String[] {"0", "9", "12", "21", "12453", "738440", "45072010", "95322020", "9589776899767587796600", "3345333"} ) {
            System.out.printf("%s -> %s%n", format(s), format(next(s)));
        }
        testAll("12345");
        testAll("11122");
    }

    private static NumberFormat FORMAT = NumberFormat.getNumberInstance();

    private static String format(String s) {
        return FORMAT.format(new BigInteger(s));
    }

    private static void testAll(String s) {
        System.out.printf("Test all permutations of:  %s%n", s);
        String sOrig = s;
        String sPrev = s;
        int count = 1;

        //  Check permutation order.  Each is greater than the last
        boolean orderOk = true;
        Map <String,Integer> uniqueMap = new HashMap<>();
        uniqueMap.put(s, 1);
        while ( (s = next(s)).compareTo("0") != 0 ) {
            count++;
            if ( Long.parseLong(s) < Long.parseLong(sPrev) ) {
                orderOk = false;
            }
            uniqueMap.merge(s, 1, (v1, v2) -> v1 + v2);
            sPrev = s;
        }
        System.out.printf("    Order:  OK =  %b%n", orderOk);

        //  Test last permutation
        String reverse = new StringBuilder(sOrig).reverse().toString();
        System.out.printf("    Last permutation:  Actual = %s, Expected = %s, OK = %b%n", sPrev, reverse, sPrev.compareTo(reverse) == 0);

        //  Check permutations unique
        boolean unique = true;
        for ( String key : uniqueMap.keySet() ) {
            if ( uniqueMap.get(key) > 1 ) {
                unique = false;
            }
        }
        System.out.printf("    Permutations unique:  OK =  %b%n", unique);

        //  Check expected count.
        Map<Character,Integer> charMap = new HashMap<>();
        for ( char c : sOrig.toCharArray() ) {
            charMap.merge(c, 1, (v1, v2) -> v1 + v2);
        }
        long permCount = factorial(sOrig.length());
        for ( char c : charMap.keySet() ) {
            permCount /= factorial(charMap.get(c));
        }
        System.out.printf("    Permutation count:  Actual = %d, Expected = %d, OK = %b%n", count, permCount, count == permCount);


    }

    private static long factorial(long n) {
        long fact = 1;
        for (long num = 2 ; num <= n ; num++ ) {
            fact *= num;
        }
        return fact;
    }

    private static String next(String s) {
        StringBuilder sb = new StringBuilder();
        int index = s.length()-1;
        //  Scan right-to-left through the digits of the number until you find a digit with a larger digit somewhere to the right of it.
        while ( index > 0 && s.charAt(index-1) >= s.charAt(index)) {
            index--;
        }
        //  Reached beginning.  No next number.
        if ( index == 0 ) {
            return "0";
        }

        //  Find digit on the right that is both more than it, and closest to it.
        int index2 = index;
        for ( int i = index + 1 ; i < s.length() ; i++ ) {
            if ( s.charAt(i) < s.charAt(index2) && s.charAt(i) > s.charAt(index-1) ) {
                index2 = i;
            }
        }

        //  Found data, now build string
        //  Beginning of String
        if ( index > 1 ) {
            sb.append(s.subSequence(0, index-1));
        }

        //  Append found, place next
        sb.append(s.charAt(index2));

        //  Get remaining characters
        List<Character> chars = new ArrayList<>();
        chars.add(s.charAt(index-1));
        for ( int i = index ; i < s.length() ; i++ ) {
            if ( i != index2 ) {
                chars.add(s.charAt(i));
            }
        }

        //  Order the digits to the right of this position, after the swap; lowest-to-highest, left-to-right.
        Collections.sort(chars);
        for ( char c : chars ) {
            sb.append(c);
        }
        return sb.toString();
    }
}
