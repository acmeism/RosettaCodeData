import java.util.*;

public class KdTreeTest {
    public static void main(String[] args) {
        testWikipedia();
        System.out.println();
        testRandom(1000);
        System.out.println();
        testRandom(1000000);
    }

    private static void testWikipedia() {
        double[][] coords = {
            { 2, 3 }, { 5, 4 }, { 9, 6 }, { 4, 7 }, { 8, 1 }, { 7, 2 }
        };
        List<KdTree.Node> nodes = new ArrayList<>();
        for (int i = 0; i < coords.length; ++i)
            nodes.add(new KdTree.Node(coords[i]));
        KdTree tree = new KdTree(2, nodes);
        KdTree.Node nearest = tree.findNearest(new KdTree.Node(9, 2));
        System.out.println("Wikipedia example data:");
        System.out.println("nearest point: " + nearest);
        System.out.println("distance: " + tree.distance());
        System.out.println("nodes visited: " + tree.visited());
    }

    private static KdTree.Node randomPoint(Random random) {
        double x = random.nextDouble();
        double y = random.nextDouble();
        double z = random.nextDouble();
        return new KdTree.Node(x, y, z);
    }

    private static void testRandom(int points) {
        Random random = new Random();
        List<KdTree.Node> nodes = new ArrayList<>();
        for (int i = 0; i < points; ++i)
            nodes.add(randomPoint(random));
        KdTree tree = new KdTree(3, nodes);
        KdTree.Node target = randomPoint(random);
        KdTree.Node nearest = tree.findNearest(target);
        System.out.println("Random data (" + points + " points):");
        System.out.println("target: " + target);
        System.out.println("nearest point: " + nearest);
        System.out.println("distance: " + tree.distance());
        System.out.println("nodes visited: " + tree.visited());
    }
}
