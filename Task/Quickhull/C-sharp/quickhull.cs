using System;
using System.Collections.Generic;

namespace QuickHull3D
{
    class Program
    {
        const int MAXN = 2500;
        const double EPS = 1e-8;

        // Globals
        static List<Facet> FAC = new List<Facet>();
        static List<List<Vect>> pts = new List<List<Vect>>();
        static int TIME = 0;
        static Edge[,] e = new Edge[2, MAXN];
        static int[] vistime = new int[MAXN];
        static List<int> queue = new List<int>();
        static List<int> resfnew = new List<int>();
        static List<int> resfdel = new List<int>();
        static List<Vect> respt = new List<Vect>();

        static void Main(string[] args)
        {
            PreConvexHulls();

            // Example: unit tetrahedron
            int n = 4;
            var point = new Vect[n + 1];
            point[1] = new Vect(0, 0, 0, 1);
            point[2] = new Vect(1, 0, 0, 2);
            point[3] = new Vect(0, 1, 0, 3);
            point[4] = new Vect(0, 0, 1, 4);

            var hull = QuickHull3D(point, n);
            Console.WriteLine("{0:F3}", hull.GetSurfaceArea());
        }

        static void PreConvexHulls()
        {
            // Reserve index 0
            pts.Add(new List<Vect>());
            FAC.Add(new Facet()); // dummy facet[0]
            // Initialize edge array
            for (int i = 0; i < 2; i++)
                for (int j = 0; j < MAXN; j++)
                    e[i, j] = new Edge();
        }

        class Vect
        {
            public double X, Y, Z;
            public int Id;
            public Vect(double x = 0, double y = 0, double z = 0, int id = 0)
            {
                X = x; Y = y; Z = z; Id = id;
            }
            public Vect Sub(Vect b) => new Vect(X - b.X, Y - b.Y, Z - b.Z);
            public Vect Cross(Vect b) => new Vect(
                Y * b.Z - Z * b.Y,
                Z * b.X - X * b.Z,
                X * b.Y - Y * b.X);
            public double Dot(Vect b) => X * b.X + Y * b.Y + Z * b.Z;
            public double Mag() => Math.Sqrt(X * X + Y * Y + Z * Z);
            public bool Eq(Vect b) => eq(X, b.X) && eq(Y, b.Y) && eq(Z, b.Z);
        }

        class Line
        {
            public Vect U, V;
            public Line(Vect u, Vect v) { U = u; V = v; }
        }

        class Plane
        {
            public Vect U, V, W;
            public Plane() { }
            public Plane(Vect u, Vect v, Vect w) { U = u; V = v; W = w; }
            public Vect Normal() => V.Sub(U).Cross(W.Sub(U));
            public Vect VecAt(int i)
            {
                if (i == 0) return U;
                if (i == 1) return V;
                return W;
            }
            public int VecId(int i) => VecAt(i).Id;
        }

        class Facet
        {
            public int[] N = new int[3];
            public int Id;
            public int VisitTime;
            public bool IsDeleted;
            public Plane P = new Plane();
            public Facet() { }
            public Facet(int id, Plane p)
            {
                Id = id; P = p;
            }
        }

        class Edge
        {
            public int NetId, FacetId;
            public Edge() { }
        }

        class ConvexHulls3d
        {
            public int Index;
            double surfaceArea = 0.0;
            public ConvexHulls3d(int idx) { Index = idx; }

            void DfsArea(int f)
            {
                if (FAC[f].VisitTime == TIME) return;
                FAC[f].VisitTime = TIME;
                var nrm = FAC[f].P.Normal();
                surfaceArea += nrm.Mag() / 2.0;
                for (int i = 0; i < 3; i++)
                    DfsArea(FAC[f].N[i]);
            }

            public double GetSurfaceArea()
            {
                if (gtr(surfaceArea, 0.0)) return surfaceArea;
                TIME++;
                DfsArea(Index);
                return surfaceArea;
            }

