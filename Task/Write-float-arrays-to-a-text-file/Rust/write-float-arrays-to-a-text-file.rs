use std::iter::zip;

fn main() {
    let xs: [f32; 4] = [1.0, 2.0, 3.0, 1e11];

    zip(xs.iter(), xs.iter().map(|x| x.sqrt()))
        .for_each(|(x, y)| println!("{:10.3E} {:10.5E}", x, y));
}
