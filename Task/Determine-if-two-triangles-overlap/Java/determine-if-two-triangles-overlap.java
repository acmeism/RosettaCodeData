import java.util.function.BiFunction;

public class TriangleOverlap {
    private static class Pair {
        double first;
        double second;

        Pair(double first, double second) {
            this.first = first;
            this.second = second;
        }

        @Override
        public String toString() {
            return String.format("(%s, %s)", first, second);
        }
    }

    private static class Triangle {
        Pair p1, p2, p3;

        Triangle(Pair p1, Pair p2, Pair p3) {
            this.p1 = p1;
            this.p2 = p2;
            this.p3 = p3;
        }

        @Override
        public String toString() {
            return String.format("Triangle: %s, %s, %s", p1, p2, p3);
        }
    }

    private static double det2D(Triangle t) {
        Pair p1 = t.p1;
        Pair p2 = t.p2;
        Pair p3 = t.p3;
        return p1.first * (p2.second - p3.second)
            + p2.first * (p3.second - p1.second)
            + p3.first * (p1.second - p2.second);
    }

    private static void checkTriWinding(Triangle t, boolean allowReversed) {
        double detTri = det2D(t);
        if (detTri < 0.0) {
            if (allowReversed) {
                Pair a = t.p3;
                t.p3 = t.p2;
                t.p2 = a;
            } else throw new RuntimeException("Triangle has wrong winding direction");
        }
    }

    private static boolean boundaryCollideChk(Triangle t, double eps) {
        return det2D(t) < eps;
    }

    private static boolean boundaryDoesntCollideChk(Triangle t, double eps) {
        return det2D(t) <= eps;
    }

    private static boolean triTri2D(Triangle t1, Triangle t2) {
        return triTri2D(t1, t2, 0.0, false, true);
    }

    private static boolean triTri2D(Triangle t1, Triangle t2, double eps, boolean allowedReversed) {
        return triTri2D(t1, t2, eps, allowedReversed, true);
    }

    private static boolean triTri2D(Triangle t1, Triangle t2, double eps, boolean allowedReversed, boolean onBoundary) {
        // Triangles must be expressed anti-clockwise
        checkTriWinding(t1, allowedReversed);
        checkTriWinding(t2, allowedReversed);
        // 'onBoundary' determines whether points on boundary are considered as colliding or not
        BiFunction<Triangle, Double, Boolean> chkEdge = onBoundary ? TriangleOverlap::boundaryCollideChk : TriangleOverlap::boundaryDoesntCollideChk;
        Pair[] lp1 = new Pair[]{t1.p1, t1.p2, t1.p3};
        Pair[] lp2 = new Pair[]{t2.p1, t2.p2, t2.p3};

        // for each edge E of t1
        for (int i = 0; i < 3; ++i) {
            int j = (i + 1) % 3;
            // Check all points of t2 lay on the external side of edge E.
            // If they do, the triangles do not overlap.
            if (chkEdge.apply(new Triangle(lp1[i], lp1[j], lp2[0]), eps) &&
                chkEdge.apply(new Triangle(lp1[i], lp1[j], lp2[1]), eps) &&
                chkEdge.apply(new Triangle(lp1[i], lp1[j], lp2[2]), eps)) return false;
        }

        // for each edge E of t2
        for (int i = 0; i < 3; ++i) {
            int j = (i + 1) % 3;
            // Check all points of t1 lay on the external side of edge E.
            // If they do, the triangles do not overlap.
            if (chkEdge.apply(new Triangle(lp2[i], lp2[j], lp1[0]), eps) &&
                chkEdge.apply(new Triangle(lp2[i], lp2[j], lp1[1]), eps) &&
                chkEdge.apply(new Triangle(lp2[i], lp2[j], lp1[2]), eps)) return false;
        }

        // The triangles overlap
        return true;
    }

    public static void main(String[] args) {
        Triangle t1 = new Triangle(new Pair(0.0, 0.0), new Pair(5.0, 0.0), new Pair(0.0, 5.0));
        Triangle t2 = new Triangle(new Pair(0.0, 0.0), new Pair(5.0, 0.0), new Pair(0.0, 6.0));
        System.out.printf("%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        // need to allow reversed for this pair to avoid exception
        t1 = new Triangle(new Pair(0.0, 0.0), new Pair(0.0, 5.0), new Pair(5.0, 0.0));
        t2 = t1;
        System.out.printf("\n%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2, 0.0, true)) {
            System.out.println("overlap (reversed)");
        } else {
            System.out.println("do not overlap");
        }

        t1 = new Triangle(new Pair(0.0, 0.0), new Pair(5.0, 0.0), new Pair(0.0, 5.0));
        t2 = new Triangle(new Pair(-10.0, 0.0), new Pair(-5.0, 0.0), new Pair(-1.0, 6.0));
        System.out.printf("\n%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        t1.p3 = new Pair(2.5, 5.0);
        t2 = new Triangle(new Pair(0.0, 4.0), new Pair(2.5, -1.0), new Pair(5.0, 4.0));
        System.out.printf("\n%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        t1 = new Triangle(new Pair(0.0, 0.0), new Pair(1.0, 1.0), new Pair(0.0, 2.0));
        t2 = new Triangle(new Pair(2.0, 1.0), new Pair(3.0, 0.0), new Pair(3.0, 2.0));
        System.out.printf("\n%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        t2 = new Triangle(new Pair(2.0, 1.0), new Pair(3.0, -2.0), new Pair(3.0, 4.0));
        System.out.printf("\n%s and\n%s\n", t1, t2);
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        t1 = new Triangle(new Pair(0.0, 0.0), new Pair(1.0, 0.0), new Pair(0.0, 1.0));
        t2 = new Triangle(new Pair(1.0, 0.0), new Pair(2.0, 0.0), new Pair(1.0, 1.1));
        System.out.printf("\n%s and\n%s\n", t1, t2);
        System.out.println("which have only a single corner in contact, if boundary points collide");
        if (triTri2D(t1, t2)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }

        System.out.printf("\n%s and\n%s\n", t1, t2);
        System.out.println("which have only a single corner in contact, if boundary points do not collide");
        if (triTri2D(t1, t2, 0.0, false, false)) {
            System.out.println("overlap");
        } else {
            System.out.println("do not overlap");
        }
    }
}
