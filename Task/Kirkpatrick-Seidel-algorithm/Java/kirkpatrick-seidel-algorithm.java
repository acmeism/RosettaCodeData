import java.util.*;
import java.util.stream.Collectors;

public class ConvexHullAlgorithm {

    public static class Point implements Comparable<Point> {
        public double x;
        public double y;

        public Point() {
            this(0, 0);
        }

        public Point(double x, double y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public int compareTo(Point other) {
            if (this.x == other.x) {
                return Double.compare(this.y, other.y);
            }
            return Double.compare(this.x, other.x);
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            Point other = (Point) obj;
            return Double.compare(this.x, other.x) == 0 &&
                   Double.compare(this.y, other.y) == 0;
        }

        @Override
        public int hashCode() {
            return Objects.hash(x, y);
        }

        // Custom comparison methods for clarity (not directly used by collections)
        public boolean isLessThan(Point other) {
            if (this.x == other.x) {
                return this.y < other.y;
            }
            return this.x < other.x;
        }

        public boolean isGreaterThan(Point other) {
            if (this.x == other.x) {
                return this.y > other.y;
            }
            return this.x > other.x;
        }
    }

    private static Random rand = new Random();

    private static List<Point> flipped(Collection<Point> points) {
        List<Point> result = new ArrayList<>();
        for (Point point : points) {
            result.add(new Point(-point.x, -point.y));
        }
        return result;
    }

    private static <T extends Comparable<T>> T quickSelect(List<T> ls, int index) {
        return quickSelect(ls, index, 0, ls.size() - 1);
    }

    private static <T extends Comparable<T>> T quickSelect(List<T> ls, int index, int lo, int hi) {
        if (lo == hi) {
            return ls.get(lo);
        }

        int pivotIndex = lo + rand.nextInt(hi - lo + 1);
        T pivotValue = ls.get(pivotIndex);
        swap(ls, lo, pivotIndex);

        int cur = lo;
        for (int run = lo + 1; run <= hi; run++) {
            if (ls.get(run).compareTo(pivotValue) < 0) {
                cur++;
                swap(ls, cur, run);
            }
        }

        swap(ls, cur, lo);

        if (index < cur) {
            return quickSelect(ls, index, lo, cur - 1);
        } else if (index > cur) {
            return quickSelect(ls, index, cur + 1, hi);
        } else {
            return ls.get(cur);
        }
    }

    private static <T> void swap(List<T> list, int i, int j) {
        T temp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, temp);
    }

    private static Point[] bridge(Set<Point> points, double verticalLine) {
        Set<Point> candidates = new HashSet<>();

        if (points.size() == 2) {
            List<Point> pointList = new ArrayList<>(points);
            pointList.sort(Point::compareTo);
            return new Point[]{pointList.get(0), pointList.get(1)};
        }

        List<Point[]> pairs = new ArrayList<>();
        List<Point> modifyList = new ArrayList<>(points);

        for (int i = 0; i < modifyList.size() / 2 * 2; i += 2) {
            Point p1 = modifyList.get(i);
            Point p2 = modifyList.get(i + 1);
            if (p1.isLessThan(p2)) {
                pairs.add(new Point[]{p1, p2});
            } else {
                pairs.add(new Point[]{p2, p1});
            }
        }

        if (modifyList.size() % 2 == 1) {
            candidates.add(modifyList.get(modifyList.size() - 1));
        }

        List<Double> slopes = new ArrayList<>();
        List<Point[]> validPairs = new ArrayList<>();

        for (Point[] pair : pairs) {
            if (pair[0].x == pair[1].x) {
                candidates.add(pair[0].y > pair[1].y ? pair[0] : pair[1]);
            } else {
                slopes.add((pair[0].y - pair[1].y) / (pair[0].x - pair[1].x));
                validPairs.add(pair);
            }
        }

        if (slopes.isEmpty()) {
            if (candidates.size() >= 2) {
                 List<Point> candidateList = new ArrayList<>(candidates);
                 candidateList.sort(Point::compareTo);
                 return new Point[]{candidateList.get(0), candidateList.get(candidateList.size() - 1)};
            }
            // If we don't have enough candidates, return the first pair
            List<Point> pointList = new ArrayList<>(points);
            return new Point[]{pointList.get(0), pointList.get(1)};
        }

        int medianIndex = slopes.size() / 2 - (slopes.size() % 2 == 0 ? 1 : 0);
        double medianSlope = quickSelect(slopes, medianIndex);

        Set<Point[]> small = new HashSet<>();
        Set<Point[]> equal = new HashSet<>();
        Set<Point[]> large = new HashSet<>();

        for (int i = 0; i < slopes.size(); i++) {
            if (slopes.get(i) < medianSlope) {
                small.add(validPairs.get(i));
            } else if (slopes.get(i) == medianSlope) {
                equal.add(validPairs.get(i));
            } else {
                large.add(validPairs.get(i));
            }
        }

        double maxIntercept = Double.NEGATIVE_INFINITY;
        for (Point point : points) {
            maxIntercept = Math.max(maxIntercept, point.y - medianSlope * point.x);
        }

        List<Point> maxSet = new ArrayList<>();
        for (Point point : points) {
            if (point.y - medianSlope * point.x == maxIntercept) {
                maxSet.add(point);
            }
        }

        Point left = Collections.min(maxSet);
        Point right = Collections.max(maxSet);

        if (left.x <= verticalLine && right.x > verticalLine) {
            return new Point[]{left, right};
        }

        if (right.x <= verticalLine) {
            for (Point[] pair : large) {
                candidates.add(pair[1]);
            }
            for (Point[] pair : equal) {
                candidates.add(pair[1]);
            }
            for (Point[] pair : small) {
                candidates.add(pair[0]);
                candidates.add(pair[1]);
            }
        }

        if (left.x > verticalLine) {
            for (Point[] pair : small) {
                candidates.add(pair[0]);
            }
            for (Point[] pair : equal) {
                candidates.add(pair[0]);
            }
            for (Point[] pair : large) {
                candidates.add(pair[0]);
                candidates.add(pair[1]);
            }
        }

        return bridge(candidates, verticalLine);
    }

