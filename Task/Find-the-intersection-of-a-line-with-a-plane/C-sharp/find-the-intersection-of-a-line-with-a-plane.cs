using System;

namespace FindIntersection {
    class Vector3D {
        private double x, y, z;

        public Vector3D(double x, double y, double z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public static Vector3D operator +(Vector3D lhs, Vector3D rhs) {
            return new Vector3D(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z);
        }

        public static Vector3D operator -(Vector3D lhs, Vector3D rhs) {
            return new Vector3D(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z);
        }

        public static Vector3D operator *(Vector3D lhs, double rhs) {
            return new Vector3D(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs);
        }

        public double Dot(Vector3D rhs) {
            return x * rhs.x + y * rhs.y + z * rhs.z;
        }

        public override string ToString() {
            return string.Format("({0:F}, {1:F}, {2:F})", x, y, z);
        }
    }

    class Program {
        static Vector3D IntersectPoint(Vector3D rayVector, Vector3D rayPoint, Vector3D planeNormal, Vector3D planePoint) {
            var diff = rayPoint - planePoint;
            var prod1 = diff.Dot(planeNormal);
            var prod2 = rayVector.Dot(planeNormal);
            var prod3 = prod1 / prod2;
            return rayPoint - rayVector * prod3;
        }

        static void Main(string[] args) {
            var rv = new Vector3D(0.0, -1.0, -1.0);
            var rp = new Vector3D(0.0, 0.0, 10.0);
            var pn = new Vector3D(0.0, 0.0, 1.0);
            var pp = new Vector3D(0.0, 0.0, 5.0);
            var ip = IntersectPoint(rv, rp, pn, pp);
            Console.WriteLine("The ray intersects the plane at {0}", ip);
        }
    }
}
