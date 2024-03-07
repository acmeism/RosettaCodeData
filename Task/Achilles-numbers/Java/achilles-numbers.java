import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AchillesNumbers {

    private Map<Integer, Boolean> pps = new HashMap<>();

    public int totient(int n) {
        int tot = n;
        int i = 2;
        while (i * i <= n) {
            if (n % i == 0) {
                while (n % i == 0) {
                    n /= i;
                }
                tot -= tot / i;
            }
            if (i == 2) {
                i = 1;
            }
            i += 2;
        }
        if (n > 1) {
            tot -= tot / n;
        }
        return tot;
    }

    public void getPerfectPowers(int maxExp) {
        double upper = Math.pow(10, maxExp);
        for (int i = 2; i <= Math.sqrt(upper); i++) {
            double fi = i;
            double p = fi;
            while (true) {
                p *= fi;
                if (p >= upper) {
                    break;
                }
                pps.put((int) p, true);
            }
        }
    }

    public Map<Integer, Boolean> getAchilles(int minExp, int maxExp) {
        double lower = Math.pow(10, minExp);
        double upper = Math.pow(10, maxExp);
        Map<Integer, Boolean> achilles = new HashMap<>();
        for (int b = 1; b <= (int) Math.cbrt(upper); b++) {
            int b3 = b * b * b;
            for (int a = 1; a <= (int) Math.sqrt(upper); a++) {
                int p = b3 * a * a;
                if (p >= (int) upper) {
                    break;
                }
                if (p >= (int) lower) {
                    if (!pps.containsKey(p)) {
                        achilles.put(p, true);
                    }
                }
            }
        }
        return achilles;
    }

    public static void main(String[] args) {
        AchillesNumbers an = new AchillesNumbers();

        int maxDigits = 8;
        an.getPerfectPowers(maxDigits);
        Map<Integer, Boolean> achillesSet = an.getAchilles(1, 5);
        List<Integer> achilles = new ArrayList<>(achillesSet.keySet());
        Collections.sort(achilles);

        System.out.println("First 50 Achilles numbers:");
        for (int i = 0; i < 50; i++) {
            System.out.printf("%4d ", achilles.get(i));
            if ((i + 1) % 10 == 0) {
                System.out.println();
            }
        }

        System.out.println("\nFirst 30 strong Achilles numbers:");
        List<Integer> strongAchilles = new ArrayList<>();
        int count = 0;
        for (int n = 0; count < 30; n++) {
            int tot = an.totient(achilles.get(n));
            if (achillesSet.containsKey(tot)) {
                strongAchilles.add(achilles.get(n));
                count++;
            }
        }
        for (int i = 0; i < 30; i++) {
            System.out.printf("%5d ", strongAchilles.get(i));
            if ((i + 1) % 10 == 0) {
                System.out.println();
            }
        }

        System.out.println("\nNumber of Achilles numbers with:");
        for (int d = 2; d <= maxDigits; d++) {
            int ac = an.getAchilles(d - 1, d).size();
            System.out.printf("%2d digits: %d\n", d, ac);
        }
    }
}
