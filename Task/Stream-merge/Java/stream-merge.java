import java.util.Iterator;
import java.util.List;
import java.util.Objects;

public class StreamMerge {
    private static <T extends Comparable<T>> void merge2(Iterator<T> i1, Iterator<T> i2) {
        T a = null, b = null;

        while (i1.hasNext() || i2.hasNext()) {
            if (null == a && i1.hasNext()) {
                a = i1.next();
            }
            if (null == b && i2.hasNext()) {
                b = i2.next();
            }

            if (null != a) {
                if (null != b) {
                    if (a.compareTo(b) < 0) {
                        System.out.print(a);
                        a = null;
                    } else {
                        System.out.print(b);
                        b = null;
                    }
                } else {
                    System.out.print(a);
                    a = null;
                }
            } else if (null != b) {
                System.out.print(b);
                b = null;
            }
        }

        if (null != a) {
            System.out.print(a);
        }
        if (null != b) {
            System.out.print(b);
        }
    }

    @SuppressWarnings("unchecked")
    @SafeVarargs
    private static <T extends Comparable<T>> void mergeN(Iterator<T>... iter) {
        Objects.requireNonNull(iter);
        if (iter.length == 0) {
            throw new IllegalArgumentException("Must have at least one iterator");
        }

        Object[] pa = new Object[iter.length];
        boolean done;

        do {
            done = true;

            for (int i = 0; i < iter.length; i++) {
                Iterator<T> t = iter[i];
                if (null == pa[i] && t.hasNext()) {
                    pa[i] = t.next();
                }
            }

            T min = null;
            int idx = -1;
            for (int i = 0; i < pa.length; ++i) {
                T t = (T) pa[i];
                if (null != t) {
                    if (null == min) {
                        min = t;
                        idx = i;
                        done = false;
                    } else if (t.compareTo(min) < 0) {
                        min = t;
                        idx = i;
                        done = false;
                    }
                }
            }
            if (idx != -1) {
                System.out.print(min);
                pa[idx] = null;
            }
        } while (!done);
    }

    public static void main(String[] args) {
        List<Integer> l1 = List.of(1, 4, 7, 10);
        List<Integer> l2 = List.of(2, 5, 8, 11);
        List<Integer> l3 = List.of(3, 6, 9, 12);

        merge2(l1.iterator(), l2.iterator());
        System.out.println();

        mergeN(l1.iterator(), l2.iterator(), l3.iterator());
        System.out.println();
        System.out.flush();
    }
}
