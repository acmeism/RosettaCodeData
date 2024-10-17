//! Rust rosetta example for normal distribution
use math::{histogram::Histogram, traits::ToIterator};
use rand;
use rand_distr::{Distribution, Normal};

/// Returns the mean of the provided samples
///
/// ## Arguments
/// * data -- reference to float32 array
fn mean(data: &[f32]) -> Option<f32> {
    let sum: f32 = data.iter().sum();
    Some(sum / data.len() as f32)
}

/// Returns standard deviation of the provided samples
///
/// ## Arguments
/// * data -- reference to float32 array
fn standard_deviation(data: &[f32]) -> Option<f32> {
    let mean = mean(data).expect("invalid mean");
    let sum = data.iter().fold(0.0, |acc, &x| acc + (x - mean).powi(2));
    Some((sum / data.len() as f32).sqrt())
}

/// Prints a histogram in the shell
///
/// ## Arguments
/// * data -- reference to float32 array
/// * maxwidth -- the maxwidth of the histogram in # of characters
/// * bincount -- number of bins in the histogram
/// * ch -- character used to plot the graph
fn print_histogram(data: &[f32], maxwidth: usize, bincount: usize, ch: char) {
    let min_val = data.iter().cloned().fold(f32::NAN, f32::min);
    let max_val = data.iter().cloned().fold(f32::NAN, f32::max);
    let histogram = Histogram::new(Some(&data.to_vec()), bincount, min_val, max_val).unwrap();
    let max_bin_value = histogram.get_counters().iter().max().unwrap();
    println!();
    for x in histogram.to_iter() {
        let (bin_min, bin_max, freq) = x;
        let bar_width = (((freq as f64) / (*max_bin_value as f64)) * (maxwidth as f64)) as u32;
        let bar_as_string = (1..bar_width).fold(String::new(), |b, _| b + &ch.to_string());
        println!(
            "({:>6},{:>6}) |{} {:.2}%",
            format!("{:.2}", bin_min),
            format!("{:.2}", bin_max),
            bar_as_string,
            (freq as f64) * 100.0 / (data.len() as f64)
        );
    }
    println!();
}

/// Runs the demo to generate normal distribution of three different sample sizes
fn main() {
    let expected_mean: f32 = 0.0;
    let expected_std_deviation: f32 = 4.0;
    let normal = Normal::new(expected_mean, expected_std_deviation).unwrap();

    let mut rng = rand::thread_rng();
    for &number_of_samples in &[1000, 10_000, 1_000_000] {
        let data: Vec<f32> = normal
            .sample_iter(&mut rng)
            .take(number_of_samples)
            .collect();
        println!("Statistics for sample size {}:", number_of_samples);
        println!("\tMean: {:?}", mean(&data).expect("invalid mean"));
        println!(
            "\tStandard deviation: {:?}",
            standard_deviation(&data).expect("invalid standard deviation")
        );
        print_histogram(&data, 80, 40, '-');
    }
}
