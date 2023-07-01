// Translation from https://en.wikipedia.org/wiki/Hilbert_curve

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class HilbertCurve {
    public static class Point {
        public int x;
        public int y;

        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public String toString() {
            return "(" + x + ", " + y + ")";
        }

        //rotate/flip a quadrant appropriately
        public void rot(int n, boolean rx, boolean ry) {
            if (!ry) {
                if (rx) {
                    x = (n - 1) - x;
                    y = (n - 1) - y;
                }

                //Swap x and y
                int t  = x;
                x = y;
                y = t;
            }

            return;
        }

        public int calcD(int n) {
            boolean rx, ry;
            int d = 0;
            for (int s = n >>> 1; s > 0; s >>>= 1) {
                rx = ((x & s) != 0);
                ry = ((y & s) != 0);
                d += s * s * ((rx ? 3 : 0) ^ (ry ? 1 : 0));
                rot(s, rx, ry);
            }

            return d;
        }

    }

    public static Point fromD(int n, int d) {
        Point p = new Point(0, 0);
        boolean rx, ry;
        int t = d;
        for (int s = 1; s < n; s <<= 1) {
            rx = ((t & 2) != 0);
            ry = (((t ^ (rx ? 1 : 0)) & 1) != 0);
            p.rot(s, rx, ry);
            p.x += (rx ? s : 0);
            p.y += (ry ? s : 0);
            t >>>= 2;
        }
        return p;
    }

    public static List<Point> getPointsForCurve(int n) {
        List<Point> points = new ArrayList<Point>();
        for (int d = 0; d < (n * n); d++) {
            Point p = fromD(n, d);
            points.add(p);
        }

        return points;
    }

    public static List<String> drawCurve(List<Point> points, int n) {
        char[][] canvas = new char[n][n * 3 - 2];
        for (char[] line : canvas) {
            Arrays.fill(line, ' ');
        }
        for (int i = 1; i < points.size(); i++) {
             Point lastPoint = points.get(i - 1);
            Point curPoint = points.get(i);
            int deltaX = curPoint.x - lastPoint.x;
            int deltaY = curPoint.y - lastPoint.y;
            if (deltaX == 0) {
                if (deltaY == 0) {
                    // A mistake has been made
                    throw new IllegalStateException("Duplicate point, deltaX=" + deltaX + ", deltaY=" + deltaY);
                }
                // Vertical line
                int row = Math.max(curPoint.y, lastPoint.y);
                int col = curPoint.x * 3;
                canvas[row][col] = '|';
            }
            else {
                if (deltaY != 0) {
                    // A mistake has been made
                    throw new IllegalStateException("Diagonal line, deltaX=" + deltaX + ", deltaY=" + deltaY);
                }
                // Horizontal line
                int row = curPoint.y;
                int col = Math.min(curPoint.x, lastPoint.x) * 3 + 1;
                canvas[row][col] = '_';
                canvas[row][col + 1] = '_';
            }

        }
        List<String> lines = new ArrayList<String>();
        for (char[] row : canvas) {
            String line = new String(row);
            lines.add(line);
        }

        return lines;
    }

    public static void main(String... args) {
        for (int order = 1; order <= 5; order++) {
            int n = (1 << order);
            List<Point> points = getPointsForCurve(n);
            System.out.println("Hilbert curve, order=" + order);
            List<String> lines = drawCurve(points, n);
            for (String line : lines) {
                System.out.println(line);
            }
            System.out.println();
        }
        return;
    }
}
