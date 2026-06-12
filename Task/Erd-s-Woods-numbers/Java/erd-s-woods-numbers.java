import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class ErdosWoods {

    static class Partition {
        int setA;
        int setB;
        int rPrimes;

        public Partition(int setA, int setB, int rPrimes) {
            this.setA = setA;
            this.setB = setB;
            this.rPrimes = rPrimes;
        }
    }

    public static double erdosWoods(int n) {
        List<Integer> primes = new ArrayList<>();
        int P = 1, k = 1;
        while (k < n) {
            if (P % k != 0) {
                primes.add(k);
            }
            P *= k * k;
            k++;
        }

        int[] divs = new int[n];
        for (int a = 0; a < n; a++) {
            StringBuilder bits = new StringBuilder();
            for (int p : primes) {
                if (a % p == 0) {
                    bits.append("1");
                } else {
                    bits.append("0");
                }
            }
            String revBits = new StringBuilder(bits.toString()).reverse().toString();
            divs[a] = Integer.parseInt(revBits, 2);
        }

        int np = primes.size();
        List<Partition> partitions = new ArrayList<>();
        partitions.add(new Partition(0, 0, (1 << np) - 1));

        List<Integer> indices = new ArrayList<>();
        for (int i = 1; i < n; i++) {
            indices.add(i);
        }

        Collections.sort(indices, new Comparator<Integer>() {
            @Override
            public int compare(Integer i, Integer j) {
                int a = i, b = j;
                String aBits = Integer.toBinaryString(divs[a] | divs[n - a]);
                String bBits = Integer.toBinaryString(divs[b] | divs[n - b]);
                int aPos = aBits.lastIndexOf('1');
                int bPos = bBits.lastIndexOf('1');
                return Integer.compare(bPos, aPos);
            }
        });

        for (int i : indices) {
            List<Partition> newPartitions = new ArrayList<>();
            int factors = divs[i];
            int otherFactors = divs[n - i];
            for (Partition p : partitions) {
                int setA = p.setA, setB = p.setB, rPrimes = p.rPrimes;
                if ((factors & setA) != 0 || (otherFactors & setB) != 0) {
                    newPartitions.add(p);
                    continue;
                }
                String factorsBits = Integer.toBinaryString(factors & rPrimes);
                String reversedFactorsBits = new StringBuilder(factorsBits).reverse().toString();
                for (int ix = 0; ix < reversedFactorsBits.length(); ix++) {
                    if (reversedFactorsBits.charAt(ix) == '1') {
                        int w = 1 << ix;
                        newPartitions.add(new Partition(setA ^ w, setB, rPrimes ^ w));
                    }
                }
                String otherBits = Integer.toBinaryString(otherFactors & rPrimes);
                String reversedOtherBits = new StringBuilder(otherBits).reverse().toString();
                for (int ix = 0; ix < reversedOtherBits.length(); ix++) {
                    if (reversedOtherBits.charAt(ix) == '1') {
                        int w = 1 << ix;
                        newPartitions.add(new Partition(setA, setB ^ w, rPrimes ^ w));
                    }
                }
            }
            partitions = newPartitions;
        }

        double result = Double.POSITIVE_INFINITY;
        for (Partition partition : partitions) {
            int px = partition.setA, py = partition.setB;
            int x = 1, y = 1;
            for (int p : primes) {
                if ((px & 1) != 0) {
                    x *= p;
                }
                if ((py & 1) != 0) {
                    y *= p;
                }
                px >>= 1;
                py >>= 1;
            }
            int inv = modInverse(x, y);
            double val = ((n * inv) % y) * x - n;
            if (val < result) {
                result = val;
            }
        }
        return result;
    }

    private static int modInverse(int a, int m) {
        a = a % m;
        for (int x = 1; x < m; x++) {
            if ((a * x) % m == 1) {
                return x;
            }
        }
        return 1;
    }

    public static void main(String[] args) {
        int K = 3, COUNT = 0;
        System.out.println("The first 20 Erdős--Woods numbers and their minimum interval start values are:");
        while (COUNT < 20) {
            double a = erdosWoods(K);
            if (a != Double.POSITIVE_INFINITY) {
                System.out.printf("%3d -> %.0f%n", K, a);
                COUNT++;
            }
            K++;
        }
    }
}

