#[derive(Debug, Clone)]
struct Point {
    x: f32,
    y: f32
}

fn calculate_convex_hull(points: &Vec<Point>) -> Vec<Point> {
    //There must be at least 3 points
    if points.len() < 3 { return points.clone(); }

    let mut hull = vec![];

    //Find the left most point in the polygon
    let (left_most_idx, _) = points.iter()
        .enumerate()
        .min_by(|lhs, rhs| lhs.1.x.partial_cmp(&rhs.1.x).unwrap())
        .expect("No left most point");


    let mut p = left_most_idx;
    let mut q = 0_usize;

    loop {
        //The left most point must be part of the hull
        hull.push(points[p].clone());

        q = (p + 1) % points.len();

        for i in 0..points.len() {
            if orientation(&points[p], &points[i], &points[q]) == 2 {
                q = i;
            }
        }

        p = q;

        //Break from loop once we reach the first point again
        if p == left_most_idx { break; }
    }

    return hull;
}

//Calculate orientation for 3 points
//0 -> Straight line
//1 -> Clockwise
//2 -> Counterclockwise
fn orientation(p: &Point, q: &Point, r: &Point) -> usize {
    let val = (q.y - p.y) * (r.x - q.x) -
        (q.x - p.x) * (r.y - q.y);

    if val == 0. { return 0 };
    if val > 0. { return 1; } else { return 2; }
}

fn main(){
    let points = vec![pt(16,3), pt(12,17), pt(0,6), pt(-4,-6), pt(16,6), pt(16,-7), pt(16,-3), pt(17,-4), pt(5,19), pt(19,-8), pt(3,16), pt(12,13), pt(3,-4), pt(17,5), pt(-3,15), pt(-3,-9), pt(0,11), pt(-9,-3), pt(-4,-2), pt(12,10)];
    let hull = calculate_convex_hull(&points);

    hull.iter()
        .for_each(|pt| println!("{:?}", pt));
}

fn pt(x: i32, y: i32) -> Point {
    return Point {x:x as f32, y:y as f32};
}
