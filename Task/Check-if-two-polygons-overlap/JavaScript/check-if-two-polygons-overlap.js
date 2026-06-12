class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
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

class Projection {
    constructor(min, max) {
        this.min = min;
        this.max = max;
    }

    overlaps(other) {
        return !(this.max < other.min || other.max < this.min);
    }
}

class Polygon {
    constructor(points) {
        this.vertices = points.map(point => new Vector(point.x, point.y));
        this.axes = [];
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

    computeAxes() {
        this.axes = [];
        for (let i = 0; i < this.vertices.length; i++) {
            const vertex1 = this.vertices[i];
            const vertex2 = this.vertices[(i + 1) % this.vertices.length];
            const edge = vertex1.edgeWith(vertex2);
            this.axes.push(edge.perpendicular());
        }
    }

    toString() {
        let result = "[ ";
        for (const vertex of this.vertices) {
            result += vertex.toString();
        }
        result += "]";
        return result;
    }
}

// Example usage
const polygon1 = new Polygon([
    new Point(0.0, 0.0),
    new Point(0.0, 2.0),
    new Point(1.0, 4.0),
    new Point(2.0, 2.0),
    new Point(2.0, 0.0)
]);

const polygon2 = new Polygon([
    new Point(4.0, 0.0),
    new Point(4.0, 2.0),
    new Point(5.0, 4.0),
    new Point(6.0, 2.0),
    new Point(6.0, 0.0)
]);

const polygon3 = new Polygon([
    new Point(1.0, 0.0),
    new Point(1.0, 2.0),
    new Point(5.0, 4.0),
    new Point(9.0, 2.0),
    new Point(9.0, 0.0)
]);

console.log("polygon1 = " + polygon1);
console.log("polygon2 = " + polygon2);
console.log("polygon3 = " + polygon3);
console.log();

console.log("polygon1 and polygon2 overlap? " + polygon1.overlaps(polygon2));
console.log("polygon1 and polygon3 overlap? " + polygon1.overlaps(polygon3));
console.log("polygon2 and polygon3 overlap? " + polygon2.overlaps(polygon3));

