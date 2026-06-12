public class AdditionChains {
    private static class Pair {
        int f, s;

        Pair(int f, int s) {
            this.f = f;
            this.s = s;
        }
    }

    private static int[] prepend(int n, int[] seq) {
        int[] result = new int[seq.length + 1];
        result[0] = n;
        System.arraycopy(seq, 0, result, 1, seq.length);
        return result;
    }

    private static Pair check_seq(int pos, int[] seq, int n, int min_len) {
        if (pos > min_len || seq[0] > n) return new Pair(min_len, 0);
        else if (seq[0] == n) return new Pair(pos, 1);
        else if (pos < min_len) return try_perm(0, pos, seq, n, min_len);
        else return new Pair(min_len, 0);
    }

    private static Pair try_perm(int i, int pos, int[] seq, int n, int min_len) {
        if (i > pos) return new Pair(min_len, 0);

        Pair res1 = check_seq(pos + 1, prepend(seq[0] + seq[i], seq), n, min_len);
        Pair res2 = try_perm(i + 1, pos, seq, n, res1.f);

        if (res2.f < res1.f) return res2;
        else if (res2.f == res1.f) return new Pair(res2.f, res1.s + res2.s);
        else throw new RuntimeException("Try_perm exception");
    }

    private static Pair init_try_perm(int x) {
        return try_perm(0, 0, new int[]{1}, x, 12);
    }

    private static void find_brauer(int num) {
        Pair res = init_try_perm(num);
        System.out.println();
        System.out.println("N = " + num);
        System.out.println("Minimum length of chains: L(n)= " + res.f);
        System.out.println("Number of minimum length Brauer chains: " + res.s);
    }

    public static void main(String[] args) {
        int[] nums = new int[]{7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379};
        for (int i : nums) {
            find_brauer(i);
        }
    }
}
