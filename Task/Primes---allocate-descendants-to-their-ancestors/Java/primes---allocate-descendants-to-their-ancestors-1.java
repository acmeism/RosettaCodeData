import java.io.*;
import java.util.*;

public class PrimeDescendants {
    public static void main(String[] args) {
        try (Writer writer = new BufferedWriter(new OutputStreamWriter(System.out))) {
            printPrimeDesc(writer, 100);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    private static void printPrimeDesc(Writer writer, int limit) throws IOException {
        List<Long> primes = findPrimes(limit);

        List<Long> ancestor = new ArrayList<>(limit);
        List<List<Long>> descendants = new ArrayList<>(limit);
        for (int i = 0; i < limit; ++i) {
            ancestor.add(Long.valueOf(0));
            descendants.add(new ArrayList<Long>());
        }

        for (Long prime : primes) {
            int p = prime.intValue();
            descendants.get(p).add(prime);
            for (int i = 0; i + p < limit; ++i) {
                int s = i + p;
                for (Long n : descendants.get(i)) {
                    Long prod = n * p;
                    descendants.get(s).add(prod);
                    if (prod < limit)
                        ancestor.set(prod.intValue(), Long.valueOf(s));
                }
            }
        }

        // print the results
        int totalDescendants = 0;
        for (int i = 1; i < limit; ++i) {
            List<Long> ancestors = getAncestors(ancestor, i);
            writer.write("[" + i + "] Level: " + ancestors.size() + "\n");
            writer.write("Ancestors: ");
            Collections.sort(ancestors);
            print(writer, ancestors);

            writer.write("Descendants: ");
            List<Long> desc = descendants.get(i);
            if (!desc.isEmpty()) {
                Collections.sort(desc);
                if (desc.get(0) == i)
                    desc.remove(0);
            }
            writer.write(desc.size() + "\n");
            totalDescendants += desc.size();
            if (!desc.isEmpty())
                print(writer, desc);
            writer.write("\n");
        }
        writer.write("Total descendants: " + totalDescendants + "\n");
    }

    // find the prime numbers up to limit
    private static List<Long> findPrimes(int limit) {
        boolean[] isprime = new boolean[limit];
        Arrays.fill(isprime, true);
        isprime[0] = isprime[1] = false;
        for (int p = 2; p * p < limit; ++p) {
            if (isprime[p]) {
                for (int i = p * p; i < limit; i += p)
                    isprime[i] = false;
            }
        }
        List<Long> primes = new ArrayList<>();
        for (int p = 2; p < limit; ++p) {
            if (isprime[p])
                primes.add(Long.valueOf(p));
        }
        return primes;
    }

    // returns all ancestors of n. n is not its own ancestor.
    private static List<Long> getAncestors(List<Long> ancestor, int n) {
        List<Long> result = new ArrayList<>();
        for (Long a = ancestor.get(n); a != 0 && a != n; ) {
            n = a.intValue();
            a = ancestor.get(n);
            result.add(Long.valueOf(n));
        }
        return result;
    }

    private static void print(Writer writer, List<Long> list) throws IOException {
        if (list.isEmpty()) {
            writer.write("none\n");
            return;
        }
        int i = 0;
        writer.write(String.valueOf(list.get(i++)));
        for (; i != list.size(); ++i)
            writer.write(", " + list.get(i));
        writer.write("\n");
    }
}
