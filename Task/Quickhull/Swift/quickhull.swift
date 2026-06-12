import Foundation

// ------------------------------------------------------------
// MARK: - Constants & helpers
// ------------------------------------------------------------
let MAX_SIZE = 2_500
let EPSILON = 1e-8

@inline(__always) func isGreaterThan(_ a: Double, _ b: Double) -> Bool {
    a - b > EPSILON
}
@inline(__always) func isEqual(_ a: Double, _ b: Double) -> Bool {
    abs(a - b) < EPSILON
}

// ------------------------------------------------------------
// MARK: - Basic geometry
// ------------------------------------------------------------
struct Vector {
    var x: Double
    var y: Double
    var z: Double
    var id: Int            // the original index of the point

    init(_ x: Double = 0, _ y: Double = 0, _ z: Double = 0, _ id: Int = 0) {
        self.x = x; self.y = y; self.z = z; self.id = id
    }

    func subtract(_ other: Vector) -> Vector {
        Vector(x - other.x, y - other.y, z - other.z)
    }
    func vectorProduct(_ other: Vector) -> Vector {
        Vector(
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x
        )
    }
    func scalarProduct(_ other: Vector) -> Double {
        x * other.x + y * other.y + z * other.z
    }
    func magnitude() -> Double {
        sqrt(x * x + y * y + z * z)
    }
    func equals(_ other: Vector) -> Bool {
        isEqual(x, other.x) && isEqual(y, other.y) && isEqual(z, other.z)
    }
}

struct Line {
    var u: Vector
    var v: Vector
    init(_ u: Vector, _ v: Vector) {
        self.u = u; self.v = v
    }
}

struct Plane {
    var u: Vector
    var v: Vector
    var w: Vector

    init(_ u: Vector = Vector(),
         _ v: Vector = Vector(),
         _ w: Vector = Vector()) {
        self.u = u; self.v = v; self.w = w
    }

    func normal() -> Vector {
        v.subtract(u).vectorProduct(w.subtract(u))
    }

    func vector(at i: Int) -> Vector {
        switch i {
        case 0: return u
        case 1: return v
        case 2: return w
        default: return Vector()
        }
    }
    func vectorID(at i: Int) -> Int {
        vector(at: i).id
    }
}

// ------------------------------------------------------------
// MARK: - Facet, Edge and global containers
// ------------------------------------------------------------
class Facet {
    var N: [Int]                // neighbour facet indices (always size 3)
    var id: Int
    var visitedTime: Int = 0
    var isDeleted: Bool = false
    var plane: Plane

    init(id: Int) {
        self.id = id
        self.N = [Int](repeating: 0, count: 3)
        self.plane = Plane()
    }

    init(id: Int, plane: Plane) {
        self.id = id
        self.N = [Int](repeating: 0, count: 3)
        self.plane = plane
    }

    init() {
        self.id = 0
        self.N = [Int](repeating: 0, count: 3)
        self.plane = Plane()
    }
}

struct Edge {
    var netID: Int = 0
    var faceID: Int = 0
}

// Global containers (mirroring the C++ version)
var facets: [Facet] = []
var hullPoints: [[Vector]] = []          // points that belong to each facet
var timeStep: Int = 0

var edges: [[Edge]] = Array(
    repeating: Array(repeating: Edge(), count: MAX_SIZE),
    count: 2
)

var visitTime: [Int] = Array(repeating: 0, count: MAX_SIZE)

var queue: [Int] = []
var resFNew: [Int] = []
var resFDel: [Int] = []
var resPt: [Vector] = []

// ------------------------------------------------------------
// MARK: - Distance / side tests
// ------------------------------------------------------------
func distancePointPlane(_ pt: Vector, _ plane: Plane) -> Double {
    let num = pt.subtract(plane.u).scalarProduct(plane.normal())
    let den = plane.normal().magnitude()
    return num / den
}
func distancePointLine(_ pt: Vector, _ line: Line) -> Double {
    let len = pt.subtract(line.u).magnitude()
    if len == 0 { return 0.0 }
    return line.v.subtract(line.u)
        .vectorProduct(pt.subtract(line.u))
        .magnitude() / line.v.subtract(line.u).magnitude()
}
func distancePointPoint(_ a: Vector, _ b: Vector) -> Double {
    a.subtract(b).magnitude()
}
func isAbove(_ point: Vector, _ plane: Plane) -> Bool {
    isGreaterThan(point.subtract(plane.u).scalarProduct(plane.normal()), 0.0)
}

