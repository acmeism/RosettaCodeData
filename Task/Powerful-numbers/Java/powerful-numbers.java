import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class PowerfulNumbers {

    public static void main(String[] args) {
        System.out.printf("Task:  For k = 2..10, generate the set of k-powerful numbers <= 10^k and show the first 5 and the last 5 terms, along with the length of the set%n");
        for ( int k = 2 ; k <= 10 ; k++ ) {
            BigInteger max = BigInteger.valueOf(10).pow(k);
            List<BigInteger> powerfulNumbers = getPowerFulNumbers(max, k);
            System.out.printf("There are %d %d-powerful numbers between 1 and %d.  %nList: %s%n", powerfulNumbers.size(), k, max, getList(powerfulNumbers));
        }
        System.out.printf("%nTask:  For k = 2..10, show the number of k-powerful numbers less than or equal to 10^j, for 0 <= j < k+10%n");
        for ( int k = 2 ; k <= 10 ; k++ ) {
            List<Integer> powCount = new ArrayList<>();
            for ( int j = 0 ; j < k+10 ; j++ ) {
                BigInteger max = BigInteger.valueOf(10).pow(j);
                powCount.add(countPowerFulNumbers(max, k));
            }
            System.out.printf("Count of %2d-powerful numbers <= 10^j, j in [0, %d]: %s%n", k, k+9, powCount);
        }

    }

    private static String getList(List<BigInteger> list) {
        StringBuilder sb = new StringBuilder();
        sb.append(list.subList(0, 5).toString().replace("]", ""));
        sb.append(" ... ");
        sb.append(list.subList(list.size()-5, list.size()).toString().replace("[", ""));
        return sb.toString();
    }

    private static int countPowerFulNumbers(BigInteger max, int k) {
        return potentialPowerful(max, k).size();
    }

    private static List<BigInteger> getPowerFulNumbers(BigInteger max, int k) {
        List<BigInteger> powerfulNumbers = new ArrayList<>(potentialPowerful(max, k));
        Collections.sort(powerfulNumbers);
        return powerfulNumbers;
    }

    private static Set<BigInteger> potentialPowerful(BigInteger max, int k) {
        //  Setup
        int[] indexes = new int[k];
        for ( int i = 0 ; i < k ; i++ ) {
            indexes[i] = 1;
        }

        Set<BigInteger> powerful = new HashSet<>();
        boolean foundPower = true;
        while ( foundPower ) {

            boolean genPowerful = false;
            for ( int index = 0 ; index < k ; index++ ) {
                BigInteger power = BigInteger.ONE;
                for ( int i = 0 ; i < k ; i++ ) {
                    power = power.multiply(BigInteger.valueOf(indexes[i]).pow(k+i));
                }
                if ( power.compareTo(max) <= 0 ) {
                    powerful.add(power);
                    indexes[0] += 1;
                    genPowerful = true;
                    break;
                }
                else {
                    indexes[index] = 1;
                    if ( index < k-1 ) {
                        indexes[index+1] += 1;
                    }
                }
            }
            if ( ! genPowerful ) {
                foundPower = false;
            }
        }

        return powerful;
    }

}
