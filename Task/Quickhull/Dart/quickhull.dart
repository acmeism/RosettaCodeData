import 'dart:math';
import 'dart:io';

// ---------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------
const int MAX_SIZE = 2500;
const double EPSILON = 1e-8;

// ---------------------------------------------------------------------
// Numerical utilities (exact copy of the C++ helpers)
// ---------------------------------------------------------------------
bool isGreaterThan(double a, double b) => (a - b) > EPSILON;

bool isEqual(double a, double b) => (a - b).abs() < EPSILON;

// ---------------------------------------------------------------------
// Geometry primitives
// ---------------------------------------------------------------------
class Vector {
  double x, y, z;
  int id; // (in C++ it is uint32_t, here we use int)

  Vector([this.x = 0, this.y = 0, this.z = 0, this.id = 0]);

  Vector subtract(Vector other) =>
      Vector(x - other.x, y - other.y, z - other.z);

  Vector vectorProduct(Vector other) => Vector(
        y * other.z - z * other.y,
        z * other.x - x * other.z,
        x * other.y - y * other.x,
      );

  double scalarProduct(Vector other) =>
      x * other.x + y * other.y + z * other.z;

  double magnitude() => sqrt(x * x + y * y + z * z);

  bool equals(Vector b) =>
      isEqual(x, b.x) && isEqual(y, b.y) && isEqual(z, b.z);
}

// ---------------------------------------------------------------------
// Line and Plane
// ---------------------------------------------------------------------
class Line {
  Vector u, v;
  Line(this.u, this.v);
}

class Plane {
  Vector u, v, w;

  Plane([Vector? a, Vector? b, Vector? c])
      : u = a ?? Vector(),
        v = b ?? Vector(),
        w = c ?? Vector();

  Vector normal() => v.subtract(u).vectorProduct(w.subtract(u));

  Vector vectorAtIndex(int i) {
    switch (i) {
      case 0:
        return u;
      case 1:
        return v;
      case 2:
        return w;
      default:
        throw RangeError('Plane only has three vectors');
    }
  }

  int vectorId(int i) => vectorAtIndex(i).id;
}

// ---------------------------------------------------------------------
// Facet and Edge
// ---------------------------------------------------------------------
class Facet {
  List<int> N = List.filled(3, 0);
  int id = 0;
  int visitedTime = 0;
  bool isDeleted = false;
  Plane plane = Plane();

  Facet([this.id = 0, Plane? p]) {
    if (p != null) plane = p;
  }
}

class Edge {
  int netID = 0;
  int faceID = 0;
}

// ---------------------------------------------------------------------
// Global containers (exactly the same layout as the C++ version)
// ---------------------------------------------------------------------
class _Globals {
  static List<Facet> facets = <Facet>[];
  static List<List<Vector>> hullPoints = <List<Vector>>[];
  static int timeStep = 0;

  // edges[2][MAX_SIZE]
  static List<List<Edge>> edges = List.generate(
      2, (_) => List.generate(MAX_SIZE, (_) => Edge()));

  static List<int> visitTime = List.filled(MAX_SIZE, 0);
  static List<int> queue = <int>[];
  static List<int> resFNew = <int>[];
  static List<int> resFDel = <int>[];
  static List<Vector> resPt = <Vector>[];
}

// ---------------------------------------------------------------------
// Geometry helpers (distance, above‑test …)
// ---------------------------------------------------------------------
double distancePointPlane(Vector vec, Plane plane) {
  final num = vec.subtract(plane.u).scalarProduct(plane.normal());
  final den = plane.normal().magnitude();
  return num / den;
}

double distancePointLine(Vector vec, Line line) {
  final length = vec.subtract(line.u).magnitude();
  if (length == 0.0) return 0.0;
  final cross = line.v
      .subtract(line.u)
      .vectorProduct(vec.subtract(line.u))
      .magnitude();
  final denom = line.v.subtract(line.u).magnitude();
  return cross / denom;
}

double distancePointPoint(Vector a, Vector b) => a.subtract(b).magnitude();

bool isAbove(Vector point, Plane plane) =>
    isGreaterThan(point.subtract(plane.u).scalarProduct(plane.normal()), 0.0);

// ---------------------------------------------------------------------
// Convex‑Hull wrapper (the class that contains the surface‑area routine)
// ---------------------------------------------------------------------
class ConvexHulls3d {
  int index; // the facet that currently holds the hull
  double surfaceArea = 0.0;

  ConvexHulls3d(this.index);

  double getSurfaceArea() {
    if (isGreaterThan(surfaceArea, 0.0)) return surfaceArea;

    _Globals.timeStep++;
    _dfsArea(index);
    return surfaceArea;
  }

