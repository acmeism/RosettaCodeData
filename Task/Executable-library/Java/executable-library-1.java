import java.util.ArrayList;
import java.util.List;

//  task 1
public class HailstoneSequence {

    public static void main(String[] args) {
        //  task 2
        int n = 27;
        List<Long> sequence27 = hailstoneSequence(n);
        System.out.printf("Hailstone sequence for %d has a length of %d:%nhailstone(%d) = %s%n", n, sequence27.size(), n, sequence27);

        //  task 3
        int maxN = 0;
        int maxLength = 0;
        for ( int i = 1 ; i < 100_000 ; i++ ) {
            int seqLength = hailstoneSequence(i).size();
            if ( seqLength > maxLength ) {
                maxLength = seqLength;
                maxN = i;
            }
        }
        System.out.printf("Longest hailstone sequence less than 100,000: hailstone(%d).length() = %d", maxN, maxLength);
    }

    public static List<Long> hailstoneSequence(long n) {
        if ( n <= 0 ) {
            throw new IllegalArgumentException("Must be grater than or equal to zero.");
        }
        List<Long> sequence = new ArrayList<>();
        sequence.add(n);
        while ( n > 1 ) {
            if ( (n & 1) == 0 ) {
                n /= 2;
            }
            else {
                n = 3 * n + 1;
            }
            sequence.add(n);
        }
        return sequence;
    }

}
