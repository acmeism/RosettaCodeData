import java.util.*;
import java.util.stream.LongStream;
import static java.util.stream.LongStream.rangeClosed;

public class AliquotSequenceClassifications {

    public static Long properDivsSum(long n) {
        return rangeClosed(1, (n + 1) / 2).filter(i -> n % i == 0 && n != i).sum();
    }

    static boolean aliquot(long n, int maxLen, long maxTerm) {
        List<Long> s = new ArrayList<>(maxLen);
        s.add(n);
        long newN = n;

        while (s.size() <= maxLen && newN < maxTerm) {

            newN = properDivsSum(s.get(s.size() - 1));

            if (s.contains(newN)) {

                if (s.get(0) == newN) {

                    switch (s.size()) {
                        case 1:
                            return report("Perfect", s);
                        case 2:
                            return report("Amicable", s);
                        default:
                            return report("Sociable of length " + s.size(), s);
                    }

                } else if (s.get(s.size() - 1) == newN) {
                    return report("Aspiring", s);

                } else
                    return report("Cyclic back to " + newN, s);

            } else {
                s.add(newN);
                if (newN == 0)
                    return report("Terminating", s);
            }
        }

        return report("Non-terminating", s);
    }

    static boolean report(String msg, List<Long> result) {
        System.out.println(msg + ": " + result);
        return false;
    }

    public static void main(String[] args) {
        long[] arr = {11L, 12, 28, 496, 220, 1184,  12496, 1264460,
                           790, 909, 562, 1064, 1488};

        LongStream.rangeClosed(1, 10).forEach(n -> aliquot(n, 16, 1L << 47));
        System.out.println();
        Arrays.stream(arr).forEach(n -> aliquot(n, 16, 1L << 47));
    }
}
