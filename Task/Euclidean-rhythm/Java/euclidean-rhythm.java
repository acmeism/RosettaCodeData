import java.util.ArrayList;
import java.util.List;

public class SequenceGenerator {

    public static void main(String[] args) {
        String result = generateSequence(5, 13);
        System.out.println(result); // Should print 1001010010100
    }

    public static String generateSequence(int k, int n) {
        List<List<Integer>> s = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            List<Integer> innerList = new ArrayList<>();
            if (i < k) {
                innerList.add(1);
            } else {
                innerList.add(0);
            }
            s.add(innerList);
        }

        int d = n - k;
        n = Math.max(k, d);
        k = Math.min(k, d);
        int z = d;

        while (z > 0 || k > 1) {
            for (int i = 0; i < k; i++) {
                s.get(i).addAll(s.get(s.size() - 1 - i));
            }
            s = s.subList(0, s.size() - k);
            z -= k;
            d = n - k;
            n = Math.max(k, d);
            k = Math.min(k, d);
        }

        StringBuilder result = new StringBuilder();
        for (List<Integer> sublist : s) {
            for (int item : sublist) {
                result.append(item);
            }
        }
        return result.toString();
    }
}
