// [dependencies]
// num = "0.3"
// plotters = "^0.2.15"

use num::integer::gcd;
use plotters::prelude::*;
use std::collections::HashSet;

fn yellowstone_sequence() -> impl std::iter::Iterator<Item = u32> {
    let mut sequence: HashSet<u32> = HashSet::new();
    let mut min = 1;
    let mut n = 0;
    let mut n1 = 0;
    let mut n2 = 0;
    std::iter::from_fn(move || {
        n2 = n1;
        n1 = n;
        if n < 3 {
            n += 1;
        } else {
            n = min;
            while !(!sequence.contains(&n) && gcd(n1, n) == 1 && gcd(n2, n) > 1) {
                n += 1;
            }
        }
        sequence.insert(n);
        while sequence.contains(&min) {
            sequence.remove(&min);
            min += 1;
        }
        Some(n)
    })
}

// Based on the example in the "Quick Start" section of the README file for
// the plotters library.
fn plot_yellowstone(filename: &str) -> Result<(), Box<dyn std::error::Error>> {
    let root = BitMapBackend::new(filename, (800, 600)).into_drawing_area();
    root.fill(&WHITE)?;
    let mut chart = ChartBuilder::on(&root)
        .caption("Yellowstone Sequence", ("sans-serif", 24).into_font())
        .margin(10)
        .x_label_area_size(20)
        .y_label_area_size(20)
        .build_ranged(0usize..100usize, 0u32..180u32)?;
    chart.configure_mesh().draw()?;
    chart.draw_series(LineSeries::new(
        yellowstone_sequence().take(100).enumerate(),
        &BLUE,
    ))?;
    Ok(())
}

fn main() {
    println!("First 30 Yellowstone numbers:");
    for y in yellowstone_sequence().take(30) {
        print!("{} ", y);
    }
    println!();
    match plot_yellowstone("yellowstone.png") {
        Ok(()) => {}
        Err(error) => eprintln!("Error: {}", error),
    }
}
