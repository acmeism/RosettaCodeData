// Point class
class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
}

// Circle class
class Circle {
    constructor(centre, radius) {
        this.centre = centre;
        this.radius = radius;
    }
}

// Main function to test the algorithm
function main() {
    const tests = [
        [new Point(0.0, 0.0), new Point(0.0, 1.0), new Point(1.0, 0.0)],
        [new Point(5.0, -2.0), new Point(-3.0, -2.0), new Point(-2.0, 5.0),
         new Point(1.0, 6.0), new Point(0.0, 2.0)],
        [new Point(0.0, 0.0), new Point(-2.0, -1.0), new Point(3.0, -4.0), new Point(2.0, 8.0),
         new Point(3.0, 11.0), new Point(-8.0, -2.0), new Point(-14.0, -6.0),
         new Point(7.0, 3.0), new Point(10.0, 4.0), new Point(-1.0, 4.0)]
    ];

    tests.forEach(test => {
        const circle = welzlAlgorithm(test);
        console.log(`Centre: (${circle.centre.x}, ${circle.centre.y}), Radius: ${circle.radius}`);
    });
}

// Return the smallest enclosing circle using Welzl's algorithm
function welzlAlgorithm(points) {
    const pointsCopy = [...points];
    shuffle(pointsCopy);
    return welzlAlgorithmRecursive(pointsCopy, []);
}

function welzlAlgorithmRecursive(aPoints, aBoundary) {
    const points = [...aPoints];
    const boundary = [...aBoundary];

    // Base case occurs when all the points have been processed
    // or the smallest enclosing circle boundary is specified by three points
    if (points.length === 0 || boundary.length === 3) {
        return circleFromListPoints(boundary);
    }

    // Choose a random point from the given 'points', since 'points' has already been shuffled
    const point = points.pop();

    // Recurse with the chosen point removed
    const candidate = welzlAlgorithmRecursive(points, boundary);

    if (encloses(point, candidate)) {
        return candidate;
    }

    // Otherwise, 'point' must be on the boundary of the smallest enclosing circle
    boundary.push(point);

    // Recurse with the chosen point removed from 'points' and added to the 'boundary'
    return welzlAlgorithmRecursive(points, boundary);
}

function circleFromListPoints(points) {
    switch (points.length) {
        case 0:
            return new Circle(new Point(0.0, 0.0), 0.0);
        case 1:
            return new Circle(points[0], 0.0);
        case 2:
            return circleFromTwoPoints(points[0], points[1]);
        case 3:
            return circleFromThreePoints(points[0], points[1], points[2]);
        default:
            throw new Error(`There should be three or fewer points: ${points.length}`);
    }
}

function circleFromThreePoints(a, b, c) {
    const ba = new Point(b.x - a.x, b.y - a.y);
    const ca = new Point(c.x - a.x, c.y - a.y);
    const bb = ba.x * ba.x + ba.y * ba.y;
    const cc = ca.x * ca.x + ca.y * ca.y;
    const dd = (ba.x * ca.y - ba.y * ca.x) * 2.0;
    const centreX = (ca.y * bb - ba.y * cc) / dd + a.x;
    const centreY = (ba.x * cc - ca.x * bb) / dd + a.y;
    const centre = new Point(centreX, centreY);
    return new Circle(centre, distance(a, centre));
}

function circleFromTwoPoints(a, b) {
    return new Circle(new Point((a.x + b.x) / 2.0, (a.y + b.y) / 2.0), distance(a, b) / 2.0);
}

function encloses(point, circle) {
    return distance(point, circle.centre) <= circle.radius;
}

function distance(a, b) {
    return Math.hypot(a.x - b.x, a.y - b.y);
}

// Utility function to shuffle array
function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

// Run the main function
main();
