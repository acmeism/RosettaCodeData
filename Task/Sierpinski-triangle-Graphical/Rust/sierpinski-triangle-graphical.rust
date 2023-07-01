// [dependencies]
// svg = "0.8.0"

const SQRT3_2: f64 = 0.86602540378444;

fn sierpinski_triangle(
    mut document: svg::Document,
    mut x: f64,
    mut y: f64,
    mut side: f64,
    order: usize,
) -> svg::Document {
    use svg::node::element::Polygon;

    if order == 1 {
        let mut points = Vec::new();
        points.push((x, y));
        y += side * SQRT3_2;
        x -= side * 0.5;
        points.push((x, y));
        x += side;
        points.push((x, y));
        let polygon = Polygon::new()
            .set("fill", "black")
            .set("stroke", "none")
            .set("points", points);
        document = document.add(polygon);
    } else {
        side *= 0.5;
        document = sierpinski_triangle(document, x, y, side, order - 1);
        y += side * SQRT3_2;
        x -= side * 0.5;
        document = sierpinski_triangle(document, x, y, side, order - 1);
        x += side;
        document = sierpinski_triangle(document, x, y, side, order - 1);
    }
    document
}

fn write_sierpinski_triangle(file: &str, size: usize, order: usize) -> std::io::Result<()> {
    use svg::node::element::Rectangle;

    let margin = 20.0;
    let side = (size as f64) - 2.0 * margin;
    let y = 0.5 * ((size as f64) - SQRT3_2 * side);
    let x = margin + side * 0.5;

    let rect = Rectangle::new()
        .set("width", "100%")
        .set("height", "100%")
        .set("fill", "white");

    let mut document = svg::Document::new()
        .set("width", size)
        .set("height", size)
        .add(rect);

    document = sierpinski_triangle(document, x, y, side, order);
    svg::save(file, &document)
}

fn main() {
    write_sierpinski_triangle("sierpinski_triangle.svg", 600, 8).unwrap();
}
