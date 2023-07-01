import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {
    private static List<List<Integer>> fourFaceCombos() {
        List<List<Integer>> res = new ArrayList<>();
        Set<Integer> found = new HashSet<>();

        for (int i = 1; i <= 4; i++) {
            for (int j = 1; j <= 4; j++) {
                for (int k = 1; k <= 4; k++) {
                    for (int l = 1; l <= 4; l++) {
                        List<Integer> c = IntStream.of(i, j, k, l).sorted().boxed().collect(Collectors.toList());

                        int key = 64 * (c.get(0) - 1) + 16 * (c.get(1) - 1) + 4 * (c.get(2) - 1) + (c.get(3) - 1);
                        if (found.add(key)) {
                            res.add(c);
                        }
                    }
                }
            }
        }

        return res;
    }

    private static int cmp(List<Integer> x, List<Integer> y) {
        int xw = 0;
        int yw = 0;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                if (x.get(i) > y.get(j)) {
                    xw++;
                } else if (x.get(i) < y.get(j)) {
                    yw++;
                }
            }
        }
        return Integer.compare(xw, yw);
    }

    private static List<List<List<Integer>>> findIntransitive3(List<List<Integer>> cs) {
        int c = cs.size();
        List<List<List<Integer>>> res = new ArrayList<>();

        for (int i = 0; i < c; i++) {
            for (int j = 0; j < c; j++) {
                if (cmp(cs.get(i), cs.get(j)) == -1) {
                    for (List<Integer> kl : cs) {
                        if (cmp(cs.get(j), kl) == -1 && cmp(kl, cs.get(i)) == -1) {
                            res.add(List.of(cs.get(i), cs.get(j), kl));
                        }
                    }
                }
            }
        }

        return res;
    }

    private static List<List<List<Integer>>> findIntransitive4(List<List<Integer>> cs) {
        int c = cs.size();
        List<List<List<Integer>>> res = new ArrayList<>();

        for (int i = 0; i < c; i++) {
            for (int j = 0; j < c; j++) {
                if (cmp(cs.get(i), cs.get(j)) == -1) {
                    for (int k = 0; k < cs.size(); k++) {
                        if (cmp(cs.get(j), cs.get(k)) == -1) {
                            for (List<Integer> ll : cs) {
                                if (cmp(cs.get(k), ll) == -1 && cmp(ll, cs.get(i)) == -1) {
                                    res.add(List.of(cs.get(i), cs.get(j), cs.get(k), ll));
                                }
                            }
                        }
                    }
                }
            }
        }

        return res;
    }

    public static void main(String[] args) {
        List<List<Integer>> combos = fourFaceCombos();
        System.out.printf("Number of eligible 4-faced dice: %d%n", combos.size());
        System.out.println();

        List<List<List<Integer>>> it3 = findIntransitive3(combos);
        System.out.printf("%d ordered lists of 3 non-transitive dice found, namely:%n", it3.size());
        for (List<List<Integer>> a : it3) {
            System.out.println(a);
        }
        System.out.println();

        List<List<List<Integer>>> it4 = findIntransitive4(combos);
        System.out.printf("%d ordered lists of 4 non-transitive dice found, namely:%n", it4.size());
        for (List<List<Integer>> a : it4) {
            System.out.println(a);
        }
    }
}
