use num::complex::Complex;
use plotters::prelude::*;

fn is_prime(num: i32) -> bool {
    if num <=1 {
        return false;
    }
    for i in 2..=((num as f64).sqrt() as i32) {
        if num%i==0 {
            return false;
        }
    }
    true
}

fn is_gaussian_prime(num: Complex<i32> ) -> bool {
    let (r, c , amp) = (num.re, num.im, num.norm_sqr());
    // Checking the 4n + 3 rule
    (r == 0 && is_prime(c) && (c-3)%4==0)
        || (c==0 && is_prime(r) && (r-3)%4==0)
        || is_prime(amp)
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let limit: i32 = 10;

    let mut testvals = Vec::new();

    // Generate all test values in the square [-limit, limit) x [-limit, limit)
    for r in -limit..limit {
        for c in -limit..limit {
            testvals.push(Complex::new(r,c));
        }
    }

    // Filter Gaussian Primes within limit
    let mut gprimes: Vec<Complex<i32>> = testvals
        .into_iter()
        .filter(|&c| is_gaussian_prime(c) && c.norm_sqr() < limit.pow(2))
        .collect();

    gprimes.sort_by_key(|c| c.norm_sqr());

    println!(
        "Gaussian primes within {} of the origin on the complex plane:",
        limit
    );

    for (i, c) in gprimes.iter().enumerate() {
        print!("({:>3},{:>3}) ", c.re, c.im);
        if (i + 1) % 7 == 0 {
            println!();
        }
    }
    println!();

    // Plot
    plot_gaussian_primes(&gprimes, limit)?;

    Ok(())
}


fn plot_gaussian_primes(
    gprimes: &Vec<Complex<i32>>,
    limit: i32,
) -> Result<(), Box<dyn std::error::Error>> {
    let root_area = BitMapBackend::new("gaussian_primes.png", (600, 600)).into_drawing_area();
    root_area.fill(&WHITE)?;

    let mut chart = ChartBuilder::on(&root_area)
        .margin(10)
        .x_label_area_size(30)
        .y_label_area_size(30)
        .build_cartesian_2d((-limit..limit), (-limit..limit))?;

    chart.configure_mesh().draw()?;

    chart.draw_series(
        gprimes.iter().map(|c| Circle::new((c.re, c.im), 2, BLUE.filled())),
    )?;

    Ok(())
}
