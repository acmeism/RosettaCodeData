// A point of the current Catmull-Clark surface.
class Point {
  constructor(x = 0.0, y = 0.0, z = 0.0) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  add(other) {
    return new Point(this.x + other.x, this.y + other.y, this.z + other.z);
  }

  multiply(factor) {
    return new Point(this.x * factor, this.y * factor, this.z * factor);
  }

  divide(factor) {
    return this.multiply(1.0 / factor);
  }

  lessThan(other) {
    return (this.x < other.x) ||
           (this.x === other.x && this.y < other.y) ||
           (this.x === other.x && this.y === other.y && this.z < other.z);
  }

  equals(other) {
    return this.x === other.x && this.y === other.y && this.z === other.z;
  }

  format(value) {
    const formattedValue = value.toFixed(3);
    return (value >= 0) ? " " + formattedValue : formattedValue;
  }

  toString() {
    return "(" + this.format(this.x) + ", " + this.format(this.y) + ", " + this.format(this.z) + ")";
  }
}

// Return the centroid point of the given array of points.
function centroid(points) {
  let sum = new Point();
  for (const point of points) {
    sum = sum.add(point);
  }
  return sum.divide(points.length);
}

// An edge of the current Catmull-Clark surface.
class Edge {
  constructor(aBegin, aEnd) {
    if (aEnd.lessThan(aBegin)) {
      [aBegin, aEnd] = [aEnd, aBegin];
    }
    this.begin = aBegin;
    this.end = aEnd;
    this.mid_edge = centroid([this.begin, this.end]);
    this.hole_edge = false;
  }

  contains(point) {
    return point.equals(this.begin) || point.equals(this.end);
  }

  lessThan(other) {
    return this.begin.lessThan(other.begin) ||
           (this.begin.equals(other.begin) && this.end.lessThan(other.end));
  }

  equals(other) {
    return this.contains(other.begin) && this.contains(other.end);
  }
}

// A face of the current Catmull-Clark surface.
class Face {
  constructor(aVertices) {
    this.vertices = aVertices;
    this.face_point = centroid(this.vertices);
    this.edges = [];

    for (let i = 0; i < this.vertices.length - 1; ++i) {
      this.edges.push(new Edge(this.vertices[i], this.vertices[i + 1]));
    }
    this.edges.push(new Edge(this.vertices[this.vertices.length - 1], this.vertices[0]));
  }

  contains(vertex) {
    if (vertex instanceof Point) {
      return this.vertices.some(v => v.equals(vertex));
    } else if (vertex instanceof Edge) {
      return this.contains(vertex.begin) && this.contains(vertex.end);
    }
    return false;
  }

  toString() {
    let result = "Face: ";
    for (let i = 0; i < this.vertices.length - 1; ++i) {
      result += this.vertices[i].toString() + ", ";
    }
    return result + this.vertices[this.vertices.length - 1].toString();
  }
}

// Return a map containing, for each vertex,
// the new vertex created by the current iteration of the Catmull-Clark surface subdivision algorithm.
function next_vertices(edges, faces) {
  const next_vertices_map = new Map();
  const vertices = new Set();

  // Collect all unique vertices
  for (const face of faces) {
    for (const vertex of face.vertices) {
      vertices.add(vertex);
    }
  }

  // Convert Set to Array for iteration
  const verticesArray = Array.from(vertices);

  for (const vertex of verticesArray) {
    const faces_for_vertex = faces.filter(face => face.contains(vertex));
    const edges_for_vertex = edges.filter(edge => edge.contains(vertex));

    if (faces_for_vertex.length !== edges_for_vertex.length) {
      const mid_edge_of_hole_edges = edges_for_vertex
        .filter(edge => edge.hole_edge)
        .map(edge => edge.mid_edge);

      mid_edge_of_hole_edges.push(vertex);
      next_vertices_map.set(vertex, centroid(mid_edge_of_hole_edges));
    } else {
      const face_count = faces_for_vertex.length;
      const multiple_1 = (face_count - 3) / face_count;
      const multiple_2 = 1.0 / face_count;
      const multiple_3 = 2.0 / face_count;

      const next_vertex_1 = vertex.multiply(multiple_1);
      const face_points = faces_for_vertex.map(face => face.face_point);
      const next_vertex_2 = centroid(face_points).multiply(multiple_2);
      const mid_edges = edges_for_vertex.map(edge => edge.mid_edge);
      const next_vertex_3 = centroid(mid_edges).multiply(multiple_3);
      const next_vertex_4 = next_vertex_1.add(next_vertex_2);

      next_vertices_map.set(vertex, next_vertex_4.add(next_vertex_3));
    }
  }

  return next_vertices_map;
}

