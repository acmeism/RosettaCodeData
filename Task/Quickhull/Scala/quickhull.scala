import scala.collection.mutable
import scala.collection.mutable.{ArrayBuffer, ListBuffer}
import scala.math._
import scala.util.control.Breaks._

object QuickHull3D {
  private val MAXN = 2500
  private val EPS = 1e-8

  // Mutable state (keeping similar structure to original)
  private val facets = ArrayBuffer[Facet]()
  private val pointsPerFacet = ArrayBuffer[ArrayBuffer[Vect]]()
  private var TIME = 0
  private val edges = Array.ofDim[Edge](2, MAXN)
  private val vistime = Array.ofDim[Int](MAXN)
  private val queue = mutable.Queue[Int]()
  private val resfnew = ArrayBuffer[Int]()
  private val resfdel = ArrayBuffer[Int]()
  private val respt = ArrayBuffer[Vect]()

  // Utility functions (moved up so they're available to case classes)
  private def eq(a: Double, b: Double): Boolean = abs(a - b) < EPS
  private def gtr(a: Double, b: Double): Boolean = a - b > EPS
  private def abs(x: Double): Double = if (x < 0) -x else x

  def main(args: Array[String]): Unit = {
    preConvexHulls()

    // Example: unit tetrahedron
    val points = Array(
      null, // index 0 unused
      Vect(0, 0, 0, 1),
      Vect(1, 0, 0, 2),
      Vect(0, 1, 0, 3),
      Vect(0, 0, 1, 4)
    )

    val hull = quickHull3D(points, 4)
    println(f"${hull.getSurfaceArea}%.3f")
  }

  private def preConvexHulls(): Unit = {
    // Reserve index 0
    pointsPerFacet += ArrayBuffer[Vect]() // dummy point list[0]
    facets += Facet() // dummy facet[0]

    // Initialize edge array
    for (i <- 0 until 2; j <- 0 until MAXN) {
      edges(i)(j) = Edge()
    }
  }

  case class Vect(x: Double, y: Double, z: Double, id: Int) {
    def -(other: Vect): Vect = Vect(x - other.x, y - other.y, z - other.z, 0)

    def cross(other: Vect): Vect = Vect(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x,
      0
    )

    def dot(other: Vect): Double = x * other.x + y * other.y + z * other.z

    def magnitude: Double = sqrt(x * x + y * y + z * z)

    def ~=(other: Vect): Boolean =
      QuickHull3D.eq(x, other.x) && QuickHull3D.eq(y, other.y) && QuickHull3D.eq(z, other.z)
  }

  case class Line(u: Vect, v: Vect)

  case class Plane(u: Vect = Vect(0, 0, 0, 0), v: Vect = Vect(0, 0, 0, 0), w: Vect = Vect(0, 0, 0, 0)) {
    def normal: Vect = (v - u).cross(w - u)

    def vecAt(i: Int): Vect = i match {
      case 0 => u
      case 1 => v
      case _ => w
    }

    def vecId(i: Int): Int = vecAt(i).id
  }

  case class Facet(
    var neighbors: Array[Int] = Array(0, 0, 0),
    var id: Int = 0,
    var visitTime: Int = 0,
    var isDeleted: Boolean = false,
    var plane: Plane = Plane()
  )

  case class Edge(var netId: Int = 0, var facetId: Int = 0)

  class ConvexHulls3d(var index: Int) {
    private var surfaceArea: Double = 0.0

    private def dfsArea(f: Int): Unit = {
      val facet = facets(f)
      if (facet.visitTime == TIME) return
      facet.visitTime = TIME
      val nrm = facet.plane.normal
      surfaceArea += nrm.magnitude / 2.0
      facet.neighbors.foreach(dfsArea)
    }

    def getSurfaceArea: Double = {
      if (gtr(surfaceArea, 0.0)) return surfaceArea
      TIME += 1
      dfsArea(index)
      surfaceArea
    }

