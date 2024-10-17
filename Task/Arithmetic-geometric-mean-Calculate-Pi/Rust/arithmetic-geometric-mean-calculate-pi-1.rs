/// calculate pi with algebraic/geometric mean
pub fn pi(n: usize) -> f64 {
    let mut a : f64 = 1.0;
    let two : f64= 2.0;
    let mut g = 1.0 / two.sqrt();
    let mut s = 0.0;
    let mut k = 1;
    while k<=n  {

        let a1 = (a+g)/two;
        let g1 = (a*g).sqrt();
        a = a1;
        g = g1;
        s += (a.powi(2)-g.powi(2)) * two.powi((k+1) as i32);
        k += 1;


    }

    4.0 * a.powi(2) / (1.0-s)
}
