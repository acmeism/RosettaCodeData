/*  QuickHull3D – Kotlin version (fixed + wrapper)
    -------------------------------------------------
    No algorithmic changes – only the two fixes explained above.
*/

import kotlin.math.abs
import kotlin.math.sqrt

private const val MAXN = 2500
private const val EPS = 1e-8

object QuickHull3D {

    // -----------------------------------------------------------------
    // Global structures (static fields in Java)
    // -----------------------------------------------------------------
    val FAC = mutableListOf<Facet>()                     // facets (index 0 is dummy)
    val pts = mutableListOf<MutableList<Vect>>()         // points belonging to each facet
    var TIME = 0                                         // global timestamp
    val e = Array(2) { Array(MAXN) { Edge() } }          // adjacency edges (two per vertex)
    val vistime = IntArray(MAXN)                         // used while walking the horizon
    val queue = mutableListOf<Int>()                     // processing queue
    val resfnew = mutableListOf<Int>()                   // new facets (temp)
    val resfdel = mutableListOf<Int>()                   // deleted facets (temp)
    val respt = mutableListOf<Vect>()                    // points to be reassigned (temp)

    // -----------------------------------------------------------------
    // Entry point – same test as the Java version
    // -----------------------------------------------------------------
    @JvmStatic
    fun main(args: Array<String>) {
        preConvexHulls()

        // Example: unit tetrahedron (1‑based indexing, point[0] is a dummy)
        val n = 4
        val point = arrayOfNulls<Vect>(n + 1)
        point[0] = Vect(0.0, 0.0, 0.0, 0)        // dummy, never used by the algorithm
        point[1] = Vect(0.0, 0.0, 0.0, 1)
        point[2] = Vect(1.0, 0.0, 0.0, 2)
        point[3] = Vect(0.0, 1.0, 0.0, 3)
        point[4] = Vect(0.0, 0.0, 1.0, 4)

        // “requireNoNulls” is now safe because point[0] is filled
        val hull = quickHull3D(point.requireNoNulls(), n)
        System.out.printf("%.3f%n", hull.surfaceArea())
    }

    // -----------------------------------------------------------------
    private fun preConvexHulls() {
        pts.add(mutableListOf())    // pts[0] – dummy list
        FAC.add(Facet())            // FAC[0] – dummy facet
        for (i in 0..1) {
            for (j in 0 until MAXN) {
                e[i][j] = Edge()
            }
        }
    }

    // -----------------------------------------------------------------
    // Geometry primitives
    // -----------------------------------------------------------------
    data class Vect(
        var X: Double,
        var Y: Double,
        var Z: Double,
        var Id: Int
    ) {
        fun sub(b: Vect) = Vect(X - b.X, Y - b.Y, Z - b.Z, 0)
        fun cross(b: Vect) = Vect(
            Y * b.Z - Z * b.Y,
            Z * b.X - X * b.Z,
            X * b.Y - Y * b.X,
            0
        )
        fun dot(b: Vect) = X * b.X + Y * b.Y + Z * b.Z
        fun mag() = sqrt(X * X + Y * Y + Z * Z)
        fun eq(b: Vect) = eq(X, b.X) && eq(Y, b.Y) && eq(Z, b.Z)
    }

    data class Line(val U: Vect, val V: Vect)

    class Plane() {
        lateinit var U: Vect
        lateinit var V: Vect
        lateinit var W: Vect

        constructor(u: Vect, v: Vect, w: Vect) : this() {
            U = u; V = v; W = w
        }

        fun normal(): Vect = V.sub(U).cross(W.sub(U))
        fun vecAt(i: Int): Vect = when (i) {
            0 -> U
            1 -> V
            else -> W
        }

        fun vecId(i: Int) = vecAt(i).Id
    }

    class Facet {
        var N = IntArray(3)                 // neighbour facet indices
        var Id = 0
        var visitTime = 0
        var isDeleted = false
        var P = Plane()
    }

    class Edge {
        var netId = 0
        var facetId = 0
    }

    // -----------------------------------------------------------------
    // Convex hull container (same as Java inner class)
    // -----------------------------------------------------------------
    class ConvexHulls3d(var index: Int) {

        var surfaceArea = 0.0

        private fun dfsArea(f: Int) {
            val F = FAC[f]
            if (F.visitTime == TIME) return
            F.visitTime = TIME
            val nrm = F.P.normal()
            surfaceArea += nrm.mag() / 2.0
            for (i in 0..2) dfsArea(F.N[i])
        }

        fun surfaceArea(): Double {
            if (gtr(surfaceArea, 0.0)) return surfaceArea
            TIME++
            dfsArea(index)
            return surfaceArea
        }

