import java.awt.Point;
import java.util.*;
import static java.util.Arrays.asList;
import java.util.function.Function;
import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

public class FreePolyominoesEnum {
    static final List<Function<Point, Point>> transforms = new ArrayList<>();

    static {
        transforms.add(p -> new Point(p.y, -p.x));
        transforms.add(p -> new Point(-p.x, -p.y));
        transforms.add(p -> new Point(-p.y, p.x));
        transforms.add(p -> new Point(-p.x, p.y));
        transforms.add(p -> new Point(-p.y, -p.x));
        transforms.add(p -> new Point(p.x, -p.y));
        transforms.add(p -> new Point(p.y, p.x));
    }

    static Point findMinima(List<Point> poly) {
        return new Point(
                poly.stream().mapToInt(a -> a.x).min().getAsInt(),
                poly.stream().mapToInt(a -> a.y).min().getAsInt());
    }

    static List<Point> translateToOrigin(List<Point> poly) {
        final Point min = findMinima(poly);
        poly.replaceAll(p -> new Point(p.x - min.x, p.y - min.y));
        return poly;
    }

    static List<List<Point>> rotationsAndReflections(List<Point> poly) {
        List<List<Point>> lst = new ArrayList<>();
        lst.add(poly);
        for (Function<Point, Point> t : transforms)
            lst.add(poly.stream().map(t).collect(toList()));
        return lst;
    }

    static Comparator<Point> byCoords = Comparator.<Point>comparingInt(p -> p.x)
            .thenComparingInt(p -> p.y);

    static List<Point> normalize(List<Point> poly) {
        return rotationsAndReflections(poly).stream()
                .map(lst -> translateToOrigin(lst))
                .map(lst -> lst.stream().sorted(byCoords).collect(toList()))
                .min(comparing(Object::toString)) // not efficient but simple
                .get();
    }

    static List<Point> neighborhoods(Point p) {
        return asList(new Point(p.x - 1, p.y), new Point(p.x + 1, p.y),
                new Point(p.x, p.y - 1), new Point(p.x, p.y + 1));
    }

    static List<Point> concat(List<Point> lst, Point pt) {
        List<Point> r = new ArrayList<>();
        r.addAll(lst);
        r.add(pt);
        return r;
    }

    static List<Point> newPoints(List<Point> poly) {
        return poly.stream()
                .flatMap(p -> neighborhoods(p).stream())
                .filter(p -> !poly.contains(p))
                .distinct()
                .collect(toList());
    }

    static List<List<Point>> constructNextRank(List<Point> poly) {
        return newPoints(poly).stream()
                .map(p -> normalize(concat(poly, p)))
                .distinct()
                .collect(toList());
    }

    static List<List<Point>> rank(int n) {
        if (n < 0)
            throw new IllegalArgumentException("n cannot be negative");

        if (n < 2) {
            List<List<Point>> r = new ArrayList<>();
            if (n == 1)
                r.add(asList(new Point(0, 0)));
            return r;
        }

        return rank(n - 1).stream()
                .parallel()
                .flatMap(lst -> constructNextRank(lst).stream())
                .distinct()
                .collect(toList());
    }

    public static void main(String[] args) {
        for (List<Point> poly : rank(5)) {
            for (Point p : poly)
                System.out.printf("(%d,%d) ", p.x, p.y);
            System.out.println();
        }
    }
}
