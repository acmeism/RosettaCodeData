import 'dart:math';

// Define Point as a list of doubles
typedef Point = List<double>;

// Extension method for calculating squared distance
extension PointExtension on Point {
  double sqd(Point p) {
    if (length != p.length) {
      throw ArgumentError('Points must have the same dimension');
    }
    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      double diff = this[i] - p[i];
      sum += diff * diff;
    }
    return sum;
  }
}

class HyperRect {
  final Point min;
  final Point max;

  HyperRect(this.min, this.max);

  // Create a copy with new lists for min and max
  HyperRect copy() => HyperRect(List.from(min), List.from(max));
}

class NearestNeighbor {
  final Point? nearest; // Nullable Point
  final double distSqd;
  final int nodesVisited;

  NearestNeighbor(this.nearest, this.distSqd, this.nodesVisited);
}

class KdNode {
  final Point domElt;
  final int split;
  KdNode? left; // Nullable and mutable
  KdNode? right; // Nullable and mutable

  KdNode(this.domElt, this.split, this.left, this.right);
}

class KdTree {
  final KdNode? n; // Root node (nullable)
  final HyperRect bounds;

  // Constructor builds the tree
  KdTree(List<Point> pts, this.bounds)
    : n = _buildTree(
        List.from(pts),
        0,
      ); // Pass a copy to avoid modifying original

  // Static helper method for recursive tree building (like nk2)
  static KdNode? _buildTree(List<Point> exset, int split) {
    if (exset.isEmpty) {
      return null;
    }

    // Sort the list in-place based on the current split dimension
    exset.sort((a, b) => a[split].compareTo(b[split]));

    int m = exset.length ~/ 2; // Integer division
    final Point d = exset[m];

    // Handle duplicate points at the median split value
    // Find the last index of the element equal to the median along the split dimension
    while (m + 1 < exset.length && exset[m + 1][split] == d[split]) {
      m++;
    }

    int s2 = split + 1;
    if (s2 == d.length) {
      s2 = 0; // Cycle through dimensions
    }

    // Dart's sublist creates copies, which is suitable here
    List<Point> leftSublist = exset.sublist(0, m);
    List<Point> rightSublist = exset.sublist(m + 1);

    return KdNode(
      d,
      split,
      _buildTree(leftSublist, s2),
      _buildTree(rightSublist, s2),
    );
  }

  // Public method to find the nearest neighbor
  NearestNeighbor nearest(Point p) {
    // Pass a copy of bounds because _nn might modify its HyperRect parameter
    return _nn(n, p, bounds.copy(), double.infinity);
  }

  // Private recursive helper for nearest neighbor search
  NearestNeighbor _nn(
    KdNode? kd, // Current node (nullable)
    Point target, // Target point
    HyperRect hr, // Hyper-rectangle for the current node's space
    double maxDistSqd, // Current best squared distance found so far
  ) {
    if (kd == null) {
      return NearestNeighbor(null, double.infinity, 0);
    }

    int nodesVisited = 1;
    final int s = kd.split;
    final Point pivot = kd.domElt;

    // Create copies for left and right potential subspaces
    final HyperRect leftHr = hr.copy();
    final HyperRect rightHr = hr.copy();

    // Adjust bounds for children
    leftHr.max[s] = pivot[s];
    rightHr.min[s] = pivot[s];

    // Determine which branch is nearer
    final bool targetInLeft = target[s] <= pivot[s];
    final KdNode? nearerKd = targetInLeft ? kd.left : kd.right;
    final HyperRect nearerHr = targetInLeft ? leftHr : rightHr;
    final KdNode? furtherKd = targetInLeft ? kd.right : kd.left;
    final HyperRect furtherHr = targetInLeft ? rightHr : leftHr;

    // Recurse down the nearer branch
    NearestNeighbor nearerResult = _nn(nearerKd, target, nearerHr, maxDistSqd);
    Point? nearest = nearerResult.nearest;
    double distSqd = nearerResult.distSqd;
    nodesVisited += nearerResult.nodesVisited;

    // Update the maximum distance squared if a closer point was found
    double maxDistSqd2 = (distSqd < maxDistSqd) ? distSqd : maxDistSqd;

    // Check the distance from the target to the splitting plane
    double d = pivot[s] - target[s];
    d *= d;

    // If the splitting plane is further than the current nearest, no need to check further branch
    if (d > maxDistSqd2) {
      return NearestNeighbor(nearest, distSqd, nodesVisited);
    }

    // Check distance from target to the pivot point itself
    d = pivot.sqd(target); // Use extension method
    if (d < distSqd) {
      nearest = pivot;
      distSqd = d;
      maxDistSqd2 = distSqd; // Update max distance again
    }

    // Recurse down the further branch if necessary
    NearestNeighbor furtherResult = _nn(
      furtherKd,
      target,
      furtherHr,
      maxDistSqd2,
    );
    nodesVisited += furtherResult.nodesVisited;

    // If the further branch found an even closer point
    if (furtherResult.distSqd < distSqd) {
      nearest = furtherResult.nearest;
      distSqd = furtherResult.distSqd;
    }

    return NearestNeighbor(nearest, distSqd, nodesVisited);
  }
}

// --- Helper Functions and Main ---

final rand = Random();

Point randomPt(int dim) => List.generate(dim, (_) => rand.nextDouble());

List<Point> randomPts(int dim, int n) => List.generate(n, (_) => randomPt(dim));

void showNearest(String heading, KdTree kd, Point p) {
  print('$heading:');
  print('Point            : $p'); // Default List.toString() is fine
  final result = kd.nearest(p);
  print('Nearest neighbor : ${result.nearest}');
  print(
    'Distance         : ${sqrt(result.distSqd)}',
  ); // Use sqrt from dart:math
  print('Nodes visited    : ${result.nodesVisited}');
  print(''); // Empty line
}

void main() {
  // Note: Using List<Point> instead of MutableList
  final points = <Point>[
    [2.0, 3.0],
    [5.0, 4.0],
    [9.0, 6.0],
    [4.0, 7.0],
    [8.0, 1.0],
    [7.0, 2.0],
  ];

  var hr = HyperRect([0.0, 0.0], [10.0, 10.0]);
  var kd = KdTree(points, hr); // Pass the original list
  showNearest('WP example data', kd, [9.0, 2.0]);

  hr = HyperRect([0.0, 0.0, 0.0], [1.0, 1.0, 1.0]);
  // Generate random points directly as List<Point>
  kd = KdTree(randomPts(3, 1000), hr);
  showNearest('1000 random 3D points', kd, randomPt(3));

  // Use hr.copy() if you intend to modify hr later, otherwise it's not strictly needed
  // The Kotlin code uses copy, so we replicate it here.
  var hrCopy = hr.copy();
  kd = KdTree(randomPts(3, 400000), hrCopy); // Pass the copy
  showNearest('400,000 random 3D points', kd, randomPt(3));
}
