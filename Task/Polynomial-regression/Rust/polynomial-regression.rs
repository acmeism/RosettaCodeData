fn poly_regression(x: &[i32], y: &[i32]) {
    let n = x.len();
    let r: Vec<i32> = (0..n as i32).collect();

    let xm = x.iter().sum::<i32>() as f64 / x.len() as f64;
    let ym = y.iter().sum::<i32>() as f64 / y.len() as f64;
    let x2m: f64 = r.iter().map(|&a| (a * a) as f64).sum::<f64>() / r.len() as f64;
    let x3m: f64 = r.iter().map(|&a| (a * a * a) as f64).sum::<f64>() / r.len() as f64;
    let x4m: f64 = r.iter().map(|&a| (a * a * a * a) as f64).sum::<f64>() / r.len() as f64;

    let xym: f64 = x.iter().zip(y.iter()).map(|(&a, &b)| (a as f64) * (b as f64)).sum::<f64>() / x.len().min(y.len()) as f64;

    let x2ym: f64 = x.iter().zip(y.iter()).map(|(&a, &b)| (a * a) as f64 * (b as f64)).sum::<f64>() / x.len().min(y.len()) as f64;

    let sxx = x2m - xm * xm;
    let sxy = xym - xm * ym;
    let sxx2 = x3m - xm * x2m;
    let sx2x2 = x4m - x2m * x2m;
    let sx2y = x2ym - x2m * ym;

    let b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    let c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    let a = ym - b * xm - c * x2m;

    let abc = |xx: i32| a + b * (xx as f64) + c * (xx * xx) as f64;

    println!("y = {} + {}x + {}x^2", a, b, c);
    println!(" Input  Approximation");
    println!(" x   y     y1");

    for (&x_val, &y_val) in x.iter().zip(y.iter()) {
        println!("{:2} {:3}  {:5.1}", x_val, y_val, abc(x_val));
    }
}

fn main() {
    let x: Vec<i32> = (0..11).collect();
    let y: Vec<i32> = vec![1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321];

    poly_regression(&x, &y);
}
