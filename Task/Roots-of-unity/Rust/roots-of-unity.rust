use num::Complex;
fn main() {
    let n = 8;
    let z = Complex::from_polar(&1.0,&(1.0*std::f64::consts::PI/n as f64));
    for k in 0..=n-1 {
        println!("e^{:2}πi/{} ≈ {:>14.3}",2*k,n,z.powf(2.0*k as f64));
    }
}
