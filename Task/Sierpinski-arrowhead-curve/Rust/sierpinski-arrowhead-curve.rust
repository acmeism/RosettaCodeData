// [dependencies]
// svg = "0.8.0"

const SQRT3_2: f64 = 0.86602540378444;

use svg::node::element::path::Data;

struct Cursor {
    x: f64,
    y: f64,
    angle: i32,
}

impl Cursor {
    fn new(x: f64, y: f64) -> Cursor {
        Cursor {
            x: x,
            y: y,
            angle: 0,
        }
    }
    fn turn(&mut self, angle: i32) {
        self.angle = (self.angle + angle) % 360;
    }
    fn draw_line(&mut self, data: Data, length: f64) -> Data {
        let theta = (self.angle as f64).to_radians();
        self.x += length * theta.cos();
        self.y += length * theta.sin();
        data.line_to((self.x, self.y))
    }
}

fn curve(mut data: Data, order: usize, length: f64, cursor: &mut Cursor, angle: i32) -> Data {
    if order == 0 {
        return cursor.draw_line(data, length);
    }
    data = curve(data, order - 1, length / 2.0, cursor, -angle);
    cursor.turn(angle);
    data = curve(data, order - 1, length / 2.0, cursor, angle);
    cursor.turn(angle);
    curve(data, order - 1, length / 2.0, cursor, -angle)
}

fn write_sierpinski_arrowhead(file: &str, size: usize, order: usize) -> std::io::Result<()> {
    use svg::node::element::Path;
    use svg::node::element::Rectangle;

    let margin = 20.0;
    let side = (size as f64) - 2.0 * margin;
    let y = 0.5 * (size as f64) + 0.5 * SQRT3_2 * side;
    let x = margin;
    let mut cursor = Cursor::new(x, y);
    if (order & 1) != 0 {
        cursor.turn(-60);
    }
    let mut data = Data::new().move_to((x, y));
    data = curve(data, order, side, &mut cursor, 60);
    let rect = Rectangle::new()
        .set("width", "100%")
        .set("height", "100%")
        .set("fill", "white");
    let mut document = svg::Document::new()
        .set("width", size)
        .set("height", size)
        .add(rect);
    let path = Path::new()
        .set("fill", "none")
        .set("stroke", "black")
        .set("stroke-width", "1")
        .set("d", data);
    document = document.add(path);
    svg::save(file, &document)
}

fn main() {
    write_sierpinski_arrowhead("sierpinski_arrowhead.svg", 600, 8).unwrap();
}
