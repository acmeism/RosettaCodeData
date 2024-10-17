fn main() {
    let inf: f64 = 1. / 0.;          // or std::f64::INFINITY
    let minus_inf: f64 = -1. / 0.;   // or std::f64::NEG_INFINITY
    let minus_zero: f64 = -1. / inf; // or -0.0
    let nan: f64 = 0. / 0.;          // or std::f64::NAN
                                     // or std::f32 for the above
    println!("positive infinity: {:+}", inf);
    println!("negative infinity: {:+}", minus_inf);
    println!("negative zero: {:+?}", minus_zero);
    println!("not a number: {:+}", nan);
    println!();
    println!("+inf + 2.0 = {:+}", inf + 2.);
    println!("+inf - 10.0 = {:+}", inf - 10.);
    println!("+inf + -inf = {:+}", inf + minus_inf);
    println!("0.0 * inf = {:+}", 0. * inf);
    println!("1.0 / -0.0 = {:+}", 1. / -0.);
    println!("NaN + 1.0 = {:+}", nan + 1.);
    println!("NaN + NaN = {:+}", nan + nan);
    println!();
    println!("NaN == NaN = {}", nan == nan);
    println!("0.0 == -0.0 = {}", 0. == -0.);
}
