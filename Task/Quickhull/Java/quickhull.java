import java.util.*;

public class QuickHull3D {
    static final int MAXN = 2500;
    static final double EPS = 1e-8;

    // Globals
    static List<Facet> FAC = new ArrayList<>();
    static List<List<Vect>> pts = new ArrayList<>();
    static int TIME = 0;
    static Edge[][] e = new Edge[2][MAXN];
    static int[] vistime = new int[MAXN];
    static List<Integer> queue = new ArrayList<>();
    static List<Integer> resfnew = new ArrayList<>();
    static List<Integer> resfdel = new ArrayList<>();
    static List<Vect> respt = new ArrayList<>();

    public static void main(String[] args) {
        preConvexHulls();

        // Example: unit tetrahedron
        int n = 4;
        Vect[] point = new Vect[n + 1];
        point[1] = new Vect(0, 0, 0, 1);
        point[2] = new Vect(1, 0, 0, 2);
        point[3] = new Vect(0, 1, 0, 3);
        point[4] = new Vect(0, 0, 1, 4);

        ConvexHulls3d hull = quickHull3D(point, n);
        System.out.printf("%.3f%n", hull.getSurfaceArea());
    }

    static void preConvexHulls() {
        // Reserve index 0
        pts.add(new ArrayList<>());      // dummy point list[0]
        FAC.add(new Facet());            // dummy facet[0]
        // Initialize edge array
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < MAXN; j++) {
                e[i][j] = new Edge();
            }
        }
    }

    static class Vect {
        double X, Y, Z;
        int Id;
        Vect(double x, double y, double z, int id) { X = x; Y = y; Z = z; Id = id; }
        Vect sub(Vect b) { return new Vect(X - b.X, Y - b.Y, Z - b.Z, 0); }
        Vect cross(Vect b) {
            return new Vect(
                Y * b.Z - Z * b.Y,
                Z * b.X - X * b.Z,
                X * b.Y - Y * b.X,
                0
            );
        }
        double dot(Vect b) { return X * b.X + Y * b.Y + Z * b.Z; }
        double mag() { return Math.sqrt(X * X + Y * Y + Z * Z); }
        boolean eq(Vect b) {
            // Qualify eq to the outer class's static method:
            return QuickHull3D.eq(X, b.X)
                && QuickHull3D.eq(Y, b.Y)
                && QuickHull3D.eq(Z, b.Z);
        }
    }

    static class Line {
        Vect U, V;
        Line(Vect u, Vect v) { U = u; V = v; }
    }

    static class Plane {
        Vect U, V, W;
        Plane() {}
        Plane(Vect u, Vect v, Vect w) { U = u; V = v; W = w; }
        Vect normal() { return V.sub(U).cross(W.sub(U)); }
        Vect vecAt(int i) {
            if (i == 0) return U;
            if (i == 1) return V;
            return W;
        }
        int vecId(int i) { return vecAt(i).Id; }
    }

    static class Facet {
        int[] N = new int[3];
        int Id;
        int visitTime;
        boolean isDeleted;
        Plane P = new Plane();
    }

    static class Edge {
        int netId, facetId;
    }

    static class ConvexHulls3d {
        int Index;
        double surfaceArea = 0.0;

        ConvexHulls3d(int idx) { Index = idx; }

        void dfsArea(int f) {
            Facet F = FAC.get(f);
            if (F.visitTime == TIME) return;
            F.visitTime = TIME;
            Vect nrm = F.P.normal();
            surfaceArea += nrm.mag() / 2.0;
            for (int i = 0; i < 3; i++) {
                dfsArea(F.N[i]);
            }
        }

        public double getSurfaceArea() {
            if (gtr(surfaceArea, 0.0)) return surfaceArea;
            TIME++;
            dfsArea(Index);
            return surfaceArea;
        }

        public int getHorizon(int f, Vect p, List<Integer> resDel) {
            Facet Ff = FAC.get(f);
            if (!isAbove(p, Ff.P)) return 0;
            if (Ff.visitTime == TIME) return -1;
            Ff.visitTime = TIME;
            Ff.isDeleted = true;
            resDel.add(Ff.Id);
            int ret = -2;
            for (int i = 0; i < 3; i++) {
                int ni = Ff.N[i];
                int r = getHorizon(ni, p, resDel);
                if (r == 0) {
                    int a = Ff.P.vecId(i);
                    int b = Ff.P.vecId((i + 1) % 3);
                    for (int idx = 0; idx < 2; idx++) {
                        int pt = (idx == 0 ? a : b);
                        int facet = ni;
                        if (vistime[pt] != TIME) {
                            vistime[pt] = TIME;
                            e[0][pt].netId = (idx == 0 ? b : a);
                            e[0][pt].facetId = facet;
                        } else {
                            e[1][pt].netId = (idx == 0 ? b : a);
                            e[1][pt].facetId = facet;
                        }
                    }
                    ret = a;
                } else if (r != -1 && r != -2) {
                    ret = r;
                }
            }
            return ret;
        }
    }

    // Utilities
    static boolean eq(double a, double b) { return Math.abs(a - b) < EPS; }
    static boolean gtr(double a, double b) { return a - b > EPS; }
    static double abs(double x) { return x < 0 ? -x : x; }

    static double distPointPlane(Vect v, Plane p) {
        double num = v.sub(p.U).dot(p.normal());
        double den = p.normal().mag();
        return num / den;
    }

    static double distPointLine(Vect v, Line l) {
        double d = v.sub(l.U).mag();
        if (d == 0) return 0;
        return l.V.sub(l.U).cross(v.sub(l.U)).mag() / l.V.sub(l.U).mag();
    }

    static double distPointPoint(Vect a, Vect b) { return a.sub(b).mag(); }
    static boolean isAbove(Vect v, Plane p) {
        return gtr(v.sub(p.U).dot(p.normal()), 0);
    }

    static ConvexHulls3d getStart(Vect[] point, int totp) {
        Vect[] extremes = new Vect[6];
        for (int i = 0; i < 6; i++) extremes[i] = point[1];
        for (int i = 1; i <= totp; i++) {
            Vect v = point[i];
            if (gtr(v.X, extremes[0].X)) extremes[0] = v;
            if (gtr(extremes[1].X, v.X)) extremes[1] = v;
            if (gtr(v.Y, extremes[2].Y)) extremes[2] = v;
            if (gtr(extremes[3].Y, v.Y)) extremes[3] = v;
            if (gtr(v.Z, extremes[4].Z)) extremes[4] = v;
            if (gtr(extremes[5].Z, v.Z)) extremes[5] = v;
        }
        // Furthest pair
        Vect s0 = extremes[0], s1 = extremes[1];
        for (int i = 0; i < 6; i++) {
            for (int j = i + 1; j < 6; j++) {
                double d = distPointPoint(extremes[i], extremes[j]);
                if (gtr(d, distPointPoint(s0, s1))) {
                    s0 = extremes[i];
                    s1 = extremes[j];
                }
            }
        }
        // Furthest from line
        Line line = new Line(s0, s1);
        Vect s2 = extremes[0];
        for (int i = 0; i < 6; i++) {
            if (gtr(distPointLine(extremes[i], line),
                    distPointLine(s2, line)))
                s2 = extremes[i];
        }
        // Furthest from plane
        Vect s3 = point[1];
        Plane basePlane = new Plane(s0, s1, s2);
        for (int i = 1; i <= totp; i++) {
            double d1 = abs(distPointPlane(point[i], basePlane));
            double d2 = abs(distPointPlane(s3, basePlane));
            if (gtr(d1, d2)) s3 = point[i];
        }
        if (gtr(0, distPointPlane(s3, basePlane))) {
            Vect tmp = s1; s1 = s2; s2 = tmp;
        }
        // Create 4 initial facets
        int[] f = new int[4];
        for (int i = 0; i < 4; i++) {
            Facet F = new Facet();
            F.Id = FAC.size();
            FAC.add(F);
            f[i] = FAC.size() - 1;
        }
        FAC.get(f[0]).P = new Plane(s0, s2, s1);
        FAC.get(f[1]).P = new Plane(s0, s1, s3);
        FAC.get(f[2]).P = new Plane(s1, s2, s3);
        FAC.get(f[3]).P = new Plane(s2, s0, s3);

        FAC.get(f[0]).N = new int[]{f[3], f[2], f[1]};
        FAC.get(f[1]).N = new int[]{f[0], f[2], f[3]};
        FAC.get(f[2]).N = new int[]{f[0], f[3], f[1]};
        FAC.get(f[3]).N = new int[]{f[0], f[1], f[2]};

        // Prepare pts lists for the 4 facets
        for (int i = 0; i < 4; i++) {
            pts.add(new ArrayList<>());
        }
        // Assign points to facets
        for (int i = 1; i <= totp; i++) {
            Vect v = point[i];
            if (v.eq(s0) || v.eq(s1) || v.eq(s2) || v.eq(s3)) continue;
            for (int j = 0; j < 4; j++) {
                if (isAbove(v, FAC.get(f[j]).P)) {
                    pts.get(f[j]).add(v);
                    break;
                }
            }
        }
        return new ConvexHulls3d(f[0]);
    }

    static ConvexHulls3d quickHull3D(Vect[] point, int totp) {
        ConvexHulls3d hull = getStart(point, totp);
        queue.clear();
        queue.add(hull.Index);
        for (int i = 0; i < 3; i++) {
            queue.add(FAC.get(hull.Index).N[i]);
        }
        int snew = 0;
        while (!queue.isEmpty()) {
            int nf = queue.remove(0);
            Facet Fnf = FAC.get(nf);
            if (Fnf.isDeleted || pts.get(nf).isEmpty()) {
                if (!Fnf.isDeleted) snew = nf;
                continue;
            }
            // Farthest point from facet plane
            Vect p = pts.get(nf).get(0);
            for (Vect v : pts.get(nf)) {
                if (gtr(distPointPlane(v, Fnf.P), distPointPlane(p, Fnf.P))) {
                    p = v;
                }
            }
            // Find horizon
            TIME++;
            resfdel.clear();
            int s = hull.getHorizon(nf, p, resfdel);

            // Build new faces
            resfnew.clear();
            TIME++;
            int from = -1, lastf = -1, fstf = -1;
            while (vistime[s] != TIME) {
                vistime[s] = TIME;
                int net, fidx;
                if (e[0][s].netId == from) {
                    net = e[1][s].netId;
                    fidx = e[1][s].facetId;
                } else {
                    net = e[0][s].netId;
                    fidx = e[0][s].facetId;
                }
                // Find indices on facet fidx
                Facet Ff = FAC.get(fidx);
                int pt1 = 0, pt2 = 0;
                for (int i = 0; i < 3; i++) {
                    if (point[s].eq(Ff.P.vecAt(i))) pt1 = i;
                    if (point[net].eq(Ff.P.vecAt(i))) pt2 = i;
                }
                if ((pt1 + 1) % 3 != pt2) {
                    int tmp = pt1; pt1 = pt2; pt2 = tmp;
                }
                // Create new facet
                Facet newF = new Facet();
                newF.Id = FAC.size();
                newF.P = new Plane(
                    Ff.P.vecAt(pt2),
                    Ff.P.vecAt(pt1),
                    p
                );
                FAC.add(newF);
                pts.add(new ArrayList<>());
                int fnew = FAC.size() - 1;
                resfnew.add(fnew);

                // Link neighborhoods
                newF.N[0] = fidx;
                Ff.N[pt1] = fnew;

                if (lastf >= 0) {
                    Plane Pf1 = newF.P, Plast = FAC.get(lastf).P;
                    if (Pf1.vecAt(1).eq(Plast.U)) {
                        newF.N[1] = lastf;
                        FAC.get(lastf).N[2] = fnew;
                    } else {
                        newF.N[2] = lastf;
                        FAC.get(lastf).N[1] = fnew;
                    }
                } else {
                    fstf = fnew;
                }

                lastf = fnew;
                from = s;
                s = net;
            }
            // Close the loop
            Facet Ffst = FAC.get(fstf), Flast = FAC.get(lastf);
            if (Ffst.P.vecAt(1).eq(Flast.P.U)) {
                Ffst.N[1] = lastf;
                Flast.N[2] = fstf;
            } else {
                Ffst.N[2] = lastf;
                Flast.N[1] = fstf;
            }

            // Collect deleted points
            respt.clear();
            for (int fid : resfdel) {
                respt.addAll(pts.get(fid));
                pts.get(fid).clear();
            }
            // Reassign points
            for (Vect v : respt) {
                if (v == p) continue;
                for (int fid : resfnew) {
                    if (isAbove(v, FAC.get(fid).P)) {
                        pts.get(fid).add(v);
                        break;
                    }
                }
            }
            // Enqueue new faces
            for (int fid : resfnew) {
                queue.add(fid);
            }
        }
        hull.Index = snew;
        return hull;
    }
}
