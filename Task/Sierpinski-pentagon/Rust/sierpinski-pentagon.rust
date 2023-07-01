// [dependencies]
// svg = "0.8.0"

fn sierpinski_pentagon(
    mut document: svg::Document,
    mut x: f64,
    mut y: f64,
    mut side: f64,
    order: usize,
) -> svg::Document {
    use std::f64::consts::PI;
    use svg::node::element::Polygon;

    let degrees72 = 0.4 * PI;
    let mut angle = 3.0 * degrees72;
    let scale_factor = 1.0 / (2.0 + degrees72.cos() * 2.0);

    if order == 1 {
        let mut points = Vec::new();
        points.push((x, y));
        for _ in 0..5 {
            x += angle.cos() * side;
            y -= angle.sin() * side;
            angle += degrees72;
            points.push((x, y));
        }
        let polygon = Polygon::new()
            .set("fill", "blue")
            .set("stroke", "black")
            .set("stroke-width", "1")
            .set("points", points);
        document = document.add(polygon);
    } else {
        side *= scale_factor;
        let distance = side + side * degrees72.cos() * 2.0;
        for _ in 0..5 {
            x += angle.cos() * distance;
            y -= angle.sin() * distance;
            angle += degrees72;
            document = sierpinski_pentagon(document, x, y, side, order - 1);
        }
    }
    document
}

fn write_sierpinski_pentagon(file: &str, size: usize, order: usize) -> std::io::Result<()> {
    use std::f64::consts::PI;
    use svg::node::element::Rectangle;

    let margin = 5.0;
    let radius = (size as f64) / 2.0 - 2.0 * margin;
    let side = radius * (0.2 * PI).sin() * 2.0;
    let height = side * ((0.2 * PI).sin() + (0.4 * PI).sin());
    let x = (size as f64) / 2.0;
    let y = (size as f64 - height) / 2.0;

    let rect = Rectangle::new()
        .set("width", "100%")
        .set("height", "100%")
        .set("fill", "white");

    let mut document = svg::Document::new()
        .set("width", size)
        .set("height", size)
        .add(rect);

    document = sierpinski_pentagon(document, x, y, side, order);
    svg::save(file, &document)
}

fn main() {
    write_sierpinski_pentagon("sierpinski_pentagon.svg", 600, 5).unwrap();
}
