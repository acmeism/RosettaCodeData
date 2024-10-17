use svg::node::element::{Group, Polygon};

fn main() {
    let mut base: Vec<[(f64, f64); 2]> = vec![[(-200., 0.), (200., 0.)]];
    let doc = (0..12_u8).fold(svg::Document::new().set("stroke", "white"), |doc_a, lvl| {
        let rg = |step| lvl.wrapping_mul(step).wrapping_add(80 - step * 2);
        let g = Group::new().set("fill", format!("#{:02X}{:02X}18", rg(20), rg(30))); // level color
        doc_a.add(base.split_off(0).into_iter().fold(g, |ga, [a, b]| {
            let v = (b.0 - a.0, b.1 - a.1);
            let [c, d, w] = [a, b, v].map(|p| (p.0 + v.1, p.1 - v.0));
            let e = (c.0 + w.0 / 2., c.1 + w.1 / 2.);
            base.extend([[c, e], [e, d]]);
            ga.add(Polygon::new().set("points", vec![a, c, e, d, c, d, b]))
        }))
    });
    let (x, y) = (base.iter()).fold((0., 0.), |(xa, ya), [p, _]| (p.0.min(xa), p.1.min(ya)));
    svg::save("Pythagor_tree.svg", &doc.set("viewBox", (x, y, -x - x, -y))).unwrap();
}
