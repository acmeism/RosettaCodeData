import java.util.*;


class PolygonClipper {

    public static boolean isInPolygon(Point point, Polygon poly) {
        int x = point.x;
        int y = point.y;
        boolean inside = false;
        int j = poly.points.size() - 1;

        for (int i = 0; i < poly.points.size(); i++) {
            int xi = poly.points.get(i).x;
            int yi = poly.points.get(i).y;
            int xj = poly.points.get(j).x;
            int yj = poly.points.get(j).y;

            boolean intersect = ((yi > y) != (yj > y)) &&
                              (x < (double)(xj - xi) * (y - yi) / (yj - yi) + xi);

            if (intersect) {
                inside = !inside;
            }

            j = i;
        }

        return inside;
    }

    public static int distanceCmp(Point self, Point first, Point second) {
        int dstFirst = Math.abs(self.x - first.x) + Math.abs(self.y - first.y);
        int dstSecond = Math.abs(self.x - second.x) + Math.abs(self.y - second.y);

        if (dstFirst < dstSecond) {
            return -1;
        } else if (dstFirst > dstSecond) {
            return 1;
        } else {
            return 0;
        }
    }

    public static boolean isInLine(Point point, Line line) {
        int dxc = point.x - line.start.x;
        int dyc = point.y - line.start.y;

        int dxl = line.end.x - line.start.x;
        int dyl = line.end.y - line.start.y;

        int cross = dxc * dyl - dyc * dxl;

        if (cross != 0) {
            return false;
        }

        if (Math.abs(dxl) >= Math.abs(dyl)) {
            if (dxl > 0) {
                return line.start.x <= point.x && point.x <= line.end.x;
            } else {
                return line.end.x <= point.x && point.x <= line.start.x;
            }
        } else {
            if (dyl > 0) {
                return line.start.y <= point.y && point.y <= line.end.y;
            } else {
                return line.end.y <= point.y && point.y <= line.start.y;
            }
        }
    }

    public static Optional<Point> getIntersection(Line self, Line line) {
        Point line1Start = self.start;
        Point line1End = self.end;
        Point line2Start = line.start;
        Point line2End = line.end;

        int den = ((line2End.y - line2Start.y) * (line1End.x - line1Start.x)) -
                  ((line2End.x - line2Start.x) * (line1End.y - line1Start.y));

        if (den == 0) {
            return Optional.empty();
        }

        int a = line1Start.y - line2Start.y;
        int b = line1Start.x - line2Start.x;

        int num1 = ((line2End.x - line2Start.x) * a) - ((line2End.y - line2Start.y) * b);
        int num2 = ((line1End.x - line1Start.x) * a) - ((line1End.y - line1Start.y) * b);

        double aF = (double)num1 / (double)den;
        double bF = (double)num2 / (double)den;

        if (aF < 0.0 || aF > 1.0 || bF < 0.0 || bF > 1.0) {
            return Optional.empty();
        }

        Point result = new Point(
            line1Start.x + (int)Math.round(aF * (line1End.x - line1Start.x)),
            line1Start.y + (int)Math.round(aF * (line1End.y - line1Start.y))
        );

        return Optional.of(result);
    }

    public static boolean isClockwise(Polygon poly) {
        int sum = 0;
        for (int i = 0; i < poly.points.size(); i++) {
            int j = (i != poly.points.size() - 1) ? i + 1 : 0;
            sum += (poly.points.get(j).x - poly.points.get(i).x) * (poly.points.get(j).y + poly.points.get(i).y);
        }
        return sum < 0;
    }

    public static Polygon getReversed(Polygon poly) {
        List<Point> reversedPoints = new ArrayList<>(poly.points);
        Collections.reverse(reversedPoints);
        return new Polygon(reversedPoints);
    }

