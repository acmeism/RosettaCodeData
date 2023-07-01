import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class LuckyNumbers {

    private static int MAX = 200000;
    private static List<Integer> luckyEven = luckyNumbers(MAX, true);
    private static List<Integer> luckyOdd = luckyNumbers(MAX, false);

    public static void main(String[] args) {
        //  Case 1 and 2
        if ( args.length == 1 || ( args.length == 2 && args[1].compareTo("lucky") == 0 ) ) {
            int n = Integer.parseInt(args[0]);
            System.out.printf("LuckyNumber(%d) = %d%n", n, luckyOdd.get(n-1));
        }
        //  Case 3
        else if ( args.length == 2 && args[1].compareTo("evenLucky") == 0 ) {
            int n = Integer.parseInt(args[0]);
            System.out.printf("EvenLuckyNumber(%d) = %d%n", n, luckyEven.get(n-1));
        }
        //  Case 4 through 9
        else if ( args.length == 2 || args.length == 3 ) {
            int j = Integer.parseInt(args[0]);
            int k = Integer.parseInt(args[1]);
            //  Case 4 and 5
            if ( ( args.length == 2 && k > 0 ) || (args.length == 3 && k > 0 && args[2].compareTo("lucky") == 0 ) ) {
                System.out.printf("LuckyNumber(%d) through LuckyNumber(%d) = %s%n", j, k, luckyOdd.subList(j-1, k));
            }
            //  Case 6
            else if ( args.length == 3 && k > 0 && args[2].compareTo("evenLucky") == 0 ) {
                System.out.printf("EvenLuckyNumber(%d) through EvenLuckyNumber(%d) = %s%n", j, k, luckyEven.subList(j-1, k));
            }
            //  Case 7 and 8
            else if ( ( args.length == 2 && k < 0 ) || (args.length == 3 && k < 0 && args[2].compareTo("lucky") == 0 ) ) {
                int n = Collections.binarySearch(luckyOdd, j);
                int m = Collections.binarySearch(luckyOdd, -k);
                System.out.printf("Lucky Numbers in the range %d to %d inclusive = %s%n", j, -k, luckyOdd.subList(n < 0 ? -n-1 : n, m < 0 ? -m-1 : m+1));
            }
            //  Case 9
            else if ( args.length == 3 && k < 0 && args[2].compareTo("evenLucky") == 0 ) {
                int n = Collections.binarySearch(luckyEven, j);
                int m = Collections.binarySearch(luckyEven, -k);
                System.out.printf("Even Lucky Numbers in the range %d to %d inclusive = %s%n", j, -k, luckyEven.subList(n < 0 ? -n-1 : n, m < 0 ? -m-1 : m+1));
            }
        }
    }

    private static List<Integer> luckyNumbers(int max, boolean even) {
        List<Integer> luckyList = new ArrayList<>();
        for ( int i = even ? 2 : 1 ; i <= max ; i += 2 ) {
            luckyList.add(i);
        }
        int start = 1;
        boolean removed = true;
        while ( removed ) {
            removed = false;
            int increment = luckyList.get(start);
            List<Integer> remove = new ArrayList<>();
            for ( int i = increment-1 ; i < luckyList.size() ; i += increment ) {
                remove.add(0, i);
                removed = true;
            }
            for ( int i : remove ) {
                luckyList.remove(i);
            }
            start++;
        }
        return luckyList;
    }

}
