#![feature(conservative_impl_trait)]
fn main() {
    let (x, xi) = (2.0, 0.5);
    let (y, yi) = (4.0, 0.25);
    let z = x + y;
    let zi = 1.0/z;

    let numlist = [x,y,z];
    let invlist = [xi,yi,zi];

    let result = numlist.iter()
                        .zip(&invlist)
                        .map(|(x,y)| multiplier(*x,*y)(0.5))
                        .collect::<Vec<_>>();
    println!("{:?}", result);
}

fn multiplier(x: f64, y: f64) -> impl Fn(f64) -> f64 {
    move |m| x*y*m
}