// The Catmull-Clarke surface subdivision algorithm.
function catmull_clark_surface_subdivision(faces) {
  // Determine, for each edge, whether or not it is an edge of a hole,
  // and set its edge point accordingly.
  for (const face of faces) {
    for (const edge of face.edges) {
      const face_points_for_edge = [];
      for (const search_face of faces) {
        if (search_face.contains(edge)) {
          face_points_for_edge.push(search_face.face_point);
        }
      }

      if (face_points_for_edge.length === 2) {
        edge.hole_edge = false;
        edge.edge_point = centroid([edge.mid_edge, centroid(face_points_for_edge)]);
      } else {
        edge.hole_edge = true;
        edge.edge_point = edge.mid_edge;
      }
    }
  }

  // Collect all edges
  const edges = [];
  for (const face of faces) {
    for (const edge of face.edges) {
      edges.push(edge);
    }
  }

  const next_vertex_map = next_vertices(edges, faces);
  const next_faces = [];

  for (const face of faces) {
    if (face.vertices.length >= 3) { // A face with 2 or fewer points does not contribute to the surface
      const face_point = face.face_point;
      for (let i = 0; i < face.vertices.length; ++i) {
        const prevIndex = (i - 1 + face.vertices.length) % face.vertices.length;
        next_faces.push(new Face([
          next_vertex_map.get(face.vertices[i]),
          face.edges[i].edge_point,
          face_point,
          face.edges[prevIndex].edge_point
        ]));
      }
    }
  }

  return next_faces;
}

// Display the current Catmull-Clark surface on the console.
function displaySurface(faces) {
  console.log("Surface {");
  for (const face of faces) {
    console.log(face.toString());
  }
  console.log("}");
  console.log();
}

// Main function
function main() {
  const faces = [
    new Face([
      new Point(-1.0, 1.0, 1.0), new Point(-1.0, -1.0, 1.0),
      new Point(1.0, -1.0, 1.0), new Point(1.0, 1.0, 1.0)
    ]),
    new Face([
      new Point(1.0, 1.0, 1.0), new Point(1.0, -1.0, 1.0),
      new Point(1.0, -1.0, -1.0), new Point(1.0, 1.0, -1.0)
    ]),
    new Face([
      new Point(1.0, 1.0, -1.0), new Point(1.0, -1.0, -1.0),
      new Point(-1.0, -1.0, -1.0), new Point(-1.0, 1.0, -1.0)
    ]),
    new Face([
      new Point(-1.0, 1.0, -1.0), new Point(-1.0, 1.0, 1.0),
      new Point(1.0, 1.0, 1.0), new Point(1.0, 1.0, -1.0)
    ]),
    new Face([
      new Point(-1.0, 1.0, -1.0), new Point(-1.0, -1.0, -1.0),
      new Point(-1.0, -1.0, 1.0), new Point(-1.0, 1.0, 1.0)
    ]),
    new Face([
      new Point(-1.0, -1.0, -1.0), new Point(-1.0, -1.0, 1.0),
      new Point(1.0, -1.0, 1.0), new Point(1.0, -1.0, -1.0)
    ])
  ];

  displaySurface(faces);
  const iterations = 1;
  let result = faces;
  for (let i = 0; i < iterations; ++i) {
    result = catmull_clark_surface_subdivision(result);
  }
  displaySurface(result);
}

// Run the main function
main();