    private static List<Point> connect(Point lower, Point upper, Set<Point> points) {
        if (lower.equals(upper)) {
            return new ArrayList<>(Arrays.asList(lower));
        }

        List<Point> pointsVec = new ArrayList<>(points);
        pointsVec.sort(Point::compareTo);

        int midIndex = (pointsVec.size() - 1) / 2;

        Point maxLeft = quickSelect(pointsVec, midIndex);
        Point minRight = quickSelect(pointsVec, midIndex + 1);

        Point[] bridgePoints = bridge(points, (maxLeft.x + minRight.x) / 2);
        Point left = bridgePoints[0];
        Point right = bridgePoints[1];

        Set<Point> pointsLeft = new HashSet<>(Arrays.asList(left));
        Set<Point> pointsRight = new HashSet<>(Arrays.asList(right));

        for (Point point : points) {
            if (point.x < left.x) {
                pointsLeft.add(point);
            } else if (point.x > right.x) {
                pointsRight.add(point);
            }
        }

        List<Point> leftResult = connect(lower, left, pointsLeft);
        List<Point> rightResult = connect(right, upper, pointsRight);

        leftResult.addAll(rightResult);
        return leftResult;
    }

    private static List<Point> upperHull(Set<Point> points) {
        Point lower = Collections.min(points);

        // Find the lowest point with the same x-coordinate as the minimum
        for (Point point : points) {
            if (point.x == lower.x && point.y > lower.y) {
                lower = point;
            }
        }

        Point upper = Collections.max(points);

        Set<Point> filteredPoints = new HashSet<>(Arrays.asList(lower, upper));
        for (Point p : points) {
            if (lower.x < p.x && p.x < upper.x) {
                filteredPoints.add(p);
            }
        }

        return connect(lower, upper, filteredPoints);
    }

    public static List<Point> convexHull(Set<Point> points) {
        List<Point> upper = upperHull(points);

        Set<Point> flippedPoints = new HashSet<>();
        for (Point p : points) {
            flippedPoints.add(new Point(-p.x, -p.y));
        }

        List<Point> flippedUpper = upperHull(flippedPoints);
        List<Point> lower = flipped(flippedUpper);

        // Remove duplicate points at the start/end
        if (!upper.isEmpty() && !lower.isEmpty()) {
            if (upper.get(upper.size() - 1).equals(lower.get(0))) {
                upper.remove(upper.size() - 1);
            }

            if (upper.get(0).equals(lower.get(lower.size() - 1))) {
                lower.remove(lower.size() - 1);
            }
        }

        List<Point> result = new ArrayList<>(upper);
        result.addAll(lower);

        return result;
    }

    // Test case for a simplex
    public static void main(String[] args) {
        // Create points for a 2D projection of a 3D simplex
        Set<Point> points = new HashSet<>(Arrays.asList(
                new Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
                new Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
                new Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
                new Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
        ));

        System.out.println("Input points:");
        for (Point p : points) {
            System.out.println("(" + p.x + ", " + p.y + ")");
        }

        List<Point> hull = convexHull(points);

        System.out.println("\nConvex hull points:");
        for (Point p : hull) {
            System.out.println("(" + p.x + ", " + p.y + ")");
        }
    }
}
