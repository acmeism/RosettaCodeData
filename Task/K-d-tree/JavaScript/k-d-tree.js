/**
 * Class for representing a point. coordinate_type must be a numeric type.
 */
class Point {
  constructor(coords) {
    if (Array.isArray(coords)) {
      this.coords = [...coords];
    } else if (coords instanceof Object) {
      this.coords = Array.from(coords);
    }
  }

  /**
   * Returns the coordinate in the given dimension.
   *
   * @param {number} index dimension index (zero based)
   * @return {number} coordinate in the given dimension
   */
  get(index) {
    return this.coords[index];
  }

  /**
   * Returns the distance squared from this point to another point.
   *
   * @param {Point} pt another point
   * @return {number} distance squared from this point to the other point
   */
  distance(pt) {
    let dist = 0;
    for (let i = 0; i < this.coords.length; ++i) {
      const d = this.get(i) - pt.get(i);
      dist += d * d;
    }
    return dist;
  }

  toString() {
    return `(${this.coords.join(', ')})`;
  }
}

/**
 * JavaScript k-d tree implementation, based on the C++ version.
 */
class KDTree {
  constructor(pointsOrGenerator, count) {
    this.nodes = [];
    this.dimensions = 0;
    this.root = null;
    this.best = null;
    this.bestDist = 0;
    this.visited = 0;

    if (typeof pointsOrGenerator === 'function' && typeof count === 'number') {
      // Constructor with generator function
      for (let i = 0; i < count; ++i) {
        const point = pointsOrGenerator();
        if (i === 0) {
          this.dimensions = point.coords.length;
        }
        this.nodes.push({ point, left: null, right: null });
      }
    } else if (Array.isArray(pointsOrGenerator)) {
      // Constructor with array of points
      this.nodes = pointsOrGenerator.map(point => ({ point, left: null, right: null }));
      if (this.nodes.length > 0) {
        this.dimensions = this.nodes[0].point.coords.length;
      }
    }

    if (this.nodes.length > 0) {
      this.root = this.makeTree(0, this.nodes.length, 0);
    }
  }

  /**
   * Comparison function for sorting nodes by a specific dimension
   */
  nodeCmp(a, b, index) {
    return a.point.get(index) - b.point.get(index);
  }

  /**
   * Builds the tree recursively
   */
  makeTree(begin, end, index) {
    if (end <= begin) return null;

    const n = begin + Math.floor((end - begin) / 2);

    // Sort and find median
    this.nodes.slice(begin, end).sort((a, b) => this.nodeCmp(a, b, index));

    // Update index for the next level
    const nextIndex = (index + 1) % this.dimensions;

    // Recursively build left and right subtrees
    this.nodes[n].left = this.makeTree(begin, n, nextIndex);
    this.nodes[n].right = this.makeTree(n + 1, end, nextIndex);

    return this.nodes[n];
  }

  /**
   * Recursively finds the nearest node to the given point
   */
  findNearest(root, point, index) {
    if (!root) return;

    this.visited++;
    const d = root.point.distance(point);

    if (!this.best || d < this.bestDist) {
      this.bestDist = d;
      this.best = root;
    }

    if (this.bestDist === 0) return;

    const dx = root.point.get(index) - point.get(index);
    const nextIndex = (index + 1) % this.dimensions;

    // Search the side of the splitting plane that contains the point
    this.findNearest(dx > 0 ? root.left : root.right, point, nextIndex);

    // If the distance to the splitting plane is less than current best distance,
    // we need to check the other side too
    if (dx * dx >= this.bestDist) return;

    this.findNearest(dx > 0 ? root.right : root.left, point, nextIndex);
  }

  /**
   * Returns true if the tree is empty, false otherwise.
   */
  empty() {
    return this.nodes.length === 0;
  }

  /**
   * Returns the number of nodes visited by the last call to nearest().
   */
  getVisited() {
    return this.visited;
  }

  /**
   * Returns the distance between the input point and return value
   * from the last call to nearest().
   */
  getDistance() {
    return Math.sqrt(this.bestDist);
  }

  /**
   * Finds the nearest point in the tree to the given point.
   * It is not valid to call this function if the tree is empty.
   *
   * @param {Point} point a point
   * @return {Point} the nearest point in the tree to the given point
   */
  nearest(point) {
    if (!this.root) {
      throw new Error("Tree is empty");
    }

    this.best = null;
    this.visited = 0;
    this.bestDist = 0;

    this.findNearest(this.root, point, 0);

    return this.best.point;
  }
}

/**
 * Recreates the Wikipedia example from the original code
 */
function testWikipedia() {
  const points = [
    new Point([2, 3]),
    new Point([5, 4]),
    new Point([9, 6]),
    new Point([4, 7]),
    new Point([8, 1]),
    new Point([7, 2])
  ];

  const tree = new KDTree(points);
  const searchPoint = new Point([9, 2]);
  const nearest = tree.nearest(searchPoint);

  console.log("Wikipedia example data:");
  console.log("nearest point:", nearest.toString());
  console.log("distance:", tree.getDistance());
  console.log("nodes visited:", tree.getVisited());
}

/**
 * Generates random points and finds the nearest neighbor
 */
function randomPointGenerator(min, max) {
  return () => {
    const x = min + Math.random() * (max - min);
    const y = min + Math.random() * (max - min);
    const z = min + Math.random() * (max - min);
    return new Point([x, y, z]);
  };
}

function testRandom(count) {
  const rpg = randomPointGenerator(0, 1);
  const tree = new KDTree(rpg, count);
  const point = rpg();
  const nearest = tree.nearest(point);

  console.log(`Random data (${count} points):`);
  console.log("point:", point.toString());
  console.log("nearest point:", nearest.toString());
  console.log("distance:", tree.getDistance());
  console.log("nodes visited:", tree.getVisited());
}

// Main execution
try {
  testWikipedia();
  console.log();
  testRandom(1000);
  console.log();
  testRandom(10000); // Using 10,000 instead of 1,000,000 for browser performance
} catch (e) {
  console.error(e.message);
}