            public int GetHorizon(int f, Vect p, List<int> resDel)
            {
                if (!isAbove(p, FAC[f].P)) return 0;
                if (FAC[f].VisitTime == TIME) return -1;
                FAC[f].VisitTime = TIME;
                FAC[f].IsDeleted = true;
                resDel.Add(FAC[f].Id);
                int ret = -2;
                for (int i = 0; i < 3; i++)
                {
                    int r = GetHorizon(FAC[f].N[i], p, resDel);
                    if (r == 0)
                    {
                        int a = FAC[f].P.VecId(i);
                        int b = FAC[f].P.VecId((i + 1) % 3);
                        foreach (var pair in new[]{(pt:a, idx:0),(pt:b, idx:1)})
                        {
                            int pt = pair.pt; int idx = pair.idx;
                            if (vistime[pt] != TIME)
                            {
                                vistime[pt] = TIME;
                                e[0, pt].NetId = idx == 0 ? b : a;
                                e[0, pt].FacetId = FAC[f].N[i];
                            }
                            else
                            {
                                e[1, pt].NetId = idx == 0 ? b : a;
                                e[1, pt].FacetId = FAC[f].N[i];
                            }
                        }
                        ret = a;
                    }
                    else if (r != -1 && r != -2)
                    {
                        ret = r;
                    }
                }
                return ret;
            }
        }

        // Utilities
        static bool eq(double a, double b) => Math.Abs(a - b) < EPS;
        static bool gtr(double a, double b) => a - b > EPS;
        static double Abs(double x) => x < 0 ? -x : x;

        static double DistPointPlane(Vect v, Plane p)
        {
            double num = v.Sub(p.U).Dot(p.Normal());
            double den = p.Normal().Mag();
            return num / den;
        }

        static double DistPointLine(Vect v, Line l)
        {
            double d = v.Sub(l.U).Mag();
            if (d == 0) return 0;
            return l.V.Sub(l.U).Cross(v.Sub(l.U)).Mag() / l.V.Sub(l.U).Mag();
        }

        static double DistPointPoint(Vect a, Vect b) => a.Sub(b).Mag();

        static bool isAbove(Vect v, Plane p) =>
            gtr(v.Sub(p.U).Dot(p.Normal()), 0);

        static ConvexHulls3d GetStart(Vect[] point, int totp)
        {
            Vect[] extremes = new Vect[6];
            for (int i = 0; i < 6; i++) extremes[i] = point[1];
            for (int i = 1; i <= totp; i++)
            {
                var v = point[i];
                if (gtr(v.X, extremes[0].X)) extremes[0] = v;
                if (gtr(extremes[1].X, v.X)) extremes[1] = v;
                if (gtr(v.Y, extremes[2].Y)) extremes[2] = v;
                if (gtr(extremes[3].Y, v.Y)) extremes[3] = v;
                if (gtr(v.Z, extremes[4].Z)) extremes[4] = v;
                if (gtr(extremes[5].Z, v.Z)) extremes[5] = v;
            }

            // Furthest pair
            Vect s0 = extremes[0], s1 = extremes[1];
            for (int i = 0; i < 6; i++)
                for (int j = i + 1; j < 6; j++)
                {
                    var d = DistPointPoint(extremes[i], extremes[j]);
                    if (gtr(d, DistPointPoint(s0, s1)))
                    {
                        s0 = extremes[i];
                        s1 = extremes[j];
                    }
                }

            // Furthest from line
            var line = new Line(s0, s1);
            Vect s2 = extremes[0];
            for (int i = 0; i < 6; i++)
            {
                if (gtr(DistPointLine(extremes[i], line),
                        DistPointLine(s2, line)))
                    s2 = extremes[i];
            }

            // Furthest from plane
            Vect s3 = point[1];
            var basePlane = new Plane(s0, s1, s2);
            for (int i = 1; i <= totp; i++)
            {
                var d1 = Abs(DistPointPlane(point[i], basePlane));
                var d2 = Abs(DistPointPlane(s3, basePlane));
                if (gtr(d1, d2)) s3 = point[i];
            }

            if (gtr(0, DistPointPlane(s3, basePlane)))
                (s1, s2) = (s2, s1);

            // Create 4 initial facets
            int[] f = new int[4];
            for (int i = 0; i < 4; i++)
            {
                FAC.Add(new Facet { Id = FAC.Count });
                f[i] = FAC.Count - 1;
            }
            FAC[f[0]].P = new Plane(s0, s2, s1);
            FAC[f[1]].P = new Plane(s0, s1, s3);
            FAC[f[2]].P = new Plane(s1, s2, s3);
            FAC[f[3]].P = new Plane(s2, s0, s3);

            FAC[f[0]].N = new[] { f[3], f[2], f[1] };
            FAC[f[1]].N = new[] { f[0], f[2], f[3] };
            FAC[f[2]].N = new[] { f[0], f[3], f[1] };
            FAC[f[3]].N = new[] { f[0], f[1], f[2] };

            // Prepare pts lists
            for (int i = 0; i < 4; i++)
                pts.Add(new List<Vect>());

            // Assign points
            for (int i = 1; i <= totp; i++)
            {
                var v = point[i];
                if (v.Eq(s0) || v.Eq(s1) || v.Eq(s2) || v.Eq(s3))
                    continue;
                for (int j = 0; j < 4; j++)
                    if (isAbove(v, FAC[f[j]].P))
                    {
                        pts[f[j]].Add(v);
                        break;
                    }
            }

            return new ConvexHulls3d(f[0]);
        }

