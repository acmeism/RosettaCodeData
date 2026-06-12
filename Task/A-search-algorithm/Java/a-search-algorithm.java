import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

public class AStar {

    private final List<Node> open;
    private final List<Node> closed;
    private final List<Node> path;
    private final int[][] maze;
    private Node now;
    private final int xstart;
    private final int ystart;
    private int xend, yend;
    private final boolean diag;

    /** Node class */
    static class Node implements Comparable<Node> {
        public Node parent;
        public int x, y;
        public double g;
        public double h;

        Node(Node parent, int xpos, int ypos, double g, double h) {
            this.parent = parent;
            this.x = xpos;
            this.y = ypos;
            this.g = g;
            this.h = h;
        }

        @Override
        public int compareTo(Node that) {
            return Double.compare(this.g + this.h, that.g + that.h);
        }
    }

    public AStar(int[][] maze, int xstart, int ystart, boolean diag) {
        this.open = new ArrayList<>();
        this.closed = new ArrayList<>();
        this.path = new ArrayList<>();
        this.maze = maze;
        this.now = new Node(null, xstart, ystart, 0, 0);
        this.xstart = xstart;
        this.ystart = ystart;
        this.diag = diag;
    }

    /** Finds path to xend/yend or returns null */
    public List<Node> findPathTo(int xend, int yend) {
        this.xend = xend;
        this.yend = yend;
        this.closed.add(this.now);
        addNeighborsToOpenList();

        while (this.now.x != this.xend || this.now.y != this.yend) {
            if (this.open.isEmpty()) {
                return null;
            }

            this.now = this.open.remove(0);
            this.closed.add(this.now);
            addNeighborsToOpenList();
        }

        this.path.add(0, this.now);
        while (this.now.parent != null) {
            this.now = this.now.parent;
            this.path.add(0, this.now);
        }
        return this.path;
    }

    private static boolean findNeighborInList(List<Node> list, Node node) {
        return list.stream().anyMatch(n -> n.x == node.x && n.y == node.y);
    }

    private double distance(int dx, int dy) {
        int x = this.now.x + dx;
        int y = this.now.y + dy;
        if (this.diag) {
            return Math.hypot(x - this.xend, y - this.yend);
        } else {
            return Math.abs(x - this.xend) + Math.abs(y - this.yend);
        }
    }

    private void addNeighborsToOpenList() {
        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                if (x == 0 && y == 0) continue;
                if (!this.diag && x != 0 && y != 0) continue;

                int nx = this.now.x + x;
                int ny = this.now.y + y;

                if (nx < 0 || ny < 0 || ny >= maze.length || nx >= maze[0].length)
                    continue;
                if (maze[ny][nx] == -1)
                    continue;

                Node node = new Node(this.now, nx, ny,
                        this.now.g + 1.0 + maze[ny][nx], distance(x, y));

                if (!findNeighborInList(this.open, node) && !findNeighborInList(this.closed, node)) {
                    this.open.add(node);
                }
            }
        }
        Collections.sort(this.open);
    }

    public static void main(String[] args) {
        int[][] maze = {
            {0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0,100,100,100, 0, 0},
            {0, 0, 0, 0, 0,100, 0, 0},
            {0, 0,100, 0, 0,100, 0, 0},
            {0, 0,100, 0, 0,100, 0, 0},
            {0, 0,100,100,100,100, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0},
        };

        AStar as = new AStar(maze, 0, 0, true);
        List<Node> path = as.findPathTo(7, 7);

        if (path != null) {
            for (Node n : path) {
                System.out.print("[" + n.x + ", " + n.y + "] ");
                maze[n.y][n.x] = -1;
            }
            System.out.printf("\nTotal cost: %.02f\n", path.get(path.size() - 1).g);

            for (int[] maze_row : maze) {
                for (int maze_entry : maze_row) {
                    switch (maze_entry) {
                        case 0:  System.out.print("_"); break;
                        case -1: System.out.print("*"); break;
                        default: System.out.print("#"); break;
                    }
                }
                System.out.println();
            }
        } else {
            System.out.println("No path found.");
        }
    }
}