    public static Optional<Integer> getFirstOutsideVertexIndex(Polygon subject, Polygon poly) {
        for (int i = 0; i < subject.points.size(); i++) {
            if (!isInPolygon(subject.points.get(i), poly)) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }

    public static Optional<Integer> getFirstInsideVertexIndex(Polygon subject, Polygon poly) {
        for (int i = 0; i < subject.points.size(); i++) {
            if (isInPolygon(subject.points.get(i), poly)) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }

    public static List<InterVertex> getIntersectionsWithLine(Polygon poly, Line line, boolean[] cursorInside) {
        List<Point> intersections = new ArrayList<>();

        for (int i = 0; i < poly.points.size(); i++) {
            Point start = poly.points.get(i);
            int nextI = (i == poly.points.size() - 1) ? 0 : i + 1;
            Point end = poly.points.get(nextI);

            Line l = new Line(start, end);
            Optional<Point> intersection = getIntersection(l, line);

            if (intersection.isPresent() &&
                !intersection.get().equals(line.start) &&
                !intersection.get().equals(line.end) &&
                !intersection.get().equals(start) &&
                !intersection.get().equals(end)) {
                intersections.add(intersection.get());
            }
        }

        intersections.sort((a, b) -> distanceCmp(line.start, a, b));

        List<InterVertex> result = new ArrayList<>();
        for (Point x : intersections) {
            if (cursorInside[0]) {
                cursorInside[0] = !cursorInside[0];
                result.add(new InterVertex(InterVertexType.OutIntersection, x));
            } else {
                cursorInside[0] = !cursorInside[0];
                result.add(new InterVertex(InterVertexType.InIntersection, x));
            }
        }

        return result;
    }

    public static PolyListOption getInterVertexList(Polygon subject, Polygon poly) {
        Polygon subjectCopy = subject;
        if (!isClockwise(subjectCopy)) {
            subjectCopy = getReversed(subjectCopy);
        }

        boolean[] cursorInside = {false};
        int intersectionCount = 0;

        Optional<Integer> startIndexOpt = getFirstOutsideVertexIndex(subjectCopy, poly);
        if (startIndexOpt.isPresent()) {
            int startIndex = startIndexOpt.get();

            if (!getFirstInsideVertexIndex(subjectCopy, poly).isPresent()) {
                boolean allInside = true;
                for (Point point : poly.points) {
                    if (!isInPolygon(point, subjectCopy)) {
                        allInside = false;
                        break;
                    }
                }

                if (allInside) {
                    return new PolyListOption(PolyListOptionType.InsidePoly, new ArrayList<>(), poly.points);
                }
            }

            List<InterVertex> result = new ArrayList<>();

            for (int iOffset = 0; iOffset < subjectCopy.points.size(); iOffset++) {
                int i = (startIndex + iOffset) % subjectCopy.points.size();
                Point start = subjectCopy.points.get(i);

                // Check vertex
                if (i != startIndex && isInPolygon(start, poly)) {
                    result.add(new InterVertex(InterVertexType.InsideVertex, start));
                } else {
                    result.add(new InterVertex(InterVertexType.OutsideVertex, start));
                }

                // Check intersection
                int nextI = (i == subjectCopy.points.size() - 1) ? 0 : i + 1;
                Point end = subjectCopy.points.get(nextI);
                Line line = new Line(start, end);

                List<InterVertex> intersections = getIntersectionsWithLine(poly, line, cursorInside);
                intersectionCount += intersections.size();

                result.addAll(intersections);
            }

            // Check if there are any intersections
            boolean hasIntersections = false;
            for (InterVertex vertex : result) {
                if (vertex.type == InterVertexType.InIntersection ||
                    vertex.type == InterVertexType.OutIntersection) {
                    hasIntersections = true;
                    break;
                }
            }

            if (!hasIntersections) {
                return new PolyListOption(PolyListOptionType.None, new ArrayList<>(), new ArrayList<>());
            } else {
                return new PolyListOption(PolyListOptionType.List, result, new ArrayList<>());
            }
        } else {
            return new PolyListOption(PolyListOptionType.InsidePoly, new ArrayList<>(), subjectCopy.points);
        }
    }

    public static class PointsPair {
        List<Point> points;
        Point lastPoint;

        public PointsPair(List<Point> points, Point lastPoint) {
            this.points = points;
            this.lastPoint = lastPoint;
        }
    }

    public static Optional<PointsPair> collectFromList(List<InterVertex> list, Point startPoint) {
        boolean initialVertexNotFound = true;
        Optional<Point> lastPoint = Optional.empty();
        int startI = 0, endI = 0;
        boolean dontSkip = list.get(0).getPoint().equals(startPoint);

        List<Point> points = new ArrayList<>();
        int i = 0;

        // Skip until InIntersection occurs, but include the InIntersection
        while (i < list.size() && initialVertexNotFound && !dontSkip) {
            int next = (i == list.size() - 1) ? 0 : i + 1;
            InterVertex nextPoint = list.get(next);

            if (nextPoint.type == InterVertexType.InIntersection ||
                nextPoint.type == InterVertexType.OutIntersection) {
                if (nextPoint.getPoint().equals(startPoint)) {
                    startI = next;
                    initialVertexNotFound = false;
                    break;
                }
            }
            i++;
        }

        // Collect points
        if (!initialVertexNotFound || dontSkip) {
            i = startI;
            boolean continueCollecting = true;

            while (continueCollecting && i < list.size()) {
                InterVertex vertex = list.get(i);

                if (vertex.type == InterVertexType.OutIntersection) {
                    endI = i;
                    lastPoint = Optional.of(vertex.getPoint());
                    continueCollecting = false;
                } else {
                    points.add(vertex.getPoint());
                }

                i++;
            }
        }

        int amount = endI - startI + 1;
        if (endI >= startI && startI + amount <= list.size()) {
            list.subList(startI, startI + amount).clear();
        }

        if (!points.isEmpty() && lastPoint.isPresent()) {
            return Optional.of(new PointsPair(points, lastPoint.get()));
        } else {
            return Optional.empty();
        }
    }

    public static Optional<List<Point>> getClipPolygon(
        List<InterVertex> subject,
        List<InterVertex> clip,
        Point initial) {

        List<Point> result = new ArrayList<>();
        boolean subjectAsList = true;
        Point startPoint = initial;
        Point endPoint = subject.get(subject.size() - 1).getPoint();

        while (!initial.equals(endPoint)) {
            Optional<PointsPair> values = collectFromList(
                subjectAsList ? subject : clip,
                startPoint);

            if (values.isPresent()) {
                PointsPair pair = values.get();
                endPoint = pair.lastPoint;
                startPoint = pair.lastPoint;
                subjectAsList = !subjectAsList;

                result.addAll(pair.points);
            } else {
                System.out.println("something went wrong");
                System.out.println("res size: " + result.size());
                return Optional.empty();
            }
        }

        if (!result.isEmpty()) {
            // Filter consecutive duplicate points
            List<Point> filtered = new ArrayList<>();
            for (int i = 0; i < result.size(); i++) {
                if (i == 0 || !result.get(i).equals(result.get(i-1))) {
                    filtered.add(result.get(i));
                }
            }

            return Optional.of(filtered);
        } else {
            return Optional.empty();
        }
    }

    public static Optional<List<List<Point>>> getClipPolygons(
        List<InterVertex> subject,
        List<InterVertex> clip) {

        List<List<Point>> result = new ArrayList<>();

        while (true) {
            Optional<Point> startPointOpt = InterVertex.getFirstInIntersection(subject);
            if (!startPointOpt.isPresent()) {
                break;
            }

            Optional<List<Point>> poly = getClipPolygon(subject, clip, startPointOpt.get());
            if (poly.isPresent()) {
                result.add(poly.get());
            } else {
                break;
            }
        }

        if (!result.isEmpty()) {
            return Optional.of(result);
        } else {
            return Optional.empty();
        }
    }

    public static Optional<List<List<Point>>> clip(Polygon self, Polygon other) {
        PolyListOption option = getInterVertexList(self, other);
        PolyListOption otherOption = getInterVertexList(other, self);

        if (option.type == PolyListOptionType.List) {
            List<InterVertex> subjectList = option.interVertexList;

            if (otherOption.type == PolyListOptionType.List) {
                List<InterVertex> clipList = otherOption.interVertexList;
                return getClipPolygons(subjectList, clipList);
            } else if (otherOption.type == PolyListOptionType.InsidePoly) {
                List<List<Point>> result = new ArrayList<>();
                result.add(otherOption.points);
                return Optional.of(result);
            } else { // None
                return Optional.empty();
            }
        } else if (option.type == PolyListOptionType.InsidePoly) {
            List<List<Point>> result = new ArrayList<>();
            result.add(option.points);
            return Optional.of(result);
        } else { // None
            return Optional.empty();
        }
    }

    // Testing function
    public static void runTests() {
        // Test isInLine
        {
            Point p = new Point(5, 10);
            Line line = new Line(new Point(5, 5), new Point(5, 20));
            boolean result = isInLine(p, line);
            System.out.println("isInLine test 1: " + (result ? "PASS" : "FAIL"));

            Point pF = new Point(3, 4);
            Line lineF = new Line(new Point(5, 5), new Point(5, 20));
            boolean resultF = isInLine(pF, lineF);
            System.out.println("isInLine test 2: " + (!resultF ? "PASS" : "FAIL"));
        }

        // Test clip
        {
            List<Point> polyPoints = new ArrayList<>();
            polyPoints.add(new Point(180, 420));
            polyPoints.add(new Point(180, 120));
            polyPoints.add(new Point(520, 120));
            polyPoints.add(new Point(520, 420));
            polyPoints.add(new Point(420, 420));
            polyPoints.add(new Point(320, 220));
            Polygon poly = new Polygon(polyPoints);

            List<Point> interPoints = new ArrayList<>();
            interPoints.add(new Point(60, 220));
            interPoints.add(new Point(330, 120));
            interPoints.add(new Point(410, 290));
            interPoints.add(new Point(80, 480));
            interPoints.add(new Point(280, 280));
            Polygon interPolygon = new Polygon(interPoints);

            Optional<List<List<Point>>> polygons = clip(poly, interPolygon);
            if (polygons.isPresent() && !polygons.get().isEmpty()) {
                System.out.println("clip test: PASS - Found " + polygons.get().size() + " polygons");

                // Print first polygon points
                if (!polygons.get().get(0).isEmpty()) {
                    System.out.println("First polygon points:");
                    for (Point p : polygons.get().get(0)) {
                        System.out.println("  Point: (" + p.x + ", " + p.y + ")");
                    }
                }
            } else {
                System.out.println("clip test: FAIL - No polygons found");
            }
        }
    }

    public static void main(String[] args) {
        runTests();
    }
}





class Point {
    int x;
    int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Point other = (Point) obj;
        return x == other.x && y == other.y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}

class Line {
    Point start;
    Point end;

    public Line(Point start, Point end) {
        this.start = start;
        this.end = end;
    }
}

class Polygon {
    List<Point> points;

    public Polygon(List<Point> points) {
        this.points = points;
    }
}

enum InterVertexType {
    InsideVertex,
    OutsideVertex,
    InIntersection,
    OutIntersection
}

class InterVertex {
    InterVertexType type;
    Point point;

    public InterVertex(InterVertexType type, Point point) {
        this.type = type;
        this.point = point;
    }

    public Point getPoint() {
        return point;
    }

    public static Optional<Point> getFirstInIntersection(List<InterVertex> list) {
        int found = 0;
        Optional<Point> result = Optional.empty();

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).type == InterVertexType.InIntersection) {
                found = i;
                result = Optional.of(list.get(i).getPoint());
                break;
            }
        }

        if (found > 0) {
            list.subList(0, found).clear();
        }

        return result;
    }
}

enum PolyListOptionType {
    List,
    InsidePoly,
    None
}

class PolyListOption {
    PolyListOptionType type;
    List<InterVertex> interVertexList;
    List<Point> points;

    public PolyListOption(PolyListOptionType type, List<InterVertex> interVertexList, List<Point> points) {
        this.type = type;
        this.interVertexList = interVertexList;
        this.points = points;
    }
}
