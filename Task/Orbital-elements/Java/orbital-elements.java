public class OrbitalElements {
    private static class Vector {
        private double x, y, z;

        public Vector(double x, double y, double z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public Vector plus(Vector rhs) {
            return new Vector(x + rhs.x, y + rhs.y, z + rhs.z);
        }

        public Vector times(double s) {
            return new Vector(s * x, s * y, s * z);
        }

        public Vector div(double d) {
            return new Vector(x / d, y / d, z / d);
        }

        public double abs() {
            return Math.sqrt(x * x + y * y + z * z);
        }

        @Override
        public String toString() {
            return String.format("(%.16f, %.16f, %.16f)", x, y, z);
        }
    }

    private static Vector mulAdd(Vector v1, Double x1, Vector v2, Double x2) {
        return v1.times(x1).plus(v2.times(x2));
    }

    private static Vector[] rotate(Vector i, Vector j, double alpha) {
        return new Vector[]{
            mulAdd(i, Math.cos(alpha), j, Math.sin(alpha)),
            mulAdd(i, -Math.sin(alpha), j, Math.cos(alpha))
        };
    }

    private static Vector[] orbitalStateVectors(
        double semimajorAxis, double eccentricity,
        double inclination, double longitudeOfAscendingNode,
        double argumentOfPeriapsis, double trueAnomaly
    ) {
        Vector i = new Vector(1, 0, 0);
        Vector j = new Vector(0, 1, 0);
        Vector k = new Vector(0, 0, 1);

        Vector[] p = rotate(i, j, longitudeOfAscendingNode);
        i = p[0];
        j = p[1];
        p = rotate(j, k, inclination);
        j = p[0];
        p = rotate(i, j, argumentOfPeriapsis);
        i = p[0];
        j = p[1];

        double l = (eccentricity == 1.0) ? 2.0 : 1.0 - eccentricity * eccentricity;
        l *= semimajorAxis;
        double c = Math.cos(trueAnomaly);
        double s = Math.sin(trueAnomaly);
        double r = l / (1.0 + eccentricity * c);
        double rprime = s * r * r / l;
        Vector position = mulAdd(i, c, j, s).times(r);
        Vector speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c);
        speed = speed.div(speed.abs());
        speed = speed.times(Math.sqrt(2.0 / r - 1.0 / semimajorAxis));

        return new Vector[]{position, speed};
    }

    public static void main(String[] args) {
        Vector[] ps = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0);
        System.out.printf("Position : %s\n", ps[0]);
        System.out.printf("Speed : %s\n", ps[1]);
    }
}
