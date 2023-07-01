// distance between two points
function distance(p1, p2) = sqrt((difference(p2.x, p1.x)) ^ 2 + (difference(p2.y, p1.y) ^ 2));
// difference between two values in any order
function difference(a, b) = let(x = a > b ? a - b : b - a) x;

// function to find the circles of given radius through two points
function circles_of_given_radius_through_two_points(p1, p2, radius) =
    let(mid = (p1 + p2)/2, q = distance(p1, p2), x_dist = sqrt(radius ^ 2 - (q / 2) ^ 2) * (p1.y - p2.y) / q,
        y_dist = sqrt(radius ^ 2 - (q / 2) ^ 2) * (p2.x - p1.x) / q)
    // point 1 and point 2 must not be the same point
    assert(p1 != p2)
    // radius must be more than 0
    assert(radius > 0)
    // distance between points cannot be more than diameter
    assert(q < radius * 2)
        // return both qualifying centres
        [mid + [ x_dist, y_dist ], mid - [ x_dist, y_dist ]];

// test module for circles_of_given_radius_through_two_points
module test_circles_of_given_radius_through_two_points()
{
    tests = [
        [ [ -10, -10, 0 ], [ 50, 0, 0 ], 100 ], [ [ 200, 0, 0 ], [ 220, -20, 0 ], 30 ],
        [ [ 300, 100, 0 ], [ 350, 200, 0 ], 80 ]
    ];

    for (t = tests)
    {
        let(start = t[0], end = t[1], radius = t[2])
        {
            // plot start and end dots - these should be at the intersections of the circles
            color("green") translate(start) cylinder(h = 3, r = 4);
            color("green") translate(end) cylinder(h = 3, r = 4);

            // call function
            centres = circles_of_given_radius_through_two_points(start, end, radius);
            echo("centres", centres);
            // plot results
            color("yellow") translate(centres[0]) cylinder(h = 1, r = radius);
            color("red") translate(centres[1]) cylinder(h = 2, r = radius);
        };
    };
    // The following tests will stop all execution. To run them, uncomment one at a time
    // should fail - same points
    // echo(circles_of_given_radius_through_two_points([0,0],[0,0],1));
    // should fail - points are more than diameter apart
    // echo(circles_of_given_radius_through_two_points(p1 = [0,0], p2 = [0,101], radius = 50));
    // should fail - radius must be greater than 0
    // echo(circles_of_given_radius_through_two_points(p1= [1,1], p2 = [10,1], radius = 0));
}

test_circles_of_given_radius_through_two_points();