    def getHorizon(f: Int, p: Vect, resDel: ArrayBuffer[Int]): Int = {
      val facet = facets(f)
      if (!isAbove(p, facet.plane)) return 0
      if (facet.visitTime == TIME) return -1

      facet.visitTime = TIME
      facet.isDeleted = true
      resDel += facet.id

      var ret = -2
      for (i <- facet.neighbors.indices) {
        val ni = facet.neighbors(i)
        val r = getHorizon(ni, p, resDel)
        if (r == 0) {
          val a = facet.plane.vecId(i)
          val b = facet.plane.vecId((i + 1) % 3)
          for (idx <- 0 until 2) {
            val pt = if (idx == 0) a else b
            val facetId = ni
            if (vistime(pt) != TIME) {
              vistime(pt) = TIME
              edges(0)(pt).netId = if (idx == 0) b else a
              edges(0)(pt).facetId = facetId
            } else {
              edges(1)(pt).netId = if (idx == 0) b else a
              edges(1)(pt).facetId = facetId
            }
          }
          ret = a
        } else if (r != -1 && r != -2) {
          ret = r
        }
      }
      ret
    }
  }

  private def distPointPlane(v: Vect, p: Plane): Double = {
    val num = (v - p.u).dot(p.normal)
    val den = p.normal.magnitude
    num / den
  }

  private def distPointLine(v: Vect, l: Line): Double = {
    val d = (v - l.u).magnitude
    if (d == 0) return 0
    (l.v - l.u).cross(v - l.u).magnitude / (l.v - l.u).magnitude
  }

  private def distPointPoint(a: Vect, b: Vect): Double = (a - b).magnitude

  private def isAbove(v: Vect, p: Plane): Boolean =
    gtr((v - p.u).dot(p.normal), 0)

  private def getStart(points: Array[Vect], totalPoints: Int): ConvexHulls3d = {
    // Find extreme points
    val extremes = Array.fill(6)(points(1))
    for (i <- 1 to totalPoints) {
      val v = points(i)
      if (gtr(v.x, extremes(0).x)) extremes(0) = v
      if (gtr(extremes(1).x, v.x)) extremes(1) = v
      if (gtr(v.y, extremes(2).y)) extremes(2) = v
      if (gtr(extremes(3).y, v.y)) extremes(3) = v
      if (gtr(v.z, extremes(4).z)) extremes(4) = v
      if (gtr(extremes(5).z, v.z)) extremes(5) = v
    }

    // Find furthest pair
    var (s0, s1) = (extremes(0), extremes(1))
    for (i <- extremes.indices; j <- i + 1 until extremes.length) {
      val d = distPointPoint(extremes(i), extremes(j))
      if (gtr(d, distPointPoint(s0, s1))) {
        s0 = extremes(i)
        s1 = extremes(j)
      }
    }

    // Find point furthest from line
    val line = Line(s0, s1)
    var s2 = extremes(0)
    for (extreme <- extremes) {
      if (gtr(distPointLine(extreme, line), distPointLine(s2, line))) {
        s2 = extreme
      }
    }

    // Find point furthest from plane
    var s3 = points(1)
    val basePlane = Plane(s0, s1, s2)
    for (i <- 1 to totalPoints) {
      val d1 = abs(distPointPlane(points(i), basePlane))
      val d2 = abs(distPointPlane(s3, basePlane))
      if (gtr(d1, d2)) s3 = points(i)
    }

    if (gtr(0, distPointPlane(s3, basePlane))) {
      val tmp = s1; s1 = s2; s2 = tmp
    }

    // Create 4 initial facets
    val f = Array.ofDim[Int](4)
    for (i <- 0 until 4) {
      val facet = Facet()
      facet.id = facets.length
      facets += facet
      f(i) = facets.length - 1
    }

    facets(f(0)).plane = Plane(s0, s2, s1)
    facets(f(1)).plane = Plane(s0, s1, s3)
    facets(f(2)).plane = Plane(s1, s2, s3)
    facets(f(3)).plane = Plane(s2, s0, s3)

    facets(f(0)).neighbors = Array(f(3), f(2), f(1))
    facets(f(1)).neighbors = Array(f(0), f(2), f(3))
    facets(f(2)).neighbors = Array(f(0), f(3), f(1))
    facets(f(3)).neighbors = Array(f(0), f(1), f(2))

    // Prepare point lists for the 4 facets
    for (_ <- 0 until 4) {
      pointsPerFacet += ArrayBuffer[Vect]()
    }

    // Assign points to facets
    for (i <- 1 to totalPoints) {
      val v = points(i)
      if (!(v ~= s0) && !(v ~= s1) && !(v ~= s2) && !(v ~= s3)) {
        breakable({
        for (j <- 0 until 4) {
          if (isAbove(v, facets(f(j)).plane)) {
            pointsPerFacet(f(j)) += v
            break
          }
        }
        });
      }
    }

    new ConvexHulls3d(f(0))
  }

