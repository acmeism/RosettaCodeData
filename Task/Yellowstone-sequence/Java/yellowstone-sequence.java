import java.util.ArrayList;
import java.util.List;

public class YellowstoneSequence {

    public static void main(String[] args) {
         System.out.printf("First 30 values in the yellowstone sequence:%n%s%n", yellowstoneSequence(30));
    }

    private static List<Integer> yellowstoneSequence(int sequenceCount) {
        List<Integer> yellowstoneList = new ArrayList<Integer>();
        yellowstoneList.add(1);
        yellowstoneList.add(2);
        yellowstoneList.add(3);
        int num = 4;
        List<Integer> notYellowstoneList = new ArrayList<Integer>();
        int yellowSize = 3;
        while ( yellowSize < sequenceCount ) {
            int found = -1;
            for ( int index = 0 ; index < notYellowstoneList.size() ; index++ ) {
                int test = notYellowstoneList.get(index);
                if ( gcd(yellowstoneList.get(yellowSize-2), test) > 1 && gcd(yellowstoneList.get(yellowSize-1), test) == 1 ) {
                    found = index;
                    break;
                }
            }
            if ( found >= 0 ) {
                yellowstoneList.add(notYellowstoneList.remove(found));
                yellowSize++;
            }
            else {
                while ( true ) {
                    if ( gcd(yellowstoneList.get(yellowSize-2), num) > 1 && gcd(yellowstoneList.get(yellowSize-1), num) == 1 ) {
                        yellowstoneList.add(num);
                        yellowSize++;
                        num++;
                        break;
                    }
                    notYellowstoneList.add(num);
                    num++;
                }
            }
        }
        return yellowstoneList;
    }

    private static final int gcd(int a, int b) {
        if ( b == 0 ) {
            return a;
        }
        return gcd(b, a%b);
    }

}