// ------------------------------------------------------------
// MARK: - Convex hull object (the driver)
// ------------------------------------------------------------
final class ConvexHulls3D {
    var index: Int          // the “seed” facet for surface‑area computation
    private var surfaceArea: Double = 0.0

    init(index: Int) {
        self.index = index
    }

    // ----------------------------------------------------------------
    // public: surface area – cached after first computation
    // ----------------------------------------------------------------
    func getSurfaceArea() -> Double {
        if isGreaterThan(surfaceArea, 0.0) { return surfaceArea }

        timeStep += 1
        dfsArea(from: index)
        return surfaceArea
    }

    // ----------------------------------------------------------------
    // private: depth‑first search of the facet adjacency graph
    // ----------------------------------------------------------------
    private func dfsArea(from f: Int) {
        if facets[f].visitedTime == timeStep { return }

        facets[f].visitedTime = timeStep
        let normal = facets[f].plane.normal()
        surfaceArea += normal.magnitude() / 2.0

        for i in 0..<3 { dfsArea(from: facets[f].N[i]) }
    }

    // ----------------------------------------------------------------
    // Horizon discovery – returns the first horizon edge (or 0 / -1 / -2)
    // ----------------------------------------------------------------
    func getHorizon(_ f: Int, _ point: Vector, _ resDel: inout [Int]) -> Int {
        let facet = facets[f]
        if !isAbove(point, facet.plane) { return 0 }
        if facet.visitedTime == timeStep { return -1 }

        facet.visitedTime = timeStep
        facet.isDeleted = true
        resDel.append(facet.id)

        var result = -2

        for i in 0..<3 {
            let neigh = facet.N[i]
            let horizon = getHorizon(neigh, point, &resDel)

            if horizon == 0 {
                // edge (a,b) of facet f opposite vertex i
                let a = facet.plane.vectorID(at: i)
                let b = facet.plane.vectorID(at: (i + 1) % 3)

                for idx in 0..<2 {
                    let pt = (idx == 0) ? a : b
                    let fID = neigh
                    if visitTime[pt] != timeStep {
                        visitTime[pt] = timeStep
                        edges[0][pt].netID = (idx == 0) ? b : a
                        edges[0][pt].faceID = fID
                    } else {
                        edges[1][pt].netID = (idx == 0) ? b : a
                        edges[1][pt].faceID = fID
                    }
                }
                result = a
            } else if horizon != -1 && horizon != -2 {
                result = horizon
            }
        }
        return result
    }
}

// ------------------------------------------------------------
// MARK: - Preparations (allocate structures)
// ------------------------------------------------------------
func prepareConvexHulls() {
    // reserve index 0 – the dummy entry used by the C++ program
    hullPoints.append([])
    facets.append(Facet())

    // initialise edges matrix
    for i in 0..<2 {
        for j in 0..<MAX_SIZE {
            edges[i][j] = Edge()
        }
    }
}

