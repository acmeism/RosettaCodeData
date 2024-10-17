fn main() {
    let mut sum = 0.0;
    let mut prod = 1;
    let mut recsum = 0.0;
    for i in 1..11{
        sum += i as f32;
        prod *= i;
        recsum += 1.0/(i as f32);
    }
    let avg = sum/10.0;
    let gmean = (prod as f32).powf(0.1);
    let hmean = 10.0/recsum;
    println!("Average: {}, Geometric mean: {}, Harmonic mean: {}", avg, gmean, hmean);
    assert!( ( (avg >= gmean) && (gmean >= hmean) ), "Incorrect calculation");

}
