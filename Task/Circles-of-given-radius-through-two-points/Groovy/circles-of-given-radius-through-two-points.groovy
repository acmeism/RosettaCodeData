class Circles {
    private static class Point {
        private final double x, y

        Point(Double x, Double y) {
            this.x = x
            this.y = y
        }

        double distanceFrom(Point other) {
            double dx = x - other.x
            double dy = y - other.y
            return Math.sqrt(dx * dx + dy * dy)
        }

        @Override
        boolean equals(Object other) {
            //if (this == other) return true
            if (other == null || getClass() != other.getClass()) return false
            Point point = (Point) other
            return x == point.x && y == point.y
        }

        @Override
        String toString() {
            return String.format("(%.4f, %.4f)", x, y)
        }
    }

    private static Point[] findCircles(Point p1, Point p2, double r) {
        if (r < 0.0) throw new IllegalArgumentException("the radius can't be negative")
        if (r == 0.0.toDouble() && p1 != p2) throw new IllegalArgumentException("no circles can ever be drawn")
        if (r == 0.0.toDouble()) return [p1, p1]
        if (Objects.equals(p1, p2)) throw new IllegalArgumentException("an infinite number of circles can be drawn")
        double distance = p1.distanceFrom(p2)
        double diameter = 2.0 * r
        if (distance > diameter) throw new IllegalArgumentException("the points are too far apart to draw a circle")
        Point center = new Point((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0)
        if (distance == diameter) return [center, center]
        double mirrorDistance = Math.sqrt(r * r - distance * distance / 4.0)
        double dx = (p2.x - p1.x) * mirrorDistance / distance
        double dy = (p2.y - p1.y) * mirrorDistance / distance
        return [
            new Point(center.x - dy, center.y + dx),
            new Point(center.x + dy, center.y - dx)
        ]
    }

    static void main(String[] args) {
        Point[] p = [
            new Point(0.1234, 0.9876),
            new Point(0.8765, 0.2345),
            new Point(0.0000, 2.0000),
            new Point(0.0000, 0.0000)
        ]
        Point[][] points = [
            [p[0], p[1]],
            [p[2], p[3]],
            [p[0], p[0]],
            [p[0], p[1]],
            [p[0], p[0]],
        ]
        double[] radii = [2.0, 1.0, 2.0, 0.5, 0.0]
        for (int i = 0; i < radii.length; ++i) {
            Point p1 = points[i][0]
            Point p2 = points[i][1]
            double r = radii[i]
            printf("For points %s and %s with radius %f\n", p1, p2, r)
            try {
                Point[] circles = findCircles(p1, p2, r)
                Point c1 = circles[0]
                Point c2 = circles[1]
                if (Objects.equals(c1, c2)) {
                    printf("there is just one circle with center at %s\n", c1)
                } else {
                    printf("there are two circles with centers at %s and %s\n", c1, c2)
                }
            } catch (IllegalArgumentException ex) {
                println(ex.getMessage())
            }
            println()
        }
    }
}
