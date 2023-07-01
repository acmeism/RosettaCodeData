import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.BiConsumer;

public class DeBruijn {
    public interface Recursable<T, U> {
        void apply(T t, U u, Recursable<T, U> r);
    }

    public static <T, U> BiConsumer<T, U> recurse(Recursable<T, U> f) {
        return (t, u) -> f.apply(t, u, f);
    }

    private static String deBruijn(int k, int n) {
        byte[] a = new byte[k * n];
        Arrays.fill(a, (byte) 0);

        List<Byte> seq = new ArrayList<>();

        BiConsumer<Integer, Integer> db = recurse((t, p, f) -> {
            if (t > n) {
                if (n % p == 0) {
                    for (int i = 1; i < p + 1; ++i) {
                        seq.add(a[i]);
                    }
                }
            } else {
                a[t] = a[t - p];
                f.apply(t + 1, p, f);
                int j = a[t - p] + 1;
                while (j < k) {
                    a[t] = (byte) (j & 0xFF);
                    f.apply(t + 1, t, f);
                    j++;
                }
            }
        });
        db.accept(1, 1);

        StringBuilder sb = new StringBuilder();
        for (Byte i : seq) {
            sb.append("0123456789".charAt(i));
        }

        sb.append(sb.subSequence(0, n - 1));
        return sb.toString();
    }

    private static boolean allDigits(String s) {
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            if (!Character.isDigit(c)) {
                return false;
            }
        }
        return true;
    }

    private static void validate(String db) {
        int le = db.length();
        int[] found = new int[10_000];
        Arrays.fill(found, 0);
        List<String> errs = new ArrayList<>();

        // Check all strings of 4 consecutive digits within 'db'
        // to see if all 10,000 combinations occur without duplication.
        for (int i = 0; i < le - 3; ++i) {
            String s = db.substring(i, i + 4);
            if (allDigits(s)) {
                int n = Integer.parseInt(s);
                found[n]++;
            }
        }

        for (int i = 0; i < 10_000; ++i) {
            if (found[i] == 0) {
                errs.add(String.format("    PIN number %d is missing", i));
            } else if (found[i] > 1) {
                errs.add(String.format("    PIN number %d occurs %d times", i, found[i]));
            }
        }

        if (errs.isEmpty()) {
            System.out.println("    No errors found");
        } else {
            String pl = (errs.size() == 1) ? "" : "s";
            System.out.printf("  %d error%s found:\n", errs.size(), pl);
            errs.forEach(System.out::println);
        }
    }

    public static void main(String[] args) {
        String db = deBruijn(10, 4);

        System.out.printf("The length of the de Bruijn sequence is %d\n\n", db.length());
        System.out.printf("The first 130 digits of the de Bruijn sequence are: %s\n\n", db.substring(0, 130));
        System.out.printf("The last 130 digits of the de Bruijn sequence are: %s\n\n", db.substring(db.length() - 130));

        System.out.println("Validating the de Bruijn sequence:");
        validate(db);

        StringBuilder sb = new StringBuilder(db);
        String rdb = sb.reverse().toString();
        System.out.println();
        System.out.println("Validating the de Bruijn sequence:");
        validate(rdb);

        sb = new StringBuilder(db);
        sb.setCharAt(4443, '.');
        System.out.println();
        System.out.println("Validating the overlaid de Bruijn sequence:");
        validate(sb.toString());
    }
}
