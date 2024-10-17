#![feature(conservative_impl_trait)]
fn main() {
    let cube      = |x: f64| x.powi(3);
    let cube_root = |x: f64| x.powf(1.0 / 3.0);

    let flist  : [&Fn(f64) -> f64; 3] = [&cube     , &f64::sin , &f64::cos ];
    let invlist: [&Fn(f64) -> f64; 3] = [&cube_root, &f64::asin, &f64::acos];

    let result = flist.iter()
                      .zip(&invlist)
                      .map(|(f,i)| compose(f,i)(0.5))
                      .collect::<Vec<_>>();

    println!("{:?}", result);

}

fn compose<'a, F, G, T, U, V>(f: F, g: G) -> impl 'a + Fn(T) -> V
    where F: 'a + Fn(T) -> U,
          G: 'a + Fn(U) -> V,
{
    move |x| g(f(x))

}
