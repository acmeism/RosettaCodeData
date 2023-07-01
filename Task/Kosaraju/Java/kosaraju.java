import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.BiConsumer;
import java.util.function.IntConsumer;
import java.util.stream.Collectors;

public class Kosaraju {
    static class Recursive<I> {
        I func;
    }

    private static List<Integer> kosaraju(List<List<Integer>> g) {
        // 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
        int size = g.size();
        boolean[] vis = new boolean[size];
        int[] l = new int[size];
        AtomicInteger x = new AtomicInteger(size);

        List<List<Integer>> t = new ArrayList<>();
        for (int i = 0; i < size; ++i) {
            t.add(new ArrayList<>());
        }

        Recursive<IntConsumer> visit = new Recursive<>();
        visit.func = (int u) -> {
            if (!vis[u]) {
                vis[u] = true;
                for (Integer v : g.get(u)) {
                    visit.func.accept(v);
                    t.get(v).add(u);
                }
                int xval = x.decrementAndGet();
                l[xval] = u;
            }
        };

        // 2. For each vertex u of the graph do visit(u)
        for (int i = 0; i < size; ++i) {
            visit.func.accept(i);
        }
        int[] c = new int[size];

        Recursive<BiConsumer<Integer, Integer>> assign = new Recursive<>();
        assign.func = (Integer u, Integer root) -> {
            if (vis[u]) {  // repurpose vis to mean 'unassigned'
                vis[u] = false;
                c[u] = root;
                for (Integer v : t.get(u)) {
                    assign.func.accept(v, root);
                }
            }
        };

        // 3: For each element u of l in order, do assign(u, u)
        for (int u : l) {
            assign.func.accept(u, u);
        }

        return Arrays.stream(c).boxed().collect(Collectors.toList());
    }

    public static void main(String[] args) {
        List<List<Integer>> g = new ArrayList<>();
        for (int i = 0; i < 8; ++i) {
            g.add(new ArrayList<>());
        }
        g.get(0).add(1);
        g.get(1).add(2);
        g.get(2).add(0);
        g.get(3).add(1);
        g.get(3).add(2);
        g.get(3).add(4);
        g.get(4).add(3);
        g.get(4).add(5);
        g.get(5).add(2);
        g.get(5).add(6);
        g.get(6).add(5);
        g.get(7).add(4);
        g.get(7).add(6);
        g.get(7).add(7);

        List<Integer> output = kosaraju(g);
        System.out.println(output);
    }
}
