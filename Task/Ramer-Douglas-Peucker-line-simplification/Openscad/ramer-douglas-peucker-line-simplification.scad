function slice(a, v) = [ for (i = v) a[i] ];

// Find the distance from the point to the line
function perpendicular_distance(pt, start, end) =
    let (
        d = end - start,
        dn = d / norm(d),
        dp = pt - start,
        // Dot-product of two vectors
        ddot = dn * dp,
        ds = dn * ddot
    )
        norm(dp - ds);

// Find the point with the maximum distance from line between start and end.
// Returns a vector of [dmax, point_index]
function max_distance(pts, cindex=1, iresult=[0,0]) =
    let (
        d = perpendicular_distance(pts[cindex], pts[0],pts[len(pts)-1]),
        result = (d > iresult[0] ? [d, cindex] : iresult)
    )
        (cindex == len(pts) - 1 ?
            iresult :
            max_distance(pts, cindex+1, result));

// Tail recursion optimization is not possible with tree recursion.
//
// It's probably possible to optimize this with tail recursion by converting to
// iterative approach, see
// https://namekdev.net/2014/06/iterative-version-of-ramer-douglas-peucker-line-simplification-algorithm/ .
// It's not possible to use iterative approach without recursion at all because
// of static nature of OpenSCAD arrays.
function ramer_douglas_peucker(points, epsilon=1) =
    let (dmax = max_distance(points))
        // Simplify the line recursively if the max distance is greater than epsilon
        (dmax[0] > epsilon ?
            let (
                lo = ramer_douglas_peucker(
                    slice(points, [0:dmax[1]]), epsilon),
                hi = ramer_douglas_peucker(
                    slice(points, [dmax[1]:len(points)-1]), epsilon)
            )
                concat(slice(lo, [0:len(lo)-2]), hi) :
            [points[0],points[len(points)-1]]);

/* -- Demo -- */

module line(points, thickness=1, dot=2) {
    for (idx = [0:len(points)-2]) {
        translate(points[idx])
            sphere(d=dot);
        hull() {
            translate(points[idx])
                sphere(d=thickness);
            translate(points[idx+1])
                sphere(d=thickness);
        }
    }
    translate(points[len(points)-1])
        sphere(d=dot);
}

function addz(pts, z=0) = [ for (p = pts) [p.x, p.y, z] ];

module demo(pts) {
    rdp = ramer_douglas_peucker(points=pts, epsilon=1);
    echo(rdp);
    color("gray")
        line(points=addz(pts, 0), thickness=0.1, dot=0.3);
    color("red")
        line(points=addz(rdp, 1), thickness=0.1, dot=0.3);
}

$fn=16;
points = [[0,0], [1,0.1], [2,-0.1], [3,5], [4,6], [5,7], [6,8.1], [7,9], [8,9], [9,9]];
demo(points);
