using System;

namespace OrbitalElements {
    class Vector {
        public Vector(double x, double y, double z) {
            X = x;
            Y = y;
            Z = z;
        }

        public double X { get; set; }
        public double Y { get; set; }
        public double Z { get; set; }

        public double Abs() {
            return Math.Sqrt(X * X + Y * Y + Z * Z);
        }

        public static Vector operator +(Vector lhs, Vector rhs) {
            return new Vector(lhs.X + rhs.X, lhs.Y + rhs.Y, lhs.Z + rhs.Z);
        }

        public static Vector operator *(Vector self, double m) {
            return new Vector(self.X * m, self.Y * m, self.Z * m);
        }

        public static Vector operator /(Vector self, double m) {
            return new Vector(self.X / m, self.Y / m, self.Z / m);
        }

        public override string ToString() {
            return string.Format("({0}, {1}, {2})", X, Y, Z);
        }
    }

    class Program {
        static Tuple<Vector, Vector> OrbitalStateVectors(
            double semiMajorAxis,
            double eccentricity,
            double inclination,
            double longitudeOfAscendingNode,
            double argumentOfPeriapsis,
            double trueAnomaly
        ) {
            Vector mulAdd(Vector v1, double x1, Vector v2, double x2) {
                return v1 * x1 + v2 * x2;
            }

            Tuple<Vector, Vector> rotate(Vector iv, Vector jv, double alpha) {
                return new Tuple<Vector, Vector>(
                    mulAdd(iv, +Math.Cos(alpha), jv, Math.Sin(alpha)),
                    mulAdd(iv, -Math.Sin(alpha), jv, Math.Cos(alpha))
                );
            }

            var i = new Vector(1, 0, 0);
            var j = new Vector(0, 1, 0);
            var k = new Vector(0, 0, 1);

            var p = rotate(i, j, longitudeOfAscendingNode);
            i = p.Item1; j = p.Item2;
            p = rotate(j, k, inclination);
            j = p.Item1;
            p = rotate(i, j, argumentOfPeriapsis);
            i = p.Item1; j = p.Item2;

            var l = semiMajorAxis * ((eccentricity == 1.0) ? 2.0 : (1.0 - eccentricity * eccentricity));
            var c = Math.Cos(trueAnomaly);
            var s = Math.Sin(trueAnomaly);
            var r = l / (1.0 + eccentricity * c);
            var rprime = s * r * r / l;
            var position = mulAdd(i, c, j, s) * r;
            var speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c);
            speed /= speed.Abs();
            speed *= Math.Sqrt(2.0 / r - 1.0 / semiMajorAxis);

            return new Tuple<Vector, Vector>(position, speed);
        }

        static void Main(string[] args) {
            var res = OrbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0);
            Console.WriteLine("Position : {0}", res.Item1);
            Console.WriteLine("Speed    : {0}", res.Item2);
        }
    }
}
