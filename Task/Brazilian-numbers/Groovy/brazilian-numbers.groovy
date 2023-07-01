import org.codehaus.groovy.GroovyBugError

class Brazilian {
    private static final List<Integer> primeList = new ArrayList<>(Arrays.asList(
            2, 3, 5, 7, 9, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89,
            97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 169, 173, 179, 181,
            191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 247, 251, 257, 263, 269, 271, 277, 281,
            283, 293, 299, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 377, 379, 383, 389,
            397, 401, 403, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 481, 487, 491,
            499, 503, 509, 521, 523, 533, 541, 547, 557, 559, 563, 569, 571, 577, 587, 593, 599, 601, 607,
            611, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 689, 691, 701, 709, 719,
            727, 733, 739, 743, 751, 757, 761, 767, 769, 773, 787, 793, 797, 809, 811, 821, 823, 827, 829,
            839, 853, 857, 859, 863, 871, 877, 881, 883, 887, 907, 911, 919, 923, 929, 937, 941, 947, 949,
            953, 967, 971, 977, 983, 991, 997
    ))

    static boolean isPrime(int n) {
        if (n < 2) {
            return false
        }

        for (Integer prime : primeList) {
            if (n == prime) {
                return true
            }
            if (n % prime == 0) {
                return false
            }
            if (prime * prime > n) {
                return true
            }
        }

        BigInteger bi = BigInteger.valueOf(n)
        return bi.isProbablePrime(10)
    }

    private static boolean sameDigits(int n, int b) {
        int f = n % b
        n = n.intdiv(b)
        while (n > 0) {
            if (n % b != f) {
                return false
            }
            n = n.intdiv(b)
        }
        return true
    }

    private static boolean isBrazilian(int n) {
        if (n < 7) return false
        if (n % 2 == 0) return true
        for (int b = 2; b < n - 1; ++b) {
            if (sameDigits(n, b)) {
                return true
            }
        }
        return false
    }

    static void main(String[] args) {
        for (String kind : Arrays.asList("", "odd ", "prime ")) {
            boolean quiet = false
            int bigLim = 99_999
            int limit = 20
            System.out.printf("First %d %sBrazilian numbers:\n", limit, kind)
            int c = 0
            int n = 7
            while (c < bigLim) {
                if (isBrazilian(n)) {
                    if (!quiet) System.out.printf("%d ", n)
                    if (++c == limit) {
                        System.out.println("\n")
                        quiet = true
                    }
                }
                if (quiet && "" != kind) continue
                switch (kind) {
                    case "":
                        n++
                        break
                    case "odd ":
                        n += 2
                        break
                    case "prime ":
                        while (true) {
                            n += 2
                            if (isPrime(n)) break
                        }
                        break
                    default:
                        throw new GroovyBugError("Oops")
                }
            }
            if ("" == kind) {
                System.out.printf("The %dth Brazilian number is: %d\n\n", bigLim + 1, n)
            }
        }
    }
}
