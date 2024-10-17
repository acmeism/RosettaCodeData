// [dependencies]
// geo = "0.14"

use geo::algorithm::simplify::Simplify;
use geo::line_string;

fn main() {
    let points = line_string![
        (x: 0.0, y: 0.0),
        (x: 1.0, y: 0.1),
        (x: 2.0, y: -0.1),
        (x: 3.0, y: 5.0),
        (x: 4.0, y: 6.0),
        (x: 5.0, y: 7.0),
        (x: 6.0, y: 8.1),
        (x: 7.0, y: 9.0),
        (x: 8.0, y: 9.0),
        (x: 9.0, y: 9.0),
    ];
    for p in points.simplify(&1.0) {
        println!("({}, {})", p.x, p.y);
    }
}
