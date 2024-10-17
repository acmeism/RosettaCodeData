use svg::node::element::Path;

fn main() {
    let doc = svg::Document::new()
        .add(yin_yang(15.0, 1.0))
        .add(yin_yang(6.0, 0.7).set("transform", "translate(30)"));
    svg::save("YinYang_rust.svg", &doc.set("viewBox", (-20, -20, 60, 40))).unwrap();
}
/// th - the thickness of the outline around yang
fn yin_yang(r: f32, th: f32) -> Path {
    let (cr, cw, ccw) = (",0,1,1,.1,0z", ",0,0,1,0,", ",0,0,0,0,");
    let d = format!("M0,{0} a{0},{0}{cr} M0,{1} ", r + th, -r / 3.0) // main_circle
        + &format!("a{0},{0}{cr} m0,{r} a{0},{0}{cr} M0,0 ", r / 6.0) // eyes
        + &format!("A{0},{0}{ccw}{r} A{r},{r}{cw}-{r} A{0},{0}{cw}0", r / 2.0); // yang
    Path::new().set("d", d).set("fill-rule", "evenodd")
}
