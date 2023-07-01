import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HumbleNumbers {

    public static void main(String[] args) {
        System.out.println("First 50 humble numbers:");
        System.out.println(Arrays.toString(humble(50)));
        Map<Integer,Integer> lengthCountMap = new HashMap<>();
        BigInteger[] seq = humble(1_000_000);
        for ( int i = 0 ; i < seq.length ; i++ ) {
            BigInteger humbleNumber = seq[i];
            int len = humbleNumber.toString().length();
            lengthCountMap.merge(len, 1, (v1, v2) -> v1 + v2);
        }
        List<Integer> sorted = new ArrayList<>(lengthCountMap.keySet());
        Collections.sort(sorted);
        System.out.printf("Length  Count%n");
        for ( Integer len : sorted ) {
            System.out.printf("    %2s  %5s%n", len, lengthCountMap.get(len));
        }
    }

    private static BigInteger[] humble(int n) {
        BigInteger two = BigInteger.valueOf(2);
        BigInteger twoTest = two;
        BigInteger three = BigInteger.valueOf(3);
        BigInteger threeTest = three;
        BigInteger five = BigInteger.valueOf(5);
        BigInteger fiveTest = five;
        BigInteger seven = BigInteger.valueOf(7);
        BigInteger sevenTest = seven;
        BigInteger[] results = new BigInteger[n];
        results[0] = BigInteger.ONE;
        int twoIndex = 0, threeIndex = 0, fiveIndex = 0, sevenIndex = 0;
        for ( int index = 1 ; index < n ; index++ ) {
            results[index] = twoTest.min(threeTest).min(fiveTest).min(sevenTest);
            if ( results[index].compareTo(twoTest) == 0 ) {
                twoIndex++;
                twoTest = two.multiply(results[twoIndex]);
            }
            if (results[index].compareTo(threeTest) == 0 ) {
                threeIndex++;
                threeTest = three.multiply(results[threeIndex]);
            }
            if (results[index].compareTo(fiveTest) == 0 ) {
                fiveIndex++;
                fiveTest = five.multiply(results[fiveIndex]);
            }
            if (results[index].compareTo(sevenTest) == 0 ) {
                sevenIndex++;
                sevenTest = seven.multiply(results[sevenIndex]);
            }
        }
        return results;
    }

}
