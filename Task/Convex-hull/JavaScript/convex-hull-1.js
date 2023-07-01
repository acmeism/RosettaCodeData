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
