import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PalindromicGapfulNumbers {

    public static void main(String[] args) {
        System.out.println("First 20 palindromic gapful numbers ending in:");
        displayMap(getPalindromicGapfulEnding(20, 20));

        System.out.printf("%nLast 15 of first 100 palindromic gapful numbers ending in:%n");
        displayMap(getPalindromicGapfulEnding(15, 100));

        System.out.printf("%nLast 10 of first 1000 palindromic gapful numbers ending in:%n");
        displayMap(getPalindromicGapfulEnding(10, 1000));
    }

    private static void displayMap(Map<Integer,List<Long>> map) {
        for ( int key = 1 ; key <= 9 ; key++ ) {
            System.out.println(key + " : " + map.get(key));
        }
    }

    public static Map<Integer,List<Long>> getPalindromicGapfulEnding(int countReturned, int firstHowMany) {
        Map<Integer,List<Long>> map = new HashMap<>();
        Map<Integer,Integer> mapCount = new HashMap<>();
        for ( int i = 1 ; i <= 9 ; i++ ) {
            map.put(i, new ArrayList<>());
            mapCount.put(i, 0);
        }
        boolean notPopulated = true;
        for ( long n = 101 ; notPopulated ; n = nextPalindrome(n) ) {
            if ( isGapful(n) ) {
                int index = (int) (n % 10);
                if ( mapCount.get(index) < firstHowMany ) {
                    map.get(index).add(n);
                    mapCount.put(index, mapCount.get(index) + 1);
                    if ( map.get(index).size() > countReturned ) {
                        map.get(index).remove(0);
                    }
                }
                boolean finished = true;
                for ( int i = 1 ; i <= 9 ; i++ ) {
                    if ( mapCount.get(i) < firstHowMany ) {
                        finished = false;
                        break;
                    }
                }
                if ( finished ) {
                    notPopulated = false;
                }
            }
        }
        return map;
    }

    public static boolean isGapful(long n) {
        String s = Long.toString(n);
        return n % Long.parseLong("" + s.charAt(0) + s.charAt(s.length()-1)) == 0;
    }

    public static int length(long n) {
        int length = 0;
        while ( n > 0 ) {
            length += 1;
            n /= 10;
        }
        return length;
    }

    public static long nextPalindrome(long n) {
        int length = length(n);
        if ( length % 2 == 0 ) {
            length /= 2;
            while ( length > 0 ) {
                n /= 10;
                length--;
            }
            n += 1;
            if ( powerTen(n) ) {
                return Long.parseLong(n + reverse(n/10));
            }
            return Long.parseLong(n + reverse(n));
        }
        length = (length - 1) / 2;
        while ( length > 0 ) {
            n /= 10;
            length--;
        }
        n += 1;
        if ( powerTen(n) ) {
            return Long.parseLong(n + reverse(n/100));
        }
        return Long.parseLong(n + reverse(n/10));
    }

    private static boolean powerTen(long n) {
        while ( n > 9 && n % 10 == 0 ) {
            n /= 10;
        }
        return n == 1;
    }

    private static String reverse(long n) {
        return (new StringBuilder(n + "")).reverse().toString();
    }

}