        /** Horizon detection – returns one vertex of the horizon (or sentinel) */
        fun getHorizon(f: Int, p: Vect, resDel: MutableList<Int>): Int {
            val Ff = FAC[f]
            if (!isAbove(p, Ff.P)) return 0
            if (Ff.visitTime == TIME) return -1

            Ff.visitTime = TIME
            Ff.isDeleted = true
            resDel.add(Ff.Id)

            var ret = -2
            for (i in 0..2) {
                val ni = Ff.N[i]
                val r = getHorizon(ni, p, resDel)
                if (r == 0) {
                    val a = Ff.P.vecId(i)
                    val b = Ff.P.vecId((i + 1) % 3)
                    for (idx in 0..1) {
                        val pt = if (idx == 0) a else b
                        val facet = ni
                        if (vistime[pt] != TIME) {
                            vistime[pt] = TIME
                            e[0][pt].netId = if (idx == 0) b else a
                            e[0][pt].facetId = facet
                        } else {
                            e[1][pt].netId = if (idx == 0) b else a
                            e[1][pt].facetId = facet
                        }
                    }
                    ret = a
                } else if (r != -1 && r != -2) {
                    ret = r
                }
            }
            return ret
        }
    }

    // -----------------------------------------------------------------
    // Utility functions (same as Java static helpers)
    // -----------------------------------------------------------------
    private fun eq(a: Double, b: Double) = kotlin.math.abs(a - b) < EPS
    private fun gtr(a: Double, b: Double) = a - b > EPS
    private fun abs(x: Double) = kotlin.math.abs(x)

    private fun distPointPlane(v: Vect, p: Plane): Double {
        val num = v.sub(p.U).dot(p.normal())
        val den = p.normal().mag()
        return num / den
    }

    private fun distPointLine(v: Vect, l: Line): Double {
        val d = v.sub(l.U).mag()
        if (d == 0.0) return 0.0
        return l.V.sub(l.U).cross(v.sub(l.U)).mag() / l.V.sub(l.U).mag()
    }

    private fun distPointPoint(a: Vect, b: Vect) = a.sub(b).mag()
    private fun isAbove(v: Vect, p: Plane) = gtr(v.sub(p.U).dot(p.normal()), 0.0)

    // -----------------------------------------------------------------
    // Core algorithm (unchanged apart from the two fixes)
    // -----------------------------------------------------------------
    private fun getStart(point: Array<Vect>, totp: Int): ConvexHulls3d {
        // ---- extremes in each coordinate direction ----
        val extremes = Array(6) { point[0] }
        for (i in 1..totp) {
            val v = point[i]
            if (gtr(v.X, extremes[0].X)) extremes[0] = v
            if (gtr(extremes[1].X, v.X)) extremes[1] = v
            if (gtr(v.Y, extremes[2].Y)) extremes[2] = v
            if (gtr(extremes[3].Y, v.Y)) extremes[3] = v
            if (gtr(v.Z, extremes[4].Z)) extremes[4] = v
            if (gtr(extremes[5].Z, v.Z)) extremes[5] = v
        }

        // ---- furthest pair among extremes ------------
        var s0 = extremes[0]
        var s1 = extremes[1]
        for (i in 0 until 6) {
            for (j in i + 1 until 6) {
                val d = distPointPoint(extremes[i], extremes[j])
                if (gtr(d, distPointPoint(s0, s1))) {
                    s0 = extremes[i]; s1 = extremes[j]
                }
            }
        }

        // ---- furthest point from that line ------------
        val line = Line(s0, s1)
        var s2 = extremes[0]
        for (i in 0 until 6) {
            if (gtr(distPointLine(extremes[i], line), distPointLine(s2, line))) {
                s2 = extremes[i]
            }
        }

        // ---- furthest point from the plane s0,s1,s2 ---
        var s3 = point[1]
        val basePlane = Plane(s0, s1, s2)
        for (i in 1..totp) {
            val d1 = abs(distPointPlane(point[i], basePlane))
            val d2 = abs(distPointPlane(s3, basePlane))
            if (gtr(d1, d2)) s3 = point[i]
        }

        // ---- fix orientation if needed ---------------
        if (gtr(0.0, distPointPlane(s3, basePlane))) {
            val tmp = s1; s1 = s2; s2 = tmp
        }

        // ---- create the 4 initial facets ---------------
        val f = IntArray(4)
        repeat(4) {
            val F = Facet()
            F.Id = FAC.size
            FAC.add(F)
            f[it] = FAC.size - 1
        }

        FAC[f[0]].P = Plane(s0, s2, s1)
        FAC[f[1]].P = Plane(s0, s1, s3)
        FAC[f[2]].P = Plane(s1, s2, s3)
        FAC[f[3]].P = Plane(s2, s0, s3)

        FAC[f[0]].N = intArrayOf(f[3], f[2], f[1])
        FAC[f[1]].N = intArrayOf(f[0], f[2], f[3])
        FAC[f[2]].N = intArrayOf(f[0], f[3], f[1])
        FAC[f[3]].N = intArrayOf(f[0], f[1], f[2])

        // ---- allocate point buckets for these facets ---
        repeat(4) { pts.add(mutableListOf()) }

        // ---- assign each non‑extreme point to a visible facet --
        for (i in 1..totp) {
            val v = point[i]
            if (v.eq(s0) || v.eq(s1) || v.eq(s2) || v.eq(s3)) continue
            for (j in 0..3) {
                if (isAbove(v, FAC[f[j]].P)) {
                    pts[f[j]].add(v)
                    break
                }
            }
        }

        return ConvexHulls3d(f[0])
    }

