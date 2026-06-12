class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

class Projection {
  constructor(min, max) {
    this.min = min;
    this.max = max;
  }

  overlaps(other) {
    return !(this.max < other.min || other.max < this.min);
  }
}

class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  scalarProduct(other) {
    return this.x * other.x + this.y * other.y;
  }

  edgeWith(other) {
    return new Vector(this.x - other.x, this.y - other.y);
  }

  perpendicular() {
    return new Vector(-this.y, this.x);
  }

  toString() {
    return `(${this.x}, ${this.y}) `;
  }
}

class Polygon {
  constructor(points) {
    this.vertices = [];
    this.axes = [];
    this.computeVertices(points);
    this.computeAxes();
  }

  overlaps(other) {
    const allAxes = [...this.axes, ...other.axes];

    for (const axis of allAxes) {
      const projection1 = this.projectionOnAxis(axis);
      const projection2 = other.projectionOnAxis(axis);
      if (!projection1.overlaps(projection2)) {
        return false;
      }
    }

    return true;
  }

  projectionOnAxis(axis) {
    let min = Infinity;
    let max = -Infinity;

    for (const vertex of this.vertices) {
      const p = axis.scalarProduct(vertex);
      if (p < min) {
        min = p;
      }
      if (p > max) {
        max = p;
      }
    }

    return new Projection(min, max);
  }

  toString() {
    let result = "[ ";
    for (const vertex of this.vertices) {
      result += vertex.toString();
    }
    result += "]";
    return result;
  }

  computeVertices(points) {
    for (const point of points) {
      this.vertices.push(new Vector(point.x, point.y));
    }
  }

  computeAxes() {
    for (let i = 0; i < this.vertices.length; i++) {
      const vertex1 = this.vertices[i];
      const vertex2 = this.vertices[(i + 1) % this.vertices.length];
      const edge = vertex1.edgeWith(vertex2);
      this.axes.push(edge.perpendicular());
    }
  }
}

class Rectangle {
  constructor(x, y, width, height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

function rectangleToPolygon(rectangle) {
  return new Polygon([
    new Point(rectangle.x, rectangle.y),
    new Point(rectangle.x + rectangle.width, rectangle.y),
    new Point(rectangle.x + rectangle.width, rectangle.y + rectangle.height),
    new Point(rectangle.x, rectangle.y + rectangle.height)
  ]);
}

function main() {
  const polygon = new Polygon([
    new Point(0.0, 0.0),
    new Point(0.0, 2.0),
    new Point(1.0, 4.0),
    new Point(2.0, 2.0),
    new Point(2.0, 0.0)
  ]);

  const rectangle1 = new Rectangle(4.0, 0.0, 2.0, 2.0);
  const rectangle2 = new Rectangle(1.0, 0.0, 8.0, 2.0);

  const polygon1 = rectangleToPolygon(rectangle1);
  const polygon2 = rectangleToPolygon(rectangle2);

  console.log("polygon:", polygon.toString());
  console.log("rectangle1:", polygon1.toString());
  console.log("rectangle2:", polygon2.toString());
  console.log();
  console.log("polygon and polygon1 overlap?", polygon.overlaps(polygon1));
  console.log("polygon and polygon2 overlap?", polygon.overlaps(polygon2));
}

main();
