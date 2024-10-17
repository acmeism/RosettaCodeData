fn median(mut xs: Vec<f64>) -> f64 {
    // sort in ascending order, panic on f64::NaN
    xs.sort_by(|x,y| x.partial_cmp(y).unwrap() );
    let n = xs.len();
    if n % 2 == 0 {
        (xs[n/2] + xs[n/2 - 1]) / 2.0
    } else {
        xs[n/2]
    }
}

fn main() {
    let nums = vec![2.,3.,5.,0.,9.,82.,353.,32.,12.];
    println!("{:?}", median(nums))
}
