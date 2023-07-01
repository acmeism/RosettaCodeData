import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ZumkellerNumbers {

    public static void main(String[] args) {
        int n = 1;
        System.out.printf("First 220 Zumkeller numbers:%n");
        for ( int count = 1 ; count <= 220 ; n += 1 ) {
            if ( isZumkeller(n) ) {
                System.out.printf("%3d  ", n);
                if ( count % 20 == 0 ) {
                    System.out.printf("%n");
                }
                count++;
            }
        }

        n = 1;
        System.out.printf("%nFirst 40 odd Zumkeller numbers:%n");
        for ( int count = 1 ; count <= 40 ; n += 2 ) {
            if ( isZumkeller(n) ) {
                System.out.printf("%6d", n);
                if ( count % 10 == 0 ) {
                    System.out.printf("%n");
                }
                count++;
            }
        }

        n = 1;
        System.out.printf("%nFirst 40 odd Zumkeller numbers that do not end in a 5:%n");
        for ( int count = 1 ; count <= 40 ; n += 2 ) {
            if ( n % 5 != 0 && isZumkeller(n) ) {
                System.out.printf("%8d", n);
                if ( count % 10 == 0 ) {
                    System.out.printf("%n");
                }
                count++;
            }
        }

    }

    private static boolean isZumkeller(int n) {
        //  numbers congruent to 6 or 12 modulo 18 are Zumkeller numbers
        if ( n % 18 == 6 || n % 18 == 12 ) {
            return true;
        }

        List<Integer> divisors = getDivisors(n);
        int divisorSum = divisors.stream().mapToInt(i -> i.intValue()).sum();

        //  divisor sum cannot be odd
        if ( divisorSum % 2 == 1 ) {
            return false;
        }

        // numbers where n is odd and the abundance is even are Zumkeller numbers
        int abundance = divisorSum - 2 * n;
        if ( n % 2 == 1 && abundance > 0 && abundance % 2 == 0 ) {
            return true;
        }

        Collections.sort(divisors);
        int j = divisors.size() - 1;
        int sum = divisorSum/2;

        //  Largest divisor larger than sum - then cannot partition and not Zumkeller number
        if ( divisors.get(j) > sum ) {
            return false;
        }

        return canPartition(j, divisors, sum, new int[2]);
    }

    private static boolean canPartition(int j, List<Integer> divisors, int sum, int[] buckets) {
        if ( j < 0 ) {
            return true;
        }
        for ( int i = 0 ; i < 2 ; i++ ) {
            if ( buckets[i] + divisors.get(j) <= sum ) {
                buckets[i] += divisors.get(j);
                if ( canPartition(j-1, divisors, sum, buckets) ) {
                    return true;
                }
                buckets[i] -= divisors.get(j);
            }
            if( buckets[i] == 0 ) {
                break;
            }
        }
        return false;
    }

    private static final List<Integer> getDivisors(int number) {
        List<Integer> divisors = new ArrayList<Integer>();
        long sqrt = (long) Math.sqrt(number);
        for ( int i = 1 ; i <= sqrt ; i++ ) {
            if ( number % i == 0 ) {
                divisors.add(i);
                int div = number / i;
                if ( div != i ) {
                    divisors.add(div);
                }
            }
        }
        return divisors;
    }

}
