extern crate rand;

use rand::{ThreadRng, thread_rng};
use rand::distributions::{IndependentSample, Range};
use std::collections::HashSet;
use std::env;
use std::process;

fn help() {
    println!("usage: average_loop_length <max_N> <trials>");
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut max_n: u32 = 20;
    let mut trials: u32 = 1000;

    match args.len() {
        1 => {}
        3 => {
            max_n = args[1].parse::<u32>().unwrap();
            trials = args[2].parse::<u32>().unwrap();
        }
        _ => {
            help();
            process::exit(0);
        }
    }

    let mut rng = thread_rng();

    println!(" N    average    analytical    (error)");
    println!("===  =========  ============  =========");
    for n in 1..(max_n + 1) {
        let the_analytical = analytical(n);
        let the_empirical = empirical(n, trials, &mut rng);
        println!(" {:>2}     {:3.4}        {:3.4}  ( {:>+1.2}%)",
                 n,
                 the_empirical,
                 the_analytical,
                 100f64 * (the_empirical / the_analytical - 1f64));
    }
}

fn factorial(n: u32) -> f64 {
    (1..n + 1).fold(1f64, |p, n| p * n as f64)
}

fn analytical(n: u32) -> f64 {
    let sum: f64 = (1..(n + 1))
                       .map(|i| factorial(n) / (n as f64).powi(i as i32) / factorial(n - i))
                       .fold(0f64, |a, v| a + v);
    sum
}

fn empirical(n: u32, trials: u32, rng: &mut ThreadRng) -> f64 {
    let sum: f64 = (0..trials)
                       .map(|_t| {
                           let mut item = 1u32;
                           let mut seen = HashSet::new();
                           let range = Range::new(1u32, n + 1);

                           for step in 0..n {
                               if seen.contains(&item) {
                                   return step as f64;
                               }
                               seen.insert(item);
                               item = range.ind_sample(rng);
                           }
                           n as f64
                       })
                       .fold(0f64, |a, v| a + v);
    sum / trials as f64
}
