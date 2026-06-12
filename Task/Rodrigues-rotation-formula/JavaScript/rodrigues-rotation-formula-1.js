function norm(v) {
    return Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
}
function normalize(v) {
    var length = norm(v);
    return [v[0]/length, v[1]/length, v[2]/length];
}
function dotProduct(v1, v2) {
    return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2];
}
function crossProduct(v1, v2) {
    return [v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0]];
}
function getAngle(v1, v2) {
    return Math.acos(dotProduct(v1, v2) / (norm(v1)*norm(v2)));
}
function matrixMultiply(matrix, v) {
    return [dotProduct(matrix[0], v), dotProduct(matrix[1], v), dotProduct(matrix[2], v)];
}
function aRotate(p, v, a) {
    var ca = Math.cos(a), sa = Math.sin(a), t=1-ca, x=v[0], y=v[1], z=v[2];
    var r = [
        [ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa],
        [x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa],
        [z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t]
    ];
    return matrixMultiply(r, p);
}

var v1 = [5,-6,4];
var v2 = [8,5,-30];
var a = getAngle(v1, v2);
var cp = crossProduct(v1, v2);
var ncp = normalize(cp);
var np = aRotate(v1, ncp, a);
console.log(np);
