var points = [];
var hull = [];

function setup() {
    createCanvas(1132, 700);
    frameRate(10);

    strokeWeight(4);
    stroke(220);
}

function draw() {
    background(40);
    // draw points
    for (i = 0; i < points.length; i++) {
        point(points[i].x, points[i].y);
    };
    console.log(hull);
    // draw hull
    noFill();
    beginShape();
    for (i = 0; i < hull.length; i++) {
        vertex(hull[i].x, hull[i].y);
    };
    endShape(CLOSE);
}

function mouseClicked() {
    points.push(createVector(mouseX, mouseY));
    hull = convexHull(points);
    noFill();
    //console.log(hull);
    beginShape();
    for (var i = 0; i < hull.length; i++) {
        vertex(hull[i].x, hull[i].y);
    }
    endShape(CLOSE);
    return false;
}

// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
function convexHull(points) {
    points.sort(comparison);
    var L = [];
    for (var i = 0; i < points.length; i++) {
        while (L.length >= 2 && cross(L[L.length - 2], L[L.length - 1], points[i]) <= 0) {
            L.pop();
        }
        L.push(points[i]);
    }
    var U = [];
    for (var i = points.length - 1; i >= 0; i--) {
        while (U.length >= 2 && cross(U[U.length - 2], U[U.length - 1], points[i]) <= 0) {
            U.pop();
        }
        U.push(points[i]);
    }
    L.pop();
    U.pop();
    return L.concat(U);
}

function comparison(a, b) {
    return a.x == b.x ? a.y - b.y : a.x - b.x;
}

function cross(a, b, o) {
    return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
}
