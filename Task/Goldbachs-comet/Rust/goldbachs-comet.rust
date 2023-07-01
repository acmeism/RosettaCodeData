// [dependencies]
// primal = "0.3"
// plotters = "0.3.2"

use plotters::prelude::*;

fn goldbach(n: u64) -> u64 {
    let mut p = 2;
    let mut count = 0;
    loop {
        let q = n - p;
        if q < p {
            break;
        }
        if primal::is_prime(p) && primal::is_prime(q) {
            count += 1;
        }
        if p == 2 {
            p += 1;
        } else {
            p += 2;
        }
    }
    count
}

fn goldbach_plot(filename: &str) -> Result<(), Box<dyn std::error::Error>> {
    let gvalues : Vec<u64> = (1..=2000).map(|x| goldbach(2 * x + 2)).collect();
    let mut gmax = *gvalues.iter().max().unwrap();
    gmax = 10 * ((gmax + 9) / 10);

    let root = SVGBackend::new(filename, (1000, 500)).into_drawing_area();
    root.fill(&WHITE)?;

    let mut chart = ChartBuilder::on(&root)
        .x_label_area_size(20)
        .y_label_area_size(20)
        .margin(10)
        .caption("Goldbach's Comet", ("sans-serif", 24).into_font())
        .build_cartesian_2d(0usize..2000usize, 0u64..gmax)?;

    chart
        .configure_mesh()
        .disable_x_mesh()
        .disable_y_mesh()
        .draw()?;

    chart.draw_series(
        gvalues
            .iter()
            .cloned()
            .enumerate()
            .map(|p| Circle::new(p, 2, BLUE.filled())),
    )?;

    Ok(())
}

fn main() {
    println!("First 100 G numbers:");
    for i in 1..=100 {
        print!(
            "{:2}{}",
            goldbach(2 * i + 2),
            if i % 10 == 0 { "\n" } else { " " }
        );
    }

    println!("\nG(1000000) = {}", goldbach(1000000));

    match goldbach_plot("goldbach.svg") {
        Ok(()) => {}
        Err(error) => eprintln!("Error: {}", error),
    }
}
