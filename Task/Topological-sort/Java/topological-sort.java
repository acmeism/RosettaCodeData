import java.util.*;

public class TopologicalSort {

    public static void main(String[] args) {
        String s = "std, ieee, des_system_lib, dw01, dw02, dw03, dw04, dw05,"
                + "dw06, dw07, dware, gtech, ramlib, std_cell_lib, synopsys";

        Graph g = new Graph(s, new int[][]{
            {2, 0}, {2, 14}, {2, 13}, {2, 4}, {2, 3}, {2, 12}, {2, 1},
            {3, 1}, {3, 10}, {3, 11},
            {4, 1}, {4, 10},
            {5, 0}, {5, 14}, {5, 10}, {5, 4}, {5, 3}, {5, 1}, {5, 11},
            {6, 1}, {6, 3}, {6, 10}, {6, 11},
            {7, 1}, {7, 10},
            {8, 1}, {8, 10},
            {9, 1}, {9, 10},
            {10, 1},
            {11, 1}, {11, 10},
            {12, 0}, {12, 1},
            {13, 1}
        });

        System.out.println("Topologically sorted order: ");
        System.out.println(g.topoSort());
    }
}

class Graph {
    String[] vertices;
    boolean[][] adjacency;
    int numVertices;

    public Graph(String s, int[][] edges) {
        vertices = s.split(",");
        numVertices = vertices.length;
        adjacency = new boolean[numVertices][numVertices];

        for (int[] edge : edges)
            adjacency[edge[0]][edge[1]] = true;
    }

    List<String> topoSort() {
        List<String> result = new ArrayList<>();
        List<Integer> todo = new LinkedList<>();

        for (int i = 0; i < numVertices; i++)
            todo.add(i);

        try {
            outer:
            while (!todo.isEmpty()) {
                for (Integer r : todo) {
                    if (!hasDependency(r, todo)) {
                        todo.remove(r);
                        result.add(vertices[r]);
                         // no need to worry about concurrent modification
                        continue outer;
                    }
                }
                throw new Exception("Graph has cycles");
            }
        } catch (Exception e) {
            System.out.println(e);
            return null;
        }
        return result;
    }

    boolean hasDependency(Integer r, List<Integer> todo) {
        for (Integer c : todo) {
            if (adjacency[r][c])
                return true;
        }
        return false;
    }
}