// ------------------------------------------------------------
// MARK: - Build the initial tetrahedron
// ------------------------------------------------------------
func getInitialHull(_ points: [Vector], _ totalPoints: Int) -> ConvexHulls3D {
    // ---- 1. extreme points on each axis -----------------------------------------
    var extremes = Array(repeating: points[1], count: 6)

    for i in 1...totalPoints {
        let p = points[i]
        if isGreaterThan(p.x, extremes[0].x) { extremes[0] = p }
        if isGreaterThan(extremes[1].x, p.x) { extremes[1] = p }
        if isGreaterThan(p.y, extremes[2].y) { extremes[2] = p }
        if isGreaterThan(extremes[3].y, p.y) { extremes[3] = p }
        if isGreaterThan(p.z, extremes[4].z) { extremes[4] = p }
        if isGreaterThan(extremes[5].z, p.z) { extremes[5] = p }
    }

    // ---- 2. farthest pair -------------------------------------------------------
    var extreme0 = extremes[0]
    var extreme1 = extremes[1]

    for i in 0..<6 {
        for j in i+1..<6 {
            let d = distancePointPoint(extremes[i], extremes[j])
            if isGreaterThan(d, distancePointPoint(extreme0, extreme1)) {
                extreme0 = extremes[i]
                extreme1 = extremes[j]
            }
        }
    }

    // ---- 3. farthest from that line ---------------------------------------------
    let line = Line(extreme0, extreme1)
    var extreme2 = extremes[0]
    for i in 0..<6 {
        if isGreaterThan(distancePointLine(extremes[i], line),
                         distancePointLine(extreme2, line)) {
            extreme2 = extremes[i]
        }
    }

    // ---- 4. farthest from the plane formed by the three points ------------------
    var extreme3 = points[1]                // any point that is not a dummy
    let basePlane = Plane(extreme0, extreme1, extreme2)

    for i in 1...totalPoints {
        let d1 = abs(distancePointPlane(points[i], basePlane))
        let d2 = abs(distancePointPlane(extreme3, basePlane))
        if isGreaterThan(d1, d2) { extreme3 = points[i] }
    }

    // Ensure the orientation of the base plane is outward
    if isGreaterThan(0.0, distancePointPlane(extreme3, basePlane)) {
        swap(&extreme1, &extreme2)
    }

    // ---- 5. create the four seed facets -----------------------------------------
    var f = [Int](repeating: 0, count: 4)
    for i in 0..<4 {
        facets.append(Facet(id: facets.count))
        f[i] = facets.count - 1
    }

    facets[f[0]].plane = Plane(extreme0, extreme2, extreme1)
    facets[f[1]].plane = Plane(extreme0, extreme1, extreme3)
    facets[f[2]].plane = Plane(extreme1, extreme2, extreme3)
    facets[f[3]].plane = Plane(extreme2, extreme0, extreme3)

    facets[f[0]].N = [f[3], f[2], f[1]]
    facets[f[1]].N = [f[0], f[2], f[3]]
    facets[f[2]].N = [f[0], f[3], f[1]]
    facets[f[3]].N = [f[0], f[1], f[2]]

    // ---- 6. allocate a hull‑point list for each facet ---------------------------
    for _ in 0..<4 { hullPoints.append([]) }

    // ---- 7. distribute every remaining point to the facet that sees it ---------
    for i in 1...totalPoints {
        let p = points[i]
        if p.equals(extreme0) || p.equals(extreme1) ||
           p.equals(extreme2) || p.equals(extreme3) { continue }

        for j in 0..<4 {
            if isAbove(p, facets[f[j]].plane) {
                hullPoints[f[j]].append(p)
                break
            }
        }
    }

    return ConvexHulls3D(index: f[0])
}

