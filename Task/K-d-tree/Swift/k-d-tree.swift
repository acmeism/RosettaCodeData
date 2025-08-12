import Foundation

// point is a k-dimensional point.
typealias Point = [Double]

extension Point {
    // sqd returns the square of the euclidean distance.
    func sqd(to q: Point) -> Double {
        var sum: Double = 0
        for dim in 0..<self.count {
            let d = self[dim] - q[dim]
            sum += d * d
        }
        return sum
    }
}

// kdNode following field names in the paper.
// rangeElt would be whatever data is associated with the point.
class KDNode {
    let domElt: Point
    let split: Int
    let left: KDNode?
    let right: KDNode?

    init(domElt: Point, split: Int, left: KDNode?, right: KDNode?) {
        self.domElt = domElt
        self.split = split
        self.left = left
        self.right = right
    }
}

struct HyperRect {
    var min: Point
    var max: Point

    // Create a copy of the hyperrect
    func copy() -> HyperRect {
        return HyperRect(min: Array(self.min), max: Array(self.max))
    }
}

class KDTree {
    let root: KDNode?
    let bounds: HyperRect

    init(root: KDNode?, bounds: HyperRect) {
        self.root = root
        self.bounds = bounds
    }

    // nearest. find nearest neighbor. return values are:
    // nearest neighbor - the point within the tree that is nearest p.
    // square of the distance to that point.
    // a count of the nodes visited in the search.
    func nearest(to target: Point) -> (nearest: Point?, distSqd: Double, nodesVisited: Int) {
        return nn(kd: root, target: target, hr: bounds, maxDistSqd: .infinity)
    }

    // algorithm is table 6.4 from the paper
    private func nn(kd: KDNode?, target: Point, hr: HyperRect,
                   maxDistSqd: Double) -> (nearest: Point?, distSqd: Double, nodesVisited: Int) {
        if kd == nil {
            return (nil, .infinity, 0)
        }

        var nodesVisited = 1
        let s = kd!.split
        let pivot = kd!.domElt
        var leftHr = hr.copy()
        var rightHr = hr.copy()
        leftHr.max[s] = pivot[s]
        rightHr.min[s] = pivot[s]
        let targetInLeft = target[s] <= pivot[s]

        let (nearerKd, nearerHr, furtherKd, furtherHr): (KDNode?, HyperRect, KDNode?, HyperRect)
        if targetInLeft {
            nearerKd = kd!.left
            nearerHr = leftHr
            furtherKd = kd!.right
            furtherHr = rightHr
        } else {
            nearerKd = kd!.right
            nearerHr = rightHr
            furtherKd = kd!.left
            furtherHr = leftHr
        }

        var (nearest, distSqd, nv) = nn(kd: nearerKd, target: target, hr: nearerHr, maxDistSqd: maxDistSqd)
        nodesVisited += nv

        var maxDist = maxDistSqd
        if distSqd < maxDist {
            maxDist = distSqd
        }

        var d = pivot[s] - target[s]
        d *= d
        if d > maxDist {
            return (nearest, distSqd, nodesVisited)
        }

        d = pivot.sqd(to: target)
        if d < distSqd {
            nearest = pivot
            distSqd = d
            maxDist = distSqd
        }

        let (tempNearest, tempSqd, nv2) = nn(kd: furtherKd, target: target, hr: furtherHr, maxDistSqd: maxDist)
        nodesVisited += nv2

        if tempSqd < distSqd {
            nearest = tempNearest
            distSqd = tempSqd
        }

        return (nearest, distSqd, nodesVisited)
    }
}

// Helper function to create a new KD tree
func newKd(pts: [Point], bounds: HyperRect) -> KDTree {
    func nk2(exset: [Point], split: Int) -> KDNode? {
        if exset.isEmpty {
            return nil
        }

        // Sort points by the split dimension
        let sortedPoints = exset.sorted { $0[split] < $1[split] }
        var m = sortedPoints.count / 2
        let d = sortedPoints[m]

        // Find largest index of points with median value
        while m+1 < sortedPoints.count && sortedPoints[m+1][split] == d[split] {
            m += 1
        }

        // Next split
        var s2 = split + 1
        if s2 == d.count {
            s2 = 0
        }

        return KDNode(
            domElt: d,
            split: split,
            left: nk2(exset: Array(sortedPoints[0..<m]), split: s2),
            right: nk2(exset: Array(sortedPoints[(m+1)...]), split: s2)
        )
    }

    return KDTree(root: nk2(exset: pts, split: 0), bounds: bounds)
}

// Helper functions to generate random points
func randomPt(dim: Int) -> Point {
    var p = Point(repeating: 0, count: dim)
    for d in 0..<dim {
        p[d] = Double.random(in: 0...1)
    }
    return p
}

func randomPts(dim: Int, n: Int) -> [Point] {
    var p = [Point](repeating: [], count: n)
    for i in 0..<n {
        p[i] = randomPt(dim: dim)
    }
    return p
}

func showNearest(heading: String, kd: KDTree, p: Point) {
    print()
    print(heading)
    print("point:           ", p)
    let (nn, ssq, nv) = kd.nearest(to: p)
    print("nearest neighbor:", nn ?? "nil")
    print("distance:        ", sqrt(ssq))
    print("nodes visited:   ", nv)
}

// Main function
func main() {
    // Set random seed
    srand48(Int(time(nil)))

    var kd = newKd(
        pts: [[2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2]],
        bounds: HyperRect(min: [0, 0], max: [10, 10])
    )
    showNearest(heading: "WP example data", kd: kd, p: [9, 2])

    kd = newKd(
        pts: randomPts(dim: 3, n: 1000),
        bounds: HyperRect(min: [0, 0, 0], max: [1, 1, 1])
    )
    showNearest(heading: "1000 random 3d points", kd: kd, p: randomPt(dim: 3))
}

// Run the main function
main()
