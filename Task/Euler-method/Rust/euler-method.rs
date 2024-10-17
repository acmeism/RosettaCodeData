fn header() {
    print!("    Time: ");
    for t in (0..100).step_by(10) {
        print!(" {:7}", t);
    }
    println!();
}

fn analytic() {
    print!("Analytic: ");
    for t in (0..=100).step_by(10) {
        print!(" {:7.3}", 20.0 + 80.0 * (-0.07 * f64::from(t)).exp());
    }
    println!();
}

fn euler<F: Fn(f64) -> f64>(f: F, mut y: f64, step: usize, end: usize) {
    print!(" Step {:2}: ", step);
    for t in (0..=end).step_by(step) {
        if t % 10 == 0 {
            print!(" {:7.3}", y);
        }
        y += step as f64 * f(y);
    }
    println!();
}

fn main() {
    header();
    analytic();
    for &i in &[2, 5, 10] {
        euler(|temp| -0.07 * (temp - 20.0), 100.0, i, 100);
    }
}
