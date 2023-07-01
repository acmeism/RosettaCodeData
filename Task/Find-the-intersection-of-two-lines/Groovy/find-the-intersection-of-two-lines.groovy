class Intersection {
    private static class Point {
        double x, y

        Point(double x, double y) {
            this.x = x
            this.y = y
        }

        @Override
        String toString() {
            return "($x, $y)"
        }
    }

    private static class Line {
        Point s, e

        Line(Point s, Point e) {
            this.s = s
            this.e = e
        }
    }

    private static Point findIntersection(Line l1, Line l2) {
        double a1 = l1.e.y - l1.s.y
        double b1 = l1.s.x - l1.e.x
        double c1 = a1 * l1.s.x + b1 * l1.s.y

        double a2 = l2.e.y - l2.s.y
        double b2 = l2.s.x - l2.e.x
        double c2 = a2 * l2.s.x + b2 * l2.s.y

        double delta = a1 * b2 - a2 * b1
        return new Point((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta)
    }

    static void main(String[] args) {
        Line l1 = new Line(new Point(4, 0), new Point(6, 10))
        Line l2 = new Line(new Point(0, 3), new Point(10, 7))
        println(findIntersection(l1, l2))

        l1 = new Line(new Point(0, 0), new Point(1, 1))
        l2 = new Line(new Point(1, 2), new Point(4, 5))
        println(findIntersection(l1, l2))
    }
}
