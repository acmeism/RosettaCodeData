// [dependencies]
// svg = "0.8.0"

use svg::node::element::path::Data;
use svg::node::element::Path;

struct PeanoCurve {
    current_x: f64,
    current_y: f64,
    current_angle: i32,
    line_length: f64,
}

impl PeanoCurve {
    fn new(x: f64, y: f64, length: f64, angle: i32) -> PeanoCurve {
        PeanoCurve {
            current_x: x,
            current_y: y,
            current_angle: angle,
            line_length: length,
        }
    }
    fn rewrite(order: usize) -> String {
        let mut str = String::from("L");
        for _ in 0..order {
            let mut tmp = String::new();
            for ch in str.chars() {
                match ch {
                    'L' => tmp.push_str("LFRFL-F-RFLFR+F+LFRFL"),
                    'R' => tmp.push_str("RFLFR+F+LFRFL-F-RFLFR"),
                    _ => tmp.push(ch),
                }
            }
            str = tmp;
        }
        str
    }
    fn execute(&mut self, order: usize) -> Path {
        let mut data = Data::new().move_to((self.current_x, self.current_y));
        for ch in PeanoCurve::rewrite(order).chars() {
            match ch {
                'F' => data = self.draw_line(data),
                '+' => self.turn(90),
                '-' => self.turn(-90),
                _ => {}
            }
        }
        Path::new()
            .set("fill", "none")
            .set("stroke", "black")
            .set("stroke-width", "1")
            .set("d", data)
    }
    fn draw_line(&mut self, data: Data) -> Data {
        let theta = (self.current_angle as f64).to_radians();
        self.current_x += self.line_length * theta.cos();
        self.current_y += self.line_length * theta.sin();
        data.line_to((self.current_x, self.current_y))
    }
    fn turn(&mut self, angle: i32) {
        self.current_angle = (self.current_angle + angle) % 360;
    }
    fn save(file: &str, size: usize, order: usize) -> std::io::Result<()> {
        use svg::node::element::Rectangle;
        let rect = Rectangle::new()
            .set("width", "100%")
            .set("height", "100%")
            .set("fill", "white");
        let mut p = PeanoCurve::new(8.0, 8.0, 8.0, 90);
        let document = svg::Document::new()
            .set("width", size)
            .set("height", size)
            .add(rect)
            .add(p.execute(order));
        svg::save(file, &document)
    }
}

fn main() {
    PeanoCurve::save("peano_curve.svg", 656, 4).unwrap();
}
