import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FractionReduction {

    public static void main(String[] args) {
        for ( int size = 2 ; size <= 5 ; size++ ) {
            reduce(size);
        }
    }

    private static void reduce(int numDigits) {
        System.out.printf("Fractions with digits of length %d where cancellation is valid.  Examples:%n", numDigits);

        //  Generate allowed numerator's and denominator's
        int min = (int) Math.pow(10, numDigits-1);
        int max = (int) Math.pow(10, numDigits) - 1;
        List<Integer> values = new ArrayList<>();
        for ( int number = min ; number <= max ; number++ ) {
            if ( isValid(number) ) {
                values.add(number);
            }
        }

        Map<Integer,Integer> cancelCount = new HashMap<>();
        int size = values.size();
        int solutions = 0;
        for ( int nIndex = 0 ; nIndex < size - 1 ; nIndex++ ) {
            int numerator = values.get(nIndex);
            //  Must be proper fraction
            for ( int dIndex = nIndex + 1 ; dIndex < size ; dIndex++ ) {
                int denominator = values.get(dIndex);
                for ( int commonDigit : digitsInCommon(numerator, denominator) ) {
                    int numRemoved = removeDigit(numerator, commonDigit);
                    int denRemoved = removeDigit(denominator, commonDigit);
                    if ( numerator * denRemoved == denominator * numRemoved ) {
                        solutions++;
                        cancelCount.merge(commonDigit, 1, (v1, v2) -> v1 + v2);
                        if ( solutions <= 12 ) {
                            System.out.printf("    When %d is removed, %d/%d = %d/%d%n", commonDigit, numerator, denominator, numRemoved, denRemoved);
                        }
                    }
                }
            }
        }
        System.out.printf("Number of fractions where cancellation is valid = %d.%n", solutions);
        List<Integer> sorted = new ArrayList<>(cancelCount.keySet());
        Collections.sort(sorted);
        for ( int removed : sorted ) {
            System.out.printf("    The digit %d was removed %d times.%n", removed, cancelCount.get(removed));
        }
        System.out.println();
    }

    private static int[] powers = new int[] {1, 10, 100, 1000, 10000, 100000};

    //  Remove the specified digit.
    private static int removeDigit(int n, int removed) {
        int m = 0;
        int pow = 0;
        while ( n > 0 ) {
            int r = n % 10;
            if ( r != removed ) {
                m = m + r*powers[pow];
                pow++;
            }
            n /= 10;
        }
        return m;
    }

    //  Assumes no duplicate digits individually in n1 or n2 - part of task
    private static List<Integer> digitsInCommon(int n1, int n2) {
        int[] count = new int[10];
        List<Integer> common = new ArrayList<>();
        while ( n1 > 0 ) {
            int r = n1 % 10;
            count[r] += 1;
            n1 /= 10;
        }
        while ( n2 > 0 ) {
            int r = n2 % 10;
            if ( count[r] > 0 ) {
                common.add(r);
            }
            n2 /= 10;
        }
        return common;
    }

    //  No repeating digits, no digit is zero.
    private static boolean isValid(int num) {
        int[] count = new int[10];
        while ( num > 0 ) {
            int r = num % 10;
            if ( r == 0 || count[r] == 1 ) {
                return false;
            }
            count[r] = 1;
            num /= 10;
        }
        return true;
    }

}
