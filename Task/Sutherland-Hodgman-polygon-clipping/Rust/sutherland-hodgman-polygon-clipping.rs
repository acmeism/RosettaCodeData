#[derive(Debug, Clone)]
struct Point {
    x: f64,
    y: f64,
}

#[derive(Debug, Clone)]
struct Polygon(Vec<Point>);

fn is_inside(p: &Point, cp1: &Point, cp2: &Point) -> bool {
    (cp2.x - cp1.x) * (p.y - cp1.y) > (cp2.y - cp1.y) * (p.x - cp1.x)
}

fn compute_intersection(cp1: &Point, cp2: &Point, s: &Point, e: &Point) -> Point {
    let dc = Point {
        x: cp1.x - cp2.x,
        y: cp1.y - cp2.y,
    };
    let dp = Point {
        x: s.x - e.x,
        y: s.y - e.y,
    };
    let n1 = cp1.x * cp2.y - cp1.y * cp2.x;
    let n2 = s.x * e.y - s.y * e.x;
    let n3 = 1.0 / (dc.x * dp.y - dc.y * dp.x);
    Point {
        x: (n1 * dp.x - n2 * dc.x) * n3,
        y: (n1 * dp.y - n2 * dc.y) * n3,
    }
}

fn sutherland_hodgman_clip(subject_polygon: &Polygon, clip_polygon: &Polygon) -> Polygon {
    let mut result_ring = subject_polygon.0.clone();
    let mut cp1 = clip_polygon.0.last().unwrap();
    for cp2 in &clip_polygon.0 {
        let input = result_ring;
        let mut s = input.last().unwrap();
        result_ring = vec![];
        for e in &input {
            if is_inside(e, cp1, cp2) {
                if !is_inside(s, cp1, cp2) {
                    result_ring.push(compute_intersection(cp1, cp2, s, e));
                }
                result_ring.push(e.clone());
            } else if is_inside(s, cp1, cp2) {
                result_ring.push(compute_intersection(cp1, cp2, s, e));
            }
            s = e;
        }
        cp1 = cp2;
    }
    Polygon(result_ring)
}

fn main() {
    let _p = |x: f64, y: f64| Point { x, y };
    let subject_polygon = Polygon(vec![
        _p(50.0, 150.0), _p(200.0, 50.0), _p(350.0, 150.0), _p(350.0, 300.0), _p(250.0, 300.0),
        _p(200.0, 250.0), _p(150.0, 350.0), _p(100.0, 250.0), _p(100.0, 200.0),
    ]);
    let clip_polygon = Polygon(vec![
        _p(100.0, 100.0),_p(300.0, 100.0),_p(300.0, 300.0),_p(100.0, 300.0),
    ]);
    let result = sutherland_hodgman_clip(&subject_polygon, &clip_polygon);
    println!("{:?}", result);
}