    private fun quickHull3D(point: Array<Vect>, totp: Int): ConvexHulls3d {
        val hull = getStart(point, totp)

        // initialise queue with the starting facet and its three neighbours
        queue.clear()
        queue.add(hull.index)
        repeat(3) { queue.add(FAC[hull.index].N[it]) }

        var snew = 0

        while (queue.isNotEmpty()) {
            val nf = queue.removeAt(0)
            val Fnf = FAC[nf]

            // skip deleted facets or empty point sets
            if (Fnf.isDeleted || pts[nf].isEmpty()) {
                if (!Fnf.isDeleted) snew = nf
                continue
            }

            // ---- farthest point of the current bucket ----
            var p = pts[nf][0]
            for (v in pts[nf]) {
                if (gtr(distPointPlane(v, Fnf.P), distPointPlane(p, Fnf.P))) {
                    p = v
                }
            }

            // ---- horizon detection -----------------------
            TIME++
            resfdel.clear()
            val s = hull.getHorizon(nf, p, resfdel)

            // ---- build new faces attached to the horizon ----
            resfnew.clear()
            TIME++
            var from = -1
            var lastf = -1
            var fstf = -1
            var cur = s
            while (vistime[cur] != TIME) {
                vistime[cur] = TIME
                val (net, fIdx) = if (e[0][cur].netId == from) {
                    e[1][cur].netId to e[1][cur].facetId
                } else {
                    e[0][cur].netId to e[0][cur].facetId
                }

                // locate the two vertices of facet fIdx that correspond to cur / net
                val Ff = FAC[fIdx]
                var pt1 = -1
                var pt2 = -1
                for (i in 0..2) {
                    if (point[cur].eq(Ff.P.vecAt(i))) pt1 = i
                    if (point[net].eq(Ff.P.vecAt(i))) pt2 = i
                }
                if ((pt1 + 1) % 3 != pt2) {
                    val tmp = pt1; pt1 = pt2; pt2 = tmp
                }

                // ---- create the new facet --------------------
                val newF = Facet()
                newF.Id = FAC.size
                newF.P = Plane(Ff.P.vecAt(pt2), Ff.P.vecAt(pt1), p)
                FAC.add(newF)
                pts.add(mutableListOf())
                val fnew = FAC.size - 1
                resfnew.add(fnew)

                // ---- neighbour links -------------------------
                newF.N[0] = fIdx
                Ff.N[pt1] = fnew

                if (lastf >= 0) {
                    val Pf1 = newF.P
                    val Plast = FAC[lastf].P
                    if (Pf1.vecAt(1).eq(Plast.U)) {
                        newF.N[1] = lastf
                        FAC[lastf].N[2] = fnew
                    } else {
                        newF.N[2] = lastf
                        FAC[lastf].N[1] = fnew
                    }
                } else {
                    fstf = fnew
                }

                // advance on the horizon loop
                lastf = fnew
                from = cur
                cur = net
            }

            // ---- close the horizon loop (first ↔ last) ----
            val Ffst = FAC[fstf]
            val Flast = FAC[lastf]
            // *** FIXED LINE *** – correct access to the vertex of the plane
            if (Ffst.P.vecAt(1).eq(Flast.P.U)) {
                Ffst.N[1] = lastf
                Flast.N[2] = fstf
            } else {
                Ffst.N[2] = lastf
                Flast.N[1] = fstf
            }

            // ---- collect points that disappeared with deleted facets ----
            respt.clear()
            for (fid in resfdel) {
                respt.addAll(pts[fid])
                pts[fid].clear()
            }

            // ---- re‑assign those points to the newly created facets ----
            for (v in respt) {
                if (v === p) continue
                for (fid in resfnew) {
                    if (isAbove(v, FAC[fid].P)) {
                        pts[fid].add(v)
                        break
                    }
                }
            }

            // ---- enqueue the new facets for later processing ------------
            for (fid in resfnew) queue.add(fid)
        }

        hull.index = snew
        return hull
    }
}

/* -----------------------------------------------------------------
   Tiny top‑level wrapper so that the JVM can find “main” in MainKt.
   You can delete this function if you prefer to launch the program
   with “java QuickHull3D” instead of “java MainKt”.
----------------------------------------------------------------- */
fun main(args: Array<String>) = QuickHull3D.main(args)
