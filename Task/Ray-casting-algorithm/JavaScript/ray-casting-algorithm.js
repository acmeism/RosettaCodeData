/**
 * @return {boolean} true if (lng, lat) is in bounds
 */
function contains(bounds, lat, lng) {
    //https://rosettacode.org/wiki/Ray-casting_algorithm
    var count = 0;
    for (var b = 0; b < bounds.length; b++) {
        var vertex1 = bounds[b];
        var vertex2 = bounds[(b + 1) % bounds.length];
        if (west(vertex1, vertex2, lng, lat))
            ++count;
    }
    return count % 2;

    /**
     * @return {boolean} true if (x,y) is west of the line segment connecting A and B
     */
    function west(A, B, x, y) {
        if (A.y <= B.y) {
            if (y <= A.y || y > B.y ||
                x >= A.x && x >= B.x) {
                return false;
            } else if (x < A.x && x < B.x) {
                return true;
            } else {
                return (y - A.y) / (x - A.x) > (B.y - A.y) / (B.x - A.x);
            }
        } else {
            return west(B, A, x, y);
        }
    }
}

var square = {name: 'square', bounds: [{x: 0, y: 0}, {x: 20, y: 0}, {x: 20, y: 20}, {x: 0, y: 20}]};
var squareHole = {
    name: 'squareHole',
    bounds: [{x: 0, y: 0}, {x: 20, y: 0}, {x: 20, y: 20}, {x: 0, y: 20}, {x: 5, y: 5}, {x: 15, y: 5}, {x: 15, y: 15}, {x: 5, y: 15}]
};
var strange = {
    name: 'strange',
    bounds: [{x: 0, y: 0}, {x: 5, y: 5}, {x: 0, y: 20}, {x: 5, y: 15}, {x: 15, y: 15}, {x: 20, y: 20}, {x: 20, y: 0}]
};
var hexagon = {
    name: 'hexagon',
    bounds: [{x: 6, y: 0}, {x: 14, y: 0}, {x: 20, y: 10}, {x: 14, y: 20}, {x: 6, y: 20}, {x: 0, y: 10}]
};

var shapes = [square, squareHole, strange, hexagon];
var testPoints = [{lng: 10, lat: 10}, {lng: 10, lat: 16}, {lng: -20, lat: 10},
    {lng: 0, lat: 10}, {lng: 20, lat: 10}, {lng: 16, lat: 10}, {lng: 20, lat: 20}];

for (var s = 0; s < shapes.length; s++) {
    var shape = shapes[s];
    for (var tp = 0; tp < testPoints.length; tp++) {
        var testPoint = testPoints[tp];
        console.log(JSON.stringify(testPoint) + '\tin ' + shape.name + '\t' + contains(shape.bounds, testPoint.lat, testPoint.lng));
    }
}