        static ConvexHulls3d QuickHull3D(Vect[] point, int totp)
        {
            var hull = GetStart(point, totp);

            // Initialize queue
            queue.Clear();
            queue.Add(hull.Index);
            for (int i = 0; i < 3; i++)
                queue.Add(FAC[hull.Index].N[i]);

            int snew = 0;

            while (queue.Count > 0)
            {
                int nf = queue[0];
                queue.RemoveAt(0);
                if (FAC[nf].IsDeleted || pts[nf].Count == 0)
                {
                    if (!FAC[nf].IsDeleted)
                        snew = nf;
                    continue;
                }

                // Farthest point
                var p = pts[nf][0];
                foreach (var v in pts[nf])
                {
                    if (gtr(DistPointPlane(v, FAC[nf].P),
                            DistPointPlane(p, FAC[nf].P)))
                        p = v;
                }

                // Find horizon
                TIME++;
                resfdel.Clear();
                int s = hull.GetHorizon(nf, p, resfdel);

                // Build new faces
                resfnew.Clear();
                TIME++;
                int from = -1, lastf = -1, fstf = -1;
                while (vistime[s] != TIME)
                {
                    vistime[s] = TIME;
                    int net, f, fnew;
                    if (e[0, s].NetId == from)
                    {
                        net = e[1, s].NetId;
                        f = e[1, s].FacetId;
                    }
                    else
                    {
                        net = e[0, s].NetId;
                        f = e[0, s].FacetId;
                    }

                    // Find indices on facet f
                    int pt1 = 0, pt2 = 0;
                    for (int i = 0; i < 3; i++)
                    {
                        if (point[s].Eq(FAC[f].P.VecAt(i)))
                            pt1 = i;
                        if (point[net].Eq(FAC[f].P.VecAt(i)))
                            pt2 = i;
                    }
                    if ((pt1 + 1) % 3 != pt2)
                        (pt1, pt2) = (pt2, pt1);

                    // Create new facet
                    FAC.Add(new Facet
                    {
                        Id = FAC.Count,
                        P = new Plane(FAC[f].P.VecAt(pt2),
                                      FAC[f].P.VecAt(pt1),
                                      p)
                    });
                    fnew = FAC.Count - 1;
                    pts.Add(new List<Vect>());
                    resfnew.Add(fnew);

                    FAC[fnew].N[0] = f;
                    FAC[f].N[pt1] = fnew;

                    if (lastf >= 0)
                    {
                        // Link with previous new facet
                        if (FAC[fnew].P.VecAt(1).Eq(FAC[lastf].P.U))
                        {
                            FAC[fnew].N[1] = lastf;
                            FAC[lastf].N[2] = fnew;
                        }
                        else
                        {
                            FAC[fnew].N[2] = lastf;
                            FAC[lastf].N[1] = fnew;
                        }
                    }
                    else
                    {
                        fstf = fnew;
                    }

                    lastf = fnew;
                    from = s;
                    s = net;
                }

                // Close the loop
                if (FAC[fstf].P.VecAt(1).Eq(FAC[lastf].P.U))
                {
                    FAC[fstf].N[1] = lastf;
                    FAC[lastf].N[2] = fstf;
                }
                else
                {
                    FAC[fstf].N[2] = lastf;
                    FAC[lastf].N[1] = fstf;
                }

                // Collect deleted points
                respt.Clear();
                foreach (var fid in resfdel)
                {
                    respt.AddRange(pts[fid]);
                    pts[fid].Clear();
                }

                // Reassign
                foreach (var v in respt)
                {
                    if (v == p) continue;
                    foreach (var fid in resfnew)
                    {
                        if (isAbove(v, FAC[fid].P))
                        {
                            pts[fid].Add(v);
                            break;
                        }
                    }
                }

                // Enqueue new faces
                foreach (var fid in resfnew)
                    queue.Add(fid);
            }

            hull.Index = snew;
            return hull;
        }
    }
}