  def quickHull3D(points: Array[Vect], totalPoints: Int): ConvexHulls3d = {
    val hull = getStart(points, totalPoints)
    queue.clear()
    queue.enqueue(hull.index)
    facets(hull.index).neighbors.foreach(queue.enqueue)

    var snew = 0
    while (queue.nonEmpty) {
    breakable({
      val nf = queue.dequeue()
      val facet = facets(nf)
      if (facet.isDeleted || pointsPerFacet(nf).isEmpty) {
        if (!facet.isDeleted) snew = nf
          break//continue
      }

      // Find farthest point from facet plane
      var p = pointsPerFacet(nf).head
      for (v <- pointsPerFacet(nf)) {
        if (gtr(distPointPlane(v, facet.plane), distPointPlane(p, facet.plane))) {
          p = v
        }
      }

      // Find horizon
      TIME += 1
      resfdel.clear()
      val s = hull.getHorizon(nf, p, resfdel)

      // Build new faces
      resfnew.clear()
      TIME += 1
      var from = -1
      var lastf = -1
      var fstf = -1
      var currentS = s

      while (vistime(currentS) != TIME) {
        vistime(currentS) = TIME
        val (net, fidx) = if (edges(0)(currentS).netId == from) {
          (edges(1)(currentS).netId, edges(1)(currentS).facetId)
        } else {
          (edges(0)(currentS).netId, edges(0)(currentS).facetId)
        }

        // Find indices on facet fidx
        val facetFidx = facets(fidx)
        var (pt1, pt2) = (0, 0)
        for (i <- 0 until 3) {
          if (points(currentS) ~= facetFidx.plane.vecAt(i)) pt1 = i
          if (points(net) ~= facetFidx.plane.vecAt(i)) pt2 = i
        }
        if ((pt1 + 1) % 3 != pt2) {
          val tmp = pt1; pt1 = pt2; pt2 = tmp
        }

        // Create new facet
        val newFacet = Facet()
        newFacet.id = facets.length
        newFacet.plane = Plane(
          facetFidx.plane.vecAt(pt2),
          facetFidx.plane.vecAt(pt1),
          p
        )
        facets += newFacet
        pointsPerFacet += ArrayBuffer[Vect]()
        val fnew = facets.length - 1
        resfnew += fnew

        // Link neighborhoods
        newFacet.neighbors(0) = fidx
        facetFidx.neighbors(pt1) = fnew

        if (lastf >= 0) {
          val newPlane = newFacet.plane
          val lastPlane = facets(lastf).plane
          if (newPlane.vecAt(1) ~= lastPlane.u) {
            newFacet.neighbors(1) = lastf
            facets(lastf).neighbors(2) = fnew
          } else {
            newFacet.neighbors(2) = lastf
            facets(lastf).neighbors(1) = fnew
          }
        } else {
          fstf = fnew
        }

        lastf = fnew
        from = currentS
        currentS = net
      }

      // Close the loop
      val firstFacet = facets(fstf)
      val lastFacet = facets(lastf)
      if (firstFacet.plane.vecAt(1) ~= lastFacet.plane.u) {
        firstFacet.neighbors(1) = lastf
        lastFacet.neighbors(2) = fstf
      } else {
        firstFacet.neighbors(2) = lastf
        lastFacet.neighbors(1) = fstf
      }

      // Collect deleted points
      respt.clear()
      for (fid <- resfdel) {
        respt ++= pointsPerFacet(fid)
        pointsPerFacet(fid).clear()
      }

      // Reassign points
      for (v <- respt if v != p) {
        for (fid <- resfnew) {
          if (isAbove(v, facets(fid).plane)) {
            pointsPerFacet(fid) += v
            break
          }
        }
      }

      // Enqueue new faces
      resfnew.foreach(queue.enqueue)
    });
    }

    hull.index = snew
    hull
  }
}
