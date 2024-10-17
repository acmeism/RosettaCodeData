// [dependencies]
// svg = "0.8.0"

use svg::node::element::path::Data;
use svg::node::element::Path;
use svg::node::element::Rectangle;

const SQRT3_2: f64 = 0.86602540378444;

fn koch_curve(mut data: Data, x0: f64, y0: f64, x1: f64, y1: f64, order: usize) -> Data {
    if order == 0 {
        data = data.line_to((x1, y1));
    } else {
        let dx = x1 - x0;
        let dy = y1 - y0;
        let x2 = x0 + dx / 3.0;
        let y2 = y0 + dy / 3.0;
        let x3 = x0 + dx / 2.0 - dy * SQRT3_2 / 3.0;
        let y3 = y0 + dy / 2.0 + dx * SQRT3_2 / 3.0;
        let x4 = x0 + 2.0 * dx / 3.0;
        let y4 = y0 + 2.0 * dy / 3.0;
        data = koch_curve(data, x0, y0, x2, y2, order - 1);
        data = koch_curve(data, x2, y2, x3, y3, order - 1);
        data = koch_curve(data, x3, y3, x4, y4, order - 1);
        data = koch_curve(data, x4, y4, x1, y1, order - 1);
    }
    data
}

fn write_koch_snowflake(file: &str, size: usize, order: usize) -> std::io::Result<()> {
    let length = (size as f64) * SQRT3_2 * 0.95;
    let x0 = ((size as f64) - length) / 2.0;
    let y0 = (size as f64) / 2.0 - length * SQRT3_2 / 3.0;
    let x1 = x0 + length / 2.0;
    let y1 = y0 + length * SQRT3_2;
    let x2 = x0 + length;

    let mut data = Data::new().move_to((x0, y0));
    data = koch_curve(data, x0, y0, x1, y1, order);
    data = koch_curve(data, x1, y1, x2, y0, order);
    data = koch_curve(data, x2, y0, x0, y0, order);

    let path = Path::new()
        .set("fill", "none")
        .set("stroke", "white")
        .set("stroke-width", "1")
        .set("d", data);

    let rect = Rectangle::new()
        .set("width", "100%")
        .set("height", "100%")
        .set("fill", "black");

    let document = svg::Document::new()
        .set("width", size)
        .set("height", size)
        .add(rect)
        .add(path);

    svg::save(file, &document)
}

fn main() {
    write_koch_snowflake("koch_snowflake.svg", 600, 5).unwrap();
}
