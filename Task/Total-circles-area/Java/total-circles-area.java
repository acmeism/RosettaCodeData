public class CirclesTotalArea {

    /*
     * Rectangles are given as 4-element arrays [tx, ty, w, h].
     * Circles are given as 3-element arrays [cx, cy, r].
     */

    private static double distSq(double x1, double y1, double x2, double y2) {
        return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    }

    private static boolean rectangleFullyInsideCircle(double[] rect, double[] circ) {
        double r2 = circ[2] * circ[2];
        // Every corner point of rectangle must be inside the circle.
        return distSq(rect[0], rect[1], circ[0], circ[1]) <= r2 &&
          distSq(rect[0] + rect[2], rect[1], circ[0], circ[1]) <= r2 &&
          distSq(rect[0], rect[1] - rect[3], circ[0], circ[1]) <= r2 &&
          distSq(rect[0] + rect[2], rect[1] - rect[3], circ[0], circ[1]) <= r2;
    }

    private static boolean rectangleSurelyOutsideCircle(double[] rect, double[] circ) {
        // Circle center point inside rectangle?
        if(rect[0] <= circ[0] && circ[0] <= rect[0] + rect[2] &&
          rect[1] - rect[3] <= circ[1] && circ[1] <= rect[1]) { return false; }
        // Otherwise, check that each corner is at least (r + Max(w, h)) away from circle center.
        double r2 = circ[2] + Math.max(rect[2], rect[3]);
        r2 = r2 * r2;
        return distSq(rect[0], rect[1], circ[0], circ[1]) >= r2 &&
          distSq(rect[0] + rect[2], rect[1], circ[0], circ[1]) >= r2 &&
          distSq(rect[0], rect[1] - rect[3], circ[0], circ[1]) >= r2 &&
          distSq(rect[0] + rect[2], rect[1] - rect[3], circ[0], circ[1]) >= r2;
    }

    private static boolean[] surelyOutside;

    private static double totalArea(double[] rect, double[][] circs, int d) {
        // Check if we can get a quick certain answer.
        int surelyOutsideCount = 0;
        for(int i = 0; i < circs.length; i++) {
            if(rectangleFullyInsideCircle(rect, circs[i])) { return rect[2] * rect[3]; }
            if(rectangleSurelyOutsideCircle(rect, circs[i])) {
                surelyOutside[i] = true;
                surelyOutsideCount++;
            }
            else { surelyOutside[i] = false; }
        }
        // Is this rectangle surely outside all circles?
        if(surelyOutsideCount == circs.length) { return 0; }
        // Are we deep enough in the recursion?
        if(d < 1) {
            return rect[2] * rect[3] / 3;  // Best guess for overlapping portion
        }
        // Throw out all circles that are surely outside this rectangle.
        if(surelyOutsideCount > 0) {
            double[][] newCircs = new double[circs.length - surelyOutsideCount][3];
            int loc = 0;
            for(int i = 0; i < circs.length; i++) {
                if(!surelyOutside[i]) { newCircs[loc++] = circs[i]; }
            }
            circs = newCircs;
        }
        // Subdivide this rectangle recursively and add up the recursively computed areas.
        double w = rect[2] / 2; // New width
        double h = rect[3] / 2; // New height
        double[][] pieces = {
            { rect[0], rect[1], w, h }, // NW
            { rect[0] + w, rect[1], w, h }, // NE
            { rect[0], rect[1] - h, w, h }, // SW
            { rect[0] + w, rect[1] - h, w, h } // SE
        };
        double total = 0;
        for(double[] piece: pieces) { total += totalArea(piece, circs, d - 1); }
        return total;
    }

    public static double totalArea(double[][] circs, int d) {
        double maxx = Double.NEGATIVE_INFINITY;
        double minx = Double.POSITIVE_INFINITY;
        double maxy = Double.NEGATIVE_INFINITY;
        double miny = Double.POSITIVE_INFINITY;
        // Find the extremes of x and y for this set of circles.
        for(double[] circ: circs) {
            if(circ[0] + circ[2] > maxx) { maxx = circ[0] + circ[2]; }
            if(circ[0] - circ[2] < minx) { minx = circ[0] - circ[2]; }
            if(circ[1] + circ[2] > maxy) { maxy = circ[1] + circ[2]; }
            if(circ[1] - circ[2] < miny) { miny = circ[1] - circ[2]; }
        }
        double[] rect = { minx, maxy, maxx - minx, maxy - miny };
        surelyOutside = new boolean[circs.length];
        return totalArea(rect, circs, d);
    }

    public static void main(String[] args) {
        double[][] circs = {
            { 1.6417233788, 1.6121789534, 0.0848270516 },
            {-1.4944608174, 1.2077959613, 1.1039549836 },
            { 0.6110294452, -0.6907087527, 0.9089162485 },
            { 0.3844862411, 0.2923344616, 0.2375743054 },
            {-0.2495892950, -0.3832854473, 1.0845181219 },
            {1.7813504266, 1.6178237031, 0.8162655711 },
            {-0.1985249206, -0.8343333301, 0.0538864941 },
            {-1.7011985145, -0.1263820964, 0.4776976918 },
            {-0.4319462812, 1.4104420482, 0.7886291537 },
            {0.2178372997, -0.9499557344, 0.0357871187 },
            {-0.6294854565, -1.3078893852, 0.7653357688 },
            {1.7952608455, 0.6281269104, 0.2727652452 },
            {1.4168575317, 1.0683357171, 1.1016025378 },
            {1.4637371396, 0.9463877418, 1.1846214562 },
            {-0.5263668798, 1.7315156631, 1.4428514068 },
            {-1.2197352481, 0.9144146579, 1.0727263474 },
            {-0.1389358881, 0.1092805780, 0.7350208828 },
            {1.5293954595, 0.0030278255, 1.2472867347 },
            {-0.5258728625, 1.3782633069, 1.3495508831 },
            {-0.1403562064, 0.2437382535, 1.3804956588 },
            {0.8055826339, -0.0482092025, 0.3327165165 },
            {-0.6311979224, 0.7184578971, 0.2491045282 },
            {1.4685857879, -0.8347049536, 1.3670667538 },
            {-0.6855727502, 1.6465021616, 1.0593087096 },
            {0.0152957411, 0.0638919221, 0.9771215985 }
        };
        double ans = totalArea(circs, 24);
        System.out.println("Approx. area is " + ans);
        System.out.println("Error is " + Math.abs(21.56503660 - ans));
    }
}