  // -----------------------------------------------------------------
  // Recursive horizon search – returns the first point of the horizon
  // (or –1 / –2 as sentinel values, exactly like the C++ code)
  // -----------------------------------------------------------------
  int getHorizon(int f, Vector point, List<int> resDel) {
    final Facet Ff = _Globals.facets[f];
    if (!isAbove(point, Ff.plane)) return 0;
    if (Ff.visitedTime == _Globals.timeStep) return -1;

    Ff.visitedTime = _Globals.timeStep;
    Ff.isDeleted = true;
    resDel.add(Ff.id);
    int result = -2; // “not decided yet”

    for (int i = 0; i < 3; ++i) {
      final int ni = Ff.N[i];
      final int horizon = getHorizon(ni, point, resDel);
      if (horizon == 0) {
        // Horizon edge – store it in the global “edges” table
        final int a = _Globals.facets[f].plane.vectorId(i);
        final int b = _Globals.facets[f].plane.vectorId((i + 1) % 3);
        for (int idx = 0; idx < 2; ++idx) {
          final int pt = (idx == 0) ? a : b;
          final int facet = ni;
          if (_Globals.visitTime[pt] != _Globals.timeStep) {
            _Globals.visitTime[pt] = _Globals.timeStep;
            _Globals.edges[0][pt].netID = (idx == 0) ? b : a;
            _Globals.edges[0][pt].faceID = facet;
          } else {
            _Globals.edges[1][pt].netID = (idx == 0) ? b : a;
            _Globals.edges[1][pt].faceID = facet;
          }
        }
        result = a;
      } else if (horizon != -1 && horizon != -2) {
        result = horizon;
      }
    }
    return result;
  }

  // -----------------------------------------------------------------
  // Depth‑first search for surface area (exact copy of the C++ code)
  // -----------------------------------------------------------------
  void _dfsArea(int f) {
    if (_Globals.facets[f].visitedTime == _Globals.timeStep) return;
    _Globals.facets[f].visitedTime = _Globals.timeStep;
    final Vector normal = _Globals.facets[f].plane.normal();
    surfaceArea += normal.magnitude() / 2.0;
    for (int i = 0; i < 3; ++i) {
      _dfsArea(_Globals.facets[f].N[i]);
    }
  }
}

// ---------------------------------------------------------------------
// Helper that creates the four‑point seed tetrahedron
// ---------------------------------------------------------------------
ConvexHulls3d getInitialHull(List<Vector> points, int totalPoints) {
  // -------------------------------------------------
  // 1️⃣ Find the 6 extreme points (min / max on each axis)
  // -------------------------------------------------
  final List<Vector> extremes = List.filled(6, points[1]);
  for (int i = 1; i <= totalPoints; ++i) {
    final Vector p = points[i];
    if (isGreaterThan(p.x, extremes[0].x)) extremes[0] = p;
    if (isGreaterThan(extremes[1].x, p.x)) extremes[1] = p;
    if (isGreaterThan(p.y, extremes[2].y)) extremes[2] = p;
    if (isGreaterThan(extremes[3].y, p.y)) extremes[3] = p;
    if (isGreaterThan(p.z, extremes[4].z)) extremes[4] = p;
    if (isGreaterThan(extremes[5].z, p.z)) extremes[5] = p;
  }

  // -------------------------------------------------
  // 2️⃣ Furthest pair among the six extremes → line
  // -------------------------------------------------
  Vector extreme0 = extremes[0];
  Vector extreme1 = extremes[1];
  for (int i = 0; i < 6; ++i) {
    for (int j = i + 1; j < 6; ++j) {
      final d = distancePointPoint(extremes[i], extremes[j]);
      if (isGreaterThan(d, distancePointPoint(extreme0, extreme1))) {
        extreme0 = extremes[i];
        extreme1 = extremes[j];
      }
    }
  }

  // -------------------------------------------------
  // 3️⃣ Furthest point from that line → third vertex
  // -------------------------------------------------
  final line = Line(extreme0, extreme1);
  Vector extreme2 = extremes[0];
  for (int i = 0; i < 6; ++i) {
    if (isGreaterThan(
        distancePointLine(extremes[i], line),
        distancePointLine(extreme2, line))) {
      extreme2 = extremes[i];
    }
  }

  // -------------------------------------------------
  // 4️⃣ Furthest point from the plane defined by the three above
  // -------------------------------------------------
  final basePlane = Plane(extreme0, extreme1, extreme2);
  Vector extreme3 = points[1];
  for (int i = 1; i <= totalPoints; ++i) {
    final d1 = distancePointPlane(points[i], basePlane).abs();
    final d2 = distancePointPlane(extreme3, basePlane).abs();
    if (isGreaterThan(d1, d2)) extreme3 = points[i];
  }

  // If the point lies under the plane we have to flip two vertices
  if (isGreaterThan(0.0, distancePointPlane(extreme3, basePlane))) {
    final tmp = extreme1;
    extreme1 = extreme2;
    extreme2 = tmp;
  }

  // -------------------------------------------------
  // 5️⃣ Create the first four facets (the seed tetrahedron)
  // -------------------------------------------------
  final List<int> f = List.filled(4, 0);
  for (int i = 0; i < 4; ++i) {
    _Globals.facets.add(Facet(_Globals.facets.length));
    f[i] = _Globals.facets.length - 1;
  }

  _Globals.facets[f[0]].plane = Plane(extreme0, extreme2, extreme1);
  _Globals.facets[f[1]].plane = Plane(extreme0, extreme1, extreme3);
  _Globals.facets[f[2]].plane = Plane(extreme1, extreme2, extreme3);
  _Globals.facets[f[3]].plane = Plane(extreme2, extreme0, extreme3);

  _Globals.facets[f[0]].N = [f[3], f[2], f[1]];
  _Globals.facets[f[1]].N = [f[0], f[2], f[3]];
  _Globals.facets[f[2]].N = [f[0], f[3], f[1]];
  _Globals.facets[f[3]].N = [f[0], f[1], f[2]];

  // -------------------------------------------------
  // 6️⃣ Allocate hull‑point containers (one per facet)
  // -------------------------------------------------
  for (int i = 0; i < 4; ++i) {
    _Globals.hullPoints.add(<Vector>[]);
  }

  // -------------------------------------------------
  // 7️⃣ Distribute the remaining points to the facet they lie “above”
  // -------------------------------------------------
  for (int i = 1; i <= totalPoints; ++i) {
    final Vector p = points[i];
    if (p.equals(extreme0) ||
        p.equals(extreme1) ||
        p.equals(extreme2) ||
        p.equals(extreme3)) continue;

    for (int j = 0; j < 4; ++j) {
      if (isAbove(p, _Globals.facets[f[j]].plane)) {
        _Globals.hullPoints[f[j]].add(p);
        break;
      }
    }
  }

  return ConvexHulls3d(f[0]);
}

