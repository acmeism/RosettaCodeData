class LinePlaneIntersection {
    private static class Vector3D {
        private double x, y, z

        Vector3D(double x, double y, double z) {
            this.x = x
            this.y = y
            this.z = z
        }

        Vector3D plus(Vector3D v) {
            return new Vector3D(x + v.x, y + v.y, z + v.z)
        }

        Vector3D minus(Vector3D v) {
            return new Vector3D(x - v.x, y - v.y, z - v.z)
        }

        Vector3D multiply(double s) {
            return new Vector3D(s * x, s * y, s * z)
        }

        double dot(Vector3D v) {
            return x * v.x + y * v.y + z * v.z
        }

        @Override
        String toString() {
            return "($x, $y, $z)"
        }
    }

    private static Vector3D intersectPoint(Vector3D rayVector, Vector3D rayPoint, Vector3D planeNormal, Vector3D planePoint) {
        Vector3D diff = rayPoint - planePoint
        double prod1 = diff.dot(planeNormal)
        double prod2 = rayVector.dot(planeNormal)
        double prod3 = prod1 / prod2
        return rayPoint - rayVector * prod3
    }

    static void main(String[] args) {
        Vector3D rv = new Vector3D(0.0, -1.0, -1.0)
        Vector3D rp = new Vector3D(0.0, 0.0, 10.0)
        Vector3D pn = new Vector3D(0.0, 0.0, 1.0)
        Vector3D pp = new Vector3D(0.0, 0.0, 5.0)
        Vector3D ip = intersectPoint(rv, rp, pn, pp)
        println("The ray intersects the plane at $ip")
    }
}
