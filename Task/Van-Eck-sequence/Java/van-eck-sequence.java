import java.util.HashMap;
import java.util.Map;

public class VanEckSequence {

    public static void main(String[] args) {
        System.out.println("First 10 terms of Van Eck's sequence:");
        vanEck(1, 10);
        System.out.println("");
        System.out.println("Terms 991 to 1000 of Van Eck's sequence:");
        vanEck(991, 1000);
    }

    private static void vanEck(int firstIndex, int lastIndex) {
        Map<Integer,Integer> vanEckMap = new HashMap<>();
        int last = 0;
        if ( firstIndex == 1 ) {
            System.out.printf("VanEck[%d] = %d%n", 1, 0);
        }
        for ( int n = 2 ; n <= lastIndex ; n++ ) {
            int vanEck = vanEckMap.containsKey(last) ? n - vanEckMap.get(last) : 0;
            vanEckMap.put(last, n);
            last = vanEck;
            if ( n >= firstIndex ) {
                System.out.printf("VanEck[%d] = %d%n", n, vanEck);
            }
        }

    }

}