// ---------------------------------------------------------------------
// Main Quick‑Hull driver (exact port of the C++ `QuickHull3D` function)
// ---------------------------------------------------------------------
ConvexHulls3d quickHull3D(List<Vector> points, int totalPoints) {
  ConvexHulls3d hull = getInitialHull(points, totalPoints);

  // ---- initialise the processing queue --------------------------------
  _Globals.queue.clear();
  _Globals.queue.add(hull.index);
  for (int i = 0; i < 3; ++i) {
    _Globals.queue.add(_Globals.facets[hull.index].N[i]);
  }

  int newHorizon = 0;

  while (_Globals.queue.isNotEmpty) {
    final int nf = _Globals.queue.removeAt(0);

    // facet already deleted or empty → skip (but remember the last non‑deleted)
    if (_Globals.facets[nf].isDeleted || _Globals.hullPoints[nf].isEmpty) {
      if (!_Globals.facets[nf].isDeleted) newHorizon = nf;
      continue;
    }

    // -------------------------------------------------
    // 1️⃣ Find the furthest point of the current facet
    // -------------------------------------------------
    Vector point = _Globals.hullPoints[nf][0];
    for (final vec in _Globals.hullPoints[nf]) {
      if (isGreaterThan(
          distancePointPlane(vec, _Globals.facets[nf].plane),
          distancePointPlane(point, _Globals.facets[nf].plane))) {
        point = vec;
      }
    }

    // -------------------------------------------------
    // 2️⃣ Determine the horizon (all facets that will be removed)
    // -------------------------------------------------
    _Globals.timeStep++;
    _Globals.resFDel.clear();
    final int horizon = hull.getHorizon(nf, point, _Globals.resFDel);

    // -------------------------------------------------
    // 3️⃣ Build the new faces that replace the deleted ones
    // -------------------------------------------------
    _Globals.resFNew.clear();
    _Globals.timeStep++;
    int from = -1;
    int lastF = -1;
    int firstF = -1;

    int cur = horizon;
    while (_Globals.visitTime[cur] != _Globals.timeStep) {
      // mark as visited in this sweep
      _Globals.visitTime[cur] = _Globals.timeStep;

      // ----- find the "next" edge on the horizon -----
      int net, f;
      if (_Globals.edges[0][cur].netID == from) {
        net = _Globals.edges[1][cur].netID;
        f = _Globals.edges[1][cur].faceID;
      } else {
        net = _Globals.edges[0][cur].netID;
        f = _Globals.edges[0][cur].faceID;
      }

      // ----- locate the two vertices of the old facet that belong to this edge -----
      int pt1 = 0, pt2 = 0;
      for (int i = 0; i < 3; ++i) {
        if (points[cur].equals(_Globals.facets[f].plane.vectorAtIndex(i))) pt1 = i;
        if (points[net].equals(_Globals.facets[f].plane.vectorAtIndex(i))) pt2 = i;
      }
      // guarantee (pt1,pt2) are oriented consistently
      if ((pt1 + 1) % 3 != pt2) {
        final tmp = pt1;
        pt1 = pt2;
        pt2 = tmp;
      }

      // ----- create the new facet -----
      final Plane newPlane = Plane(
          _Globals.facets[f].plane.vectorAtIndex(pt2),
          _Globals.facets[f].plane.vectorAtIndex(pt1),
          point);
      _Globals.facets.add(Facet(_Globals.facets.length, newPlane));
      final int newF = _Globals.facets.length - 1;
      _Globals.hullPoints.add(<Vector>[]);
      _Globals.resFNew.add(newF);

      // ----- link the new facet with the old neighbour -----
      _Globals.facets[newF].N[0] = f;
      _Globals.facets[f].N[pt1] = newF;

      // ----- link consecutive new facets together (forming a fan) -----
      if (lastF >= 0) {
        // the orientation of the shared edge decides which N‑slot to fill
        if (_Globals.facets[newF].plane.vectorAtIndex(1).equals(_Globals.facets[lastF].plane.u)) {
          _Globals.facets[newF].N[1] = lastF;
          _Globals.facets[lastF].N[2] = newF;
        } else {
          _Globals.facets[newF].N[2] = lastF;
          _Globals.facets[lastF].N[1] = newF;
        }
      } else {
        firstF = newF;
      }

      lastF = newF;
      from = cur;
      cur = net;
    }

    // ---- close the fan (first ↔ last) ----
    if (_Globals.facets[firstF].plane.vectorAtIndex(1).equals(_Globals.facets[lastF].plane.u)) {
      _Globals.facets[firstF].N[1] = lastF;
      _Globals.facets[lastF].N[2] = firstF;
    } else {
      _Globals.facets[firstF].N[2] = lastF;
      _Globals.facets[lastF].N[1] = firstF;
    }

    // -------------------------------------------------
    // 4️⃣ Re‑assign points that were stored in the deleted facets
    // -------------------------------------------------
    _Globals.resPt.clear();
    for (final int fId in _Globals.resFDel) {
      _Globals.resPt.addAll(_Globals.hullPoints[fId]);
      _Globals.hullPoints[fId].clear();
    }

    for (final Vector vec in _Globals.resPt) {
      if (vec.equals(point)) continue;
      for (final int fId in _Globals.resFNew) {
        if (isAbove(vec, _Globals.facets[fId].plane)) {
          _Globals.hullPoints[fId].add(vec);
          break;
        }
      }
    }

    // -------------------------------------------------
    // 5️⃣ Queue the new facets for further processing
    // -------------------------------------------------
    for (final int fId in _Globals.resFNew) {
      _Globals.queue.add(fId);
    }
  }

  // The last facet that still holds a point becomes the new “starting” facet.
  hull.index = newHorizon;
  return hull;
}

