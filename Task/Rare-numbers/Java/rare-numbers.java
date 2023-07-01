import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class RareNumbers {
    public interface Consumer5<A, B, C, D, E> {
        void apply(A a, B b, C c, D d, E e);
    }

    public interface Consumer7<A, B, C, D, E, F, G> {
        void apply(A a, B b, C c, D d, E e, F f, G g);
    }

    public interface Recursable5<A, B, C, D, E> {
        void apply(A a, B b, C c, D d, E e, Recursable5<A, B, C, D, E> r);
    }

    public interface Recursable7<A, B, C, D, E, F, G> {
        void apply(A a, B b, C c, D d, E e, F f, G g, Recursable7<A, B, C, D, E, F, G> r);
    }

    public static <A, B, C, D, E> Consumer5<A, B, C, D, E> recurse(Recursable5<A, B, C, D, E> r) {
        return (a, b, c, d, e) -> r.apply(a, b, c, d, e, r);
    }

    public static <A, B, C, D, E, F, G> Consumer7<A, B, C, D, E, F, G> recurse(Recursable7<A, B, C, D, E, F, G> r) {
        return (a, b, c, d, e, f, g) -> r.apply(a, b, c, d, e, f, g, r);
    }

    private static class Term {
        long coeff;
        byte ix1, ix2;

        public Term(long coeff, byte ix1, byte ix2) {
            this.coeff = coeff;
            this.ix1 = ix1;
            this.ix2 = ix2;
        }
    }

    private static final int MAX_DIGITS = 16;

    private static long toLong(List<Byte> digits, boolean reverse) {
        long sum = 0;
        if (reverse) {
            for (int i = digits.size() - 1; i >= 0; --i) {
                sum = sum * 10 + digits.get(i);
            }
        } else {
            for (Byte digit : digits) {
                sum = sum * 10 + digit;
            }
        }
        return sum;
    }

    private static boolean isNotSquare(long n) {
        long root = (long) Math.sqrt(n);
        return root * root != n;
    }

    private static List<Byte> seq(byte from, byte to, byte step) {
        List<Byte> res = new ArrayList<>();
        for (byte i = from; i <= to; i += step) {
            res.add(i);
        }
        return res;
    }

    private static String commatize(long n) {
        String s = String.valueOf(n);
        int le = s.length();
        int i = le - 3;
        while (i >= 1) {
            s = s.substring(0, i) + "," + s.substring(i);
            i -= 3;
        }
        return s;
    }

    public static void main(String[] args) {
        final LocalDateTime startTime = LocalDateTime.now();
        long pow = 1L;
        System.out.println("Aggregate timings to process all numbers up to:");
        // terms of (n-r) expression for number of digits from 2 to maxDigits
        List<List<Term>> allTerms = new ArrayList<>();
        for (int i = 0; i < MAX_DIGITS - 1; ++i) {
            allTerms.add(new ArrayList<>());
        }
        for (int r = 2; r <= MAX_DIGITS; ++r) {
            List<Term> terms = new ArrayList<>();
            pow *= 10;
            long pow1 = pow;
            long pow2 = 1;
            byte i1 = 0;
            byte i2 = (byte) (r - 1);
            while (i1 < i2) {
                terms.add(new Term(pow1 - pow2, i1, i2));

                pow1 /= 10;
                pow2 *= 10;

                i1++;
                i2--;
            }
            allTerms.set(r - 2, terms);
        }
        //  map of first minus last digits for 'n' to pairs giving this value
        Map<Byte, List<List<Byte>>> fml = Map.of(
            (byte) 0, List.of(List.of((byte) 2, (byte) 2), List.of((byte) 8, (byte) 8)),
            (byte) 1, List.of(List.of((byte) 6, (byte) 5), List.of((byte) 8, (byte) 7)),
            (byte) 4, List.of(List.of((byte) 4, (byte) 0)),
            (byte) 6, List.of(List.of((byte) 6, (byte) 0), List.of((byte) 8, (byte) 2))
        );
        // map of other digit differences for 'n' to pairs giving this value
        Map<Byte, List<List<Byte>>> dmd = new HashMap<>();
        for (int i = 0; i < 100; ++i) {
            List<Byte> a = List.of((byte) (i / 10), (byte) (i % 10));

            int d = a.get(0) - a.get(1);
            dmd.computeIfAbsent((byte) d, k -> new ArrayList<>()).add(a);
        }
        List<Byte> fl = List.of((byte) 0, (byte) 1, (byte) 4, (byte) 6);
        List<Byte> dl = seq((byte) -9, (byte) 9, (byte) 1); //  all differences
        List<Byte> zl = List.of((byte) 0);                  // zero differences only
        List<Byte> el = seq((byte) -8, (byte) 8, (byte) 2); // even differences only
        List<Byte> ol = seq((byte) -9, (byte) 9, (byte) 2); //  odd differences only
        List<Byte> il = seq((byte) 0, (byte) 9, (byte) 1);
        List<Long> rares = new ArrayList<>();
        List<List<List<Byte>>> lists = new ArrayList<>();
        for (int i = 0; i < 4; ++i) {
            lists.add(new ArrayList<>());
        }
        for (int i = 0; i < fl.size(); ++i) {
            List<List<Byte>> temp1 = new ArrayList<>();
            List<Byte> temp2 = new ArrayList<>();
            temp2.add(fl.get(i));
            temp1.add(temp2);
            lists.set(i, temp1);
        }
        final AtomicReference<List<Byte>> digits = new AtomicReference<>(new ArrayList<>());
        AtomicInteger count = new AtomicInteger();

        // Recursive closure to generate (n+r) candidates from (n-r) candidates
        // and hence find Rare numbers with a given number of digits.
        Consumer7<List<Byte>, List<Byte>, List<List<Byte>>, List<List<Byte>>, Long, Integer, Integer> fnpr = recurse((cand, di, dis, indicies, nmr, nd, level, func) -> {
            if (level == dis.size()) {
                digits.get().set(indicies.get(0).get(0), fml.get(cand.get(0)).get(di.get(0)).get(0));
                digits.get().set(indicies.get(0).get(1), fml.get(cand.get(0)).get(di.get(0)).get(1));
                int le = di.size();
                if (nd % 2 == 1) {
                    le--;
                    digits.get().set(nd / 2, di.get(le));
                }
                for (int i = 1; i < le; ++i) {
                    digits.get().set(indicies.get(i).get(0), dmd.get(cand.get(i)).get(di.get(i)).get(0));
                    digits.get().set(indicies.get(i).get(1), dmd.get(cand.get(i)).get(di.get(i)).get(1));
                }
                long r = toLong(digits.get(), true);
                long npr = nmr + 2 * r;
                if (isNotSquare(npr)) {
                    return;
                }
                count.getAndIncrement();
                System.out.printf("     R/N %2d:", count.get());
                LocalDateTime checkPoint = LocalDateTime.now();
                long elapsed = Duration.between(startTime, checkPoint).toMillis();
                System.out.printf("  %9sms", elapsed);
                long n = toLong(digits.get(), false);
                System.out.printf("  (%s)\n", commatize(n));
                rares.add(n);
            } else {
                for (Byte num : dis.get(level)) {
                    di.set(level, num);
                    func.apply(cand, di, dis, indicies, nmr, nd, level + 1, func);
                }
            }
        });

        // Recursive closure to generate (n-r) candidates with a given number of digits.
        Consumer5<List<Byte>, List<List<Byte>>, List<List<Byte>>, Integer, Integer> fnmr = recurse((cand, list, indicies, nd, level, func) -> {
            if (level == list.size()) {
                long nmr = 0;
                long nmr2 = 0;
                List<Term> terms = allTerms.get(nd - 2);
                for (int i = 0; i < terms.size(); ++i) {
                    Term t = terms.get(i);
                    if (cand.get(i) >= 0) {
                        nmr += t.coeff * cand.get(i);
                    } else {
                        nmr2 += t.coeff * -cand.get(i);
                        if (nmr >= nmr2) {
                            nmr -= nmr2;
                            nmr2 = 0;
                        } else {
                            nmr2 -= nmr;
                            nmr = 0;
                        }
                    }
                }
                if (nmr2 >= nmr) {
                    return;
                }
                nmr -= nmr2;
                if (isNotSquare(nmr)) {
                    return;
                }
                List<List<Byte>> dis = new ArrayList<>();
                dis.add(seq((byte) 0, (byte) (fml.get(cand.get(0)).size() - 1), (byte) 1));
                for (int i = 1; i < cand.size(); ++i) {
                    dis.add(seq((byte) 0, (byte) (dmd.get(cand.get(i)).size() - 1), (byte) 1));
                }
                if (nd % 2 == 1) {
                    dis.add(il);
                }
                List<Byte> di = new ArrayList<>();
                for (int i = 0; i < dis.size(); ++i) {
                    di.add((byte) 0);
                }
                fnpr.apply(cand, di, dis, indicies, nmr, nd, 0);
            } else {
                for (Byte num : list.get(level)) {
                    cand.set(level, num);
                    func.apply(cand, list, indicies, nd, level + 1, func);
                }
            }
        });

        for (int nd = 2; nd <= MAX_DIGITS; ++nd) {
            digits.set(new ArrayList<>());
            for (int i = 0; i < nd; ++i) {
                digits.get().add((byte) 0);
            }
            if (nd == 4) {
                lists.get(0).add(zl);
                lists.get(1).add(ol);
                lists.get(2).add(el);
                lists.get(3).add(ol);
            } else if (allTerms.get(nd - 2).size() > lists.get(0).size()) {
                for (int i = 0; i < 4; ++i) {
                    lists.get(i).add(dl);
                }
            }
            List<List<Byte>> indicies = new ArrayList<>();
            for (Term t : allTerms.get(nd - 2)) {
                indicies.add(List.of(t.ix1, t.ix2));
            }
            for (List<List<Byte>> list : lists) {
                List<Byte> cand = new ArrayList<>();
                for (int i = 0; i < list.size(); ++i) {
                    cand.add((byte) 0);
                }
                fnmr.apply(cand, list, indicies, nd, 0);
            }
            LocalDateTime checkPoint = LocalDateTime.now();
            long elapsed = Duration.between(startTime, checkPoint).toMillis();
            System.out.printf("  %2d digits:  %9sms\n", nd, elapsed);
        }

        Collections.sort(rares);
        System.out.printf("\nThe rare numbers with up to %d digits are:\n", MAX_DIGITS);
        for (int i = 0; i < rares.size(); ++i) {
            System.out.printf("  %2d:  %25s\n", i + 1, commatize(rares.get(i)));
        }
    }
}