// ------------------------------------------------------------
// MARK: - Main QuickHull driver
// ------------------------------------------------------------
func quickHull3D(_ points: [Vector], _ totalPoints: Int) -> ConvexHulls3D {
    var hull = getInitialHull(points, totalPoints)

    // initialise the processing queue
    queue.removeAll()
    queue.append(hull.index)
    for i in 0..<3 { queue.append(facets[hull.index].N[i]) }

    var newHorizon = 0

    while !queue.isEmpty {
        let nf = queue.removeFirst()
        if facets[nf].isDeleted || hullPoints[nf].isEmpty {
            if !facets[nf].isDeleted { newHorizon = nf }
            continue
        }

        // ----- farthest point of the current facet ------------------------------
        var farthest = hullPoints[nf][0]
        for v in hullPoints[nf] {
            if isGreaterThan(
                distancePointPlane(v, facets[nf].plane),
                distancePointPlane(farthest, facets[nf].plane)) {
                farthest = v
            }
        }

        // ----- horizon -----------------------------------------------------------
        timeStep += 1
        resFDel.removeAll()
        let horizon = hull.getHorizon(nf, farthest, &resFDel)

        // ----- build new facets --------------------------------------------------
        resFNew.removeAll()
        timeStep += 1

        var from = -1
        var lastF = -1
        var firstF = -1
        var curHorizon = horizon

        while visitTime[curHorizon] != timeStep {
            visitTime[curHorizon] = timeStep

            // decide which edge instance (0/1) belongs to the current direction
            let net: Int
            let fID: Int
            if edges[0][curHorizon].netID == from {
                net = edges[1][curHorizon].netID
                fID = edges[1][curHorizon].faceID
            } else {
                net = edges[0][curHorizon].netID
                fID = edges[0][curHorizon].faceID
            }

            // locate the two vertices of facet f that correspond to
            //   - curHorizon   (the “horizon” vertex)
            //   - net          (the neighbour vertex)
            var pt1 = 0
            var pt2 = 0
            for i in 0..<3 {
                if points[curHorizon].equals(facets[fID].plane.vector(at: i)) {
                    pt1 = i
                }
                if points[net].equals(facets[fID].plane.vector(at: i)) {
                    pt2 = i
                }
            }
            // make sure that (pt1,pt2) are ordered clockwise as in the C++ code
            if (pt1 + 1) % 3 != pt2 {
                swap(&pt1, &pt2)
            }

            // create the new facet
            let newPlane = Plane(
                facets[fID].plane.vector(at: pt2),
                facets[fID].plane.vector(at: pt1),
                farthest
            )
            facets.append(Facet(id: facets.count, plane: newPlane))
            let newF = facets.count - 1
            hullPoints.append([])            // allocate its point list
            resFNew.append(newF)

            // link the new facet with the old one
            facets[newF].N[0] = fID
            facets[fID].N[pt1] = newF

            if lastF >= 0 {
                // connect to the previous new facet (closing the fan)
                if facets[newF].plane.vector(at: 1).equals(facets[lastF].plane.u) {
                    facets[newF].N[1] = lastF
                    facets[lastF].N[2] = newF
                } else {
                    facets[newF].N[2] = lastF
                    facets[lastF].N[1] = newF
                }
            } else {
                firstF = newF
            }

            lastF = newF
            from = curHorizon
            curHorizon = net
        }

        // ----- close the fan ----------------------------------------------------
        if facets[firstF].plane.vector(at: 1).equals(facets[lastF].plane.u) {
            facets[firstF].N[1] = lastF
            facets[lastF].N[2] = firstF
        } else {
            facets[firstF].N[2] = lastF
            facets[lastF].N[1] = firstF
        }

        // ----- collect all points that were attached to deleted facets ----------
        resPt.removeAll()
        for fID in resFDel {
            resPt.append(contentsOf: hullPoints[fID])
            hullPoints[fID].removeAll()
        }

        // ----- re‑assign those points to the newly created facets ---------------
        for p in resPt where !p.equals(farthest) {
            for fID in resFNew {
                if isAbove(p, facets[fID].plane) {
                    hullPoints[fID].append(p)
                    break
                }
            }
        }

        // ----- enqueue newly created facets --------------------------------------
        for fID in resFNew { queue.append(fID) }
    }

    hull.index = newHorizon
    return hull
}

// ------------------------------------------------------------
// MARK: - Example / entry point
// ------------------------------------------------------------
func runExample() {
    prepareConvexHulls()

    // Example: a tetrahedron (the same data as the C++ main)
    let n = 4
    var points = [Vector](repeating: Vector(), count: n + 1)   // points[0] unused
    points[1] = Vector(0, 0, 0, 1)
    points[2] = Vector(1, 0, 0, 2)
    points[3] = Vector(0, 1, 0, 3)
    points[4] = Vector(0, 0, 1, 4)

    let hull = quickHull3D(points, n)
    let area = hull.getSurfaceArea()
    print(String(format: "%.3f", area))
}

// ------------------------------------------------------------
// MARK: - Run
// ------------------------------------------------------------
runExample()
