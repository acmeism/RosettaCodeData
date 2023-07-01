fn sd_creator() -> impl FnMut(f64) -> f64 {
    let mut n = 0.0;
    let mut sum = 0.0;
    let mut sum_sq = 0.0;
    move |x| {
        sum += x;
        sum_sq += x*x;
        n += 1.0;
        (sum_sq / n - sum * sum / n / n).sqrt()
    }
}

fn main() {
    let nums = [2, 4, 4, 4, 5, 5, 7, 9];

    let mut sd_acc = sd_creator();
    for num in nums.iter() {
        println!("{}", sd_acc(*num as f64));
    }
}