// ---------------------------------------------------------------------
// Helper that prepares the static containers (exact copy of C++ `prepareConvexHulls`)
// ---------------------------------------------------------------------
void prepareConvexHulls() {
  // reserve index 0 (as the C++ code does)
  _Globals.hullPoints.add(<Vector>[]);
  _Globals.facets.add(Facet());

  // initialise the edge matrix (already allocated, just reset the fields)
  for (int i = 0; i < 2; ++i) {
    for (int j = 0; j < MAX_SIZE; ++j) {
      _Globals.edges[i][j] = Edge();
    }
  }
}

// ---------------------------------------------------------------------
// Example driver (exactly the same points as the C++ main)
// ---------------------------------------------------------------------
void main() {
  prepareConvexHulls();

  const int n = 4;
  // points[0] is a dummy placeholder – the original algorithm expects 1‑based indexing
  final List<Vector> points = List.filled(n + 1, Vector());

  points[1] = Vector(0, 0, 0, 1);
  points[2] = Vector(1, 0, 0, 2);
  points[3] = Vector(0, 1, 0, 3);
  points[4] = Vector(0, 0, 1, 4);

  final ConvexHulls3d hull = quickHull3D(points, n);
  // three decimal places, same as the C++ `cout << fixed << setprecision(3)`
  print(hull.getSurfaceArea().toStringAsFixed(3));
}
