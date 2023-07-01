import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.stream.IntStream;


public class Pancake {

    private static List<Integer> flipStack(List<Integer> stack, int spatula) {
        List<Integer> copy = new ArrayList<>(stack);
        Collections.reverse(copy.subList(0, spatula));
        return copy;
    }

    private static Map.Entry<List<Integer>, Integer> pancake(int n) {
        List<Integer> initialStack = IntStream.rangeClosed(1, n).boxed().collect(toList());
        Map<List<Integer>, Integer> stackFlips = new HashMap<>();
        stackFlips.put(initialStack, 1);
        Queue<List<Integer>> queue = new ArrayDeque<>();
        queue.add(initialStack);
        while (!queue.isEmpty()) {
            List<Integer> stack = queue.remove();
            int flips = stackFlips.get(stack) + 1;
            for (int i = 2; i <= n; ++i) {
                List<Integer> flipped = flipStack(stack, i);
                if (stackFlips.putIfAbsent(flipped, flips) == null) {
                    queue.add(flipped);
                }
            }
        }
        return stackFlips.entrySet().stream().max(comparing(e -> e.getValue())).get();
    }

    public static void main(String[] args) {
        for (int i = 1; i <= 10; ++i) {
            Map.Entry<List<Integer>, Integer> result = pancake(i);
            System.out.printf("pancake(%s) = %s. Example: %s\n", i, result.getValue(), result.getKey());
        }
    }
}
