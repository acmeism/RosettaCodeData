import java.util.*;
import java.awt.geom.*;

public class LineCircleIntersection {
    public static void main(String[] args) {
        try {
            demo();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void demo() throws NoninvertibleTransformException {
        Point2D center = makePoint(3, -5);
        double radius = 3.0;
        System.out.println("The intersection points (if any) between:");
        System.out.println("\n  A circle, center (3, -5) with radius 3, and:");
        System.out.println("\n    a line containing the points (-10, 11) and (10, -9) is/are:");
        System.out.println("     " + toString(intersection(makePoint(-10, 11), makePoint(10, -9),
                            center, radius, false)));
        System.out.println("\n    a segment starting at (-10, 11) and ending at (-11, 12) is/are");
        System.out.println("     " + toString(intersection(makePoint(-10, 11), makePoint(-11, 12),
                            center, radius, true)));
        System.out.println("\n    a horizontal line containing the points (3, -2) and (7, -2) is/are:");
        System.out.println("     " + toString(intersection(makePoint(3, -2), makePoint(7, -2), center, radius, false)));
        center.setLocation(0, 0);
        radius = 4.0;
        System.out.println("\n  A circle, center (0, 0) with radius 4, and:");
        System.out.println("\n    a vertical line containing the points (0, -3) and (0, 6) is/are:");
        System.out.println("     " + toString(intersection(makePoint(0, -3), makePoint(0, 6),
                            center, radius, false)));
        System.out.println("\n    a vertical segment starting at (0, -3) and ending at (0, 6) is/are:");
        System.out.println("     " + toString(intersection(makePoint(0, -3), makePoint(0, 6),
                            center, radius, true)));
        center.setLocation(4, 2);
        radius = 5.0;
        System.out.println("\n  A circle, center (4, 2) with radius 5, and:");
        System.out.println("\n    a line containing the points (6, 3) and (10, 7) is/are:");
        System.out.println("     " + toString(intersection(makePoint(6, 3), makePoint(10, 7),
                            center, radius, false)));
        System.out.println("\n    a segment starting at (7, 4) and ending at (11, 8) is/are:");
        System.out.println("     " + toString(intersection(makePoint(7, 4), makePoint(11, 8),
                            center, radius, true)));
    }

    private static Point2D makePoint(double x, double y) {
        return new Point2D.Double(x, y);
    }

    //
    // If center of the circle is at the origin and the line is horizontal,
    // it's easy to calculate the points of intersection, so to handle the
    // general case, we convert the input to a coordinate system where the
    // center of the circle is at the origin and the line is horizontal,
    // then convert the points of intersection back to the original
    // coordinate system.
    //
    public static List<Point2D> intersection(Point2D p1, Point2D p2, Point2D center,
            double radius, boolean isSegment) throws NoninvertibleTransformException {
        List<Point2D> result = new ArrayList<>();
        double dx = p2.getX() - p1.getX();
        double dy = p2.getY() - p1.getY();
        AffineTransform trans = AffineTransform.getRotateInstance(dx, dy);
        trans.invert();
        trans.translate(-center.getX(), -center.getY());
        Point2D p1a = trans.transform(p1, null);
        Point2D p2a = trans.transform(p2, null);
        double y = p1a.getY();
        double minX = Math.min(p1a.getX(), p2a.getX());
        double maxX = Math.max(p1a.getX(), p2a.getX());
        if (y == radius || y == -radius) {
            if (!isSegment || (0 <= maxX && 0 >= minX)) {
                p1a.setLocation(0, y);
                trans.inverseTransform(p1a, p1a);
                result.add(p1a);
            }
        } else if (y < radius && y > -radius) {
            double x = Math.sqrt(radius * radius - y * y);
            if (!isSegment || (-x <= maxX && -x >= minX)) {
                p1a.setLocation(-x, y);
                trans.inverseTransform(p1a, p1a);
                result.add(p1a);
            }
            if (!isSegment || (x <= maxX && x >= minX)) {
                p2a.setLocation(x, y);
                trans.inverseTransform(p2a, p2a);
                result.add(p2a);
            }
        }
        return result;
    }

    public static String toString(Point2D point) {
        return String.format("(%g, %g)", point.getX(), point.getY());
    }

    public static String toString(List<Point2D> points) {
        StringBuilder str = new StringBuilder("[");
        for (int i = 0, n = points.size(); i < n; ++i) {
            if (i > 0)
                str.append(", ");
            str.append(toString(points.get(i)));
        }
        str.append("]");
        return str.toString();
    }
}
