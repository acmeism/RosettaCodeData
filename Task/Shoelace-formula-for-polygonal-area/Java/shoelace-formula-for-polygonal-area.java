import java.util.List;

public class ShoelaceFormula {
    private static class Point {
        int x, y;

        Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public String toString() {
            return String.format("(%d, %d)", x, y);
        }
    }

    private static double shoelaceArea(List<Point> v) {
        int n = v.size();
        double a = 0.0;
        for (int i = 0; i < n - 1; i++) {
            a += v.get(i).x * v.get(i + 1).y - v.get(i + 1).x * v.get(i).y;
        }
        return Math.abs(a + v.get(n - 1).x * v.get(0).y - v.get(0).x * v.get(n - 1).y) / 2.0;
    }

    public static void main(String[] args) {
        List<Point> v = List.of(
            new Point(3, 4),
            new Point(5, 11),
            new Point(12, 8),
            new Point(9, 5),
            new Point(5, 6)
        );
        double area = shoelaceArea(v);
        System.out.printf("Given a polygon with vertices %s,%n", v);
        System.out.printf("its area is %f,%n", area);
    }
}
