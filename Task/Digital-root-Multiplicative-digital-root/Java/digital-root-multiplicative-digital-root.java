import java.util.*;

public class MultiplicativeDigitalRoot {

    public static void main(String[] args) {

        System.out.println("NUMBER  MDR   MP");
        for (long n : new long[]{123321, 7739, 893, 899998}) {
            long[] a = multiplicativeDigitalRoot(n);
            System.out.printf("%6d %4d %4d%n", a[0], a[1], a[2]);
        }

        System.out.println();

        Map<Long, List<Long>> table = new HashMap<>();
        for (long i = 0; i < 10; i++)
            table.put(i, new ArrayList<>());

        for (long cnt = 0, n = 0; cnt < 10;) {
            long[] res = multiplicativeDigitalRoot(n++);
            List<Long> list = table.get(res[1]);
            if (list.size() < 5) {
                list.add(res[0]);
                cnt = list.size() == 5 ? cnt + 1 : cnt;
            }
        }

        System.out.println("MDR: first five numbers with same MDR");
        table.forEach((key, lst) -> {
            System.out.printf("%3d: ", key);
            lst.forEach(e -> System.out.printf("%6s ", e));
            System.out.println();
        });
    }

    public static long[] multiplicativeDigitalRoot(long n) {
        int mp = 0;
        long mdr = n;
        while (mdr > 9) {
            long m = mdr;
            long total = 1;
            while (m > 0) {
                total *= m % 10;
                m /= 10;
            }
            mdr = total;
            mp++;
        }
        return new long[]{n, mdr, mp};
    }
}
