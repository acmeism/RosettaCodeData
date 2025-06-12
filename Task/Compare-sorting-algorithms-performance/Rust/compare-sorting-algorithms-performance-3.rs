use core::error::Error;
use core::time::Duration;
use std::collections::BTreeMap;
use std::io::{Write, stdout};
use std::time::Instant;

fn run_time(f: fn(&mut [u32]), arr: &mut [u32]) -> Duration {
    let start_time = Instant::now();
    f(arr);
    start_time.elapsed()
}

const LENGTHS: [u32; 30] = [
    1, 2, 3, 4, 6, 10, 14, 21, 31, 46, 68, 100, 146, 215, 316, 464, 681, 1000, 1467, 2154, 3162,
    4641, 6812, 10000, 14677, 21544, 31622, 46415, 68129, 100000,
];

const IDC: [usize; 6] = [0, 5, 11, 17, 23, 29];

fn main() {
    let mut rng = rand::rng();
    let mut metrics: [_; 3] =
        core::array::from_fn(|_| BTreeMap::<&'static str, [Duration; 30]>::new());

    for (i, len) in LENGTHS.iter().enumerate() {
        print!("{len} ");
        stdout().flush().unwrap();

        let one = ones(*len);
        let seq = sequence(*len);
        let ran = random(&mut rng, *len);

        for (algo_name, algo) in ALGOS {
            let (mut a, mut b, mut c) = (one.clone(), seq.clone(), ran.clone());

            metrics[0].entry(algo_name).or_default()[i] = run_time(algo, &mut a);
            metrics[1].entry(algo_name).or_default()[i] = run_time(algo, &mut b);
            metrics[2].entry(algo_name).or_default()[i] = run_time(algo, &mut c);

            debug_assert!(a.is_sorted());
            debug_assert!(b.is_sorted());
            debug_assert!(c.is_sorted());
        }
    }
    println!("...Done");

    println!(
        "\n{:^20} {:>12?}",
        "Data sizes",
        [1, 10, 100, 1_000, 10_000, 100_000]
    );
    println!("\n{:-^20}", "All Ones");
    for (algo_name, run_times) in &mut metrics[0] {
        let powers_of_ten = run_times.get_disjoint_mut(IDC).unwrap();
        println!("{algo_name:^20} {powers_of_ten:>12?}");
    }
    println!("\n{:-^20}", "Ascending");
    for (algo_name, run_times) in &mut metrics[1] {
        let powers_of_ten = run_times.get_disjoint_mut(IDC).unwrap();
        println!("{algo_name:^20} {powers_of_ten:>12?}");
    }
    println!("\n{:-^20}", "Random");
    for (algo_name, run_times) in &mut metrics[2] {
        let powers_of_ten = run_times.get_disjoint_mut(IDC).unwrap();
        println!("{algo_name:^20} {powers_of_ten:>12?}");
    }

    let _ = plot("one", &metrics[0]);
    let _ = plot("sequenced", &metrics[1]);
    let _ = plot("random", &metrics[2]);
}

fn plot(data_type: &str, map: &BTreeMap<&str, [Duration; 30]>) -> Result<(), Box<dyn Error>> {
    use plotters::prelude::*;

    let file_name = format!("{data_type}.png");
    let caption = format!("Sorting algorithms on {data_type} data");

    let image = BitMapBackend::new(&file_name, (800, 600)).into_drawing_area();
    image.fill(&WHITE)?;

    let root = image.margin(10, 10, 10, 10);
    let mut chart = ChartBuilder::on(&root)
        .caption(caption, ("sans-serif", 24).into_font())
        .x_label_area_size(20)
        .y_label_area_size(60)
        .build_cartesian_2d((0..100_000).log_scale(), (0..10_000_000_000).log_scale())?;

    chart
        .configure_mesh()
        .x_desc("Data sizes")
        .y_desc("Sort time")
        .x_labels(10)
        .y_labels(10)
        .y_label_formatter(&|x| format!("{x:e} ns"))
        .draw()?;

    for ((&algo_name, durations), color) in map
        .iter()
        .zip([MAGENTA, RED, GREEN, BLUE, YELLOW, CYAN, BLACK])
    {
        let coordinates = durations
            .iter()
            .enumerate()
            .map(|(i, duration)| (LENGTHS[i], duration.as_nanos() as i128));
        chart
            .draw_series(LineSeries::new(coordinates, color))?
            .label(algo_name)
            .legend(move |(x, y)| PathElement::new(vec![(x, y), (x + 20, y)], color));
    }

    chart
        .configure_series_labels()
        .background_style(WHITE.mix(0.8))
        .border_style(BLACK)
        .draw()?;

    image.present()?;

    Ok(())
}
