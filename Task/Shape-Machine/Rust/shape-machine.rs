fn converge(start_value: f64) -> (f64, i32) {
    let mut current = start_value;
    let mut previous = start_value + 5.0;
    let mut i: i32 = 0;
    loop {
        if (previous - current).abs() <= f64::EPSILON {
            return (current, i);
        }
        previous = current;
        current += 3.0;
        current *= 0.86;
        i += 1;
    }
}

fn main() {
    let start_value = 4.0;
    let (end_value, iterations) = converge(start_value);
    println!(
        "\n{} --> {} to epsilon of {} after {} repetitions\n",
        start_value,
        end_value,
        f64::EPSILON,
        iterations
    );
}
