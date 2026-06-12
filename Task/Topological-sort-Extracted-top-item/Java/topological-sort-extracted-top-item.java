import java.util.*;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;

public class TopologicalSort2 {

    public static void main(String[] args) {
        String s = "top1,top2,ip1,ip2,ip3,ip1a,ip2a,ip2b,ip2c,ipcommon,des1,"
                + "des1a,des1b,des1c,des1a1,des1a2,des1c1,extra1";

        Graph g = new Graph(s, new int[][]{
            {0, 10}, {0, 2}, {0, 3},
            {1, 10}, {1, 3}, {1, 4},
            {2, 17}, {2, 5}, {2, 9},
            {3, 6}, {3, 7}, {3, 8}, {3, 9},
            {10, 11}, {10, 12}, {10, 13},
            {11, 14}, {11, 15},
            {13, 16}, {13, 17},});

        System.out.println("Top levels: " + g.toplevels());
        String[] files = {"top1", "top2", "ip1"};
        for (String f : files)
            System.out.printf("Compile order for %s %s%n", f, g.compileOrder(f));
    }
}

class Graph {
    List<String> vertices;
    boolean[][] adjacency;
    int numVertices;

    public Graph(String s, int[][] edges) {
        vertices = asList(s.split(","));
        numVertices = vertices.size();
        adjacency = new boolean[numVertices][numVertices];

        for (int[] edge : edges)
            adjacency[edge[0]][edge[1]] = true;
    }

    List<String> toplevels() {
        List<String> result = new ArrayList<>();
        // look for empty columns
        outer:
        for (int c = 0; c < numVertices; c++) {
            for (int r = 0; r < numVertices; r++) {
                if (adjacency[r][c])
                    continue outer;
            }
            result.add(vertices.get(c));
        }
        return result;
    }

    List<String> compileOrder(String item) {
        LinkedList<String> result = new LinkedList<>();
        LinkedList<Integer> queue = new LinkedList<>();

        queue.add(vertices.indexOf(item));

        while (!queue.isEmpty()) {
            int r = queue.poll();
            for (int c = 0; c < numVertices; c++) {
                if (adjacency[r][c] && !queue.contains(c)) {
                    queue.add(c);
                }
            }
            result.addFirst(vertices.get(r));
        }
        return result.stream().distinct().collect(toList());
    }
}
