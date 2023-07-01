import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EKGSequenceConvergence {

    public static void main(String[] args) {
        System.out.println("Calculate and show here the first 10 members of EKG[2], EKG[5], EKG[7], EKG[9] and EKG[10].");
        for ( int i : new int[] {2, 5, 7, 9, 10} ) {
            System.out.printf("EKG[%d] = %s%n", i, ekg(i, 10));
        }
        System.out.println("Calculate and show here at which term EKG[5] and EKG[7] converge.");
        List<Integer> ekg5 = ekg(5, 100);
        List<Integer> ekg7 = ekg(7, 100);
        for ( int i = 1 ; i < ekg5.size() ; i++ ) {
            if ( ekg5.get(i) == ekg7.get(i) && sameSeq(ekg5, ekg7, i)) {
                System.out.printf("EKG[%d](%d) = EKG[%d](%d) = %d, and are identical from this term on%n", 5, i+1, 7, i+1, ekg5.get(i));
                break;
            }
        }
    }

    //  Same last element, and all elements in sequence are identical
    private static boolean sameSeq(List<Integer> seq1, List<Integer> seq2, int n) {
        List<Integer> list1 = new ArrayList<>(seq1.subList(0, n));
        Collections.sort(list1);
        List<Integer> list2 = new ArrayList<>(seq2.subList(0, n));
        Collections.sort(list2);
        for ( int i = 0 ; i < n ; i++ ) {
            if ( list1.get(i) != list2.get(i) ) {
                return false;
            }
        }
        return true;
    }

    //  Without HashMap to identify seen terms, need to examine list.
    //    Calculating 3000 terms in this manner takes 10 seconds
    //  With HashMap to identify the seen terms, calculating 3000 terms takes .1 sec.
    private static List<Integer> ekg(int two, int maxN) {
        List<Integer> result = new ArrayList<>();
        result.add(1);
        result.add(two);
        Map<Integer,Integer> seen = new HashMap<>();
        seen.put(1, 1);
        seen.put(two, 1);
        int minUnseen = two == 2 ? 3 : 2;
        int prev = two;
        for ( int n = 3 ; n <= maxN ; n++ ) {
            int test = minUnseen - 1;
            while ( true ) {
                test++;
                if ( ! seen.containsKey(test) && gcd(test, prev) > 1 ) {

                    result.add(test);
                    seen.put(test, n);
                    prev = test;
                    if ( minUnseen == test ) {
                        do {
                            minUnseen++;
                        } while ( seen.containsKey(minUnseen) );
                    }
                    break;
                }
            }
        }
        return result;
    }

    private static final int gcd(int a, int b) {
        if ( b == 0 ) {
            return a;
        }
        return gcd(b, a%b);
    }

}
