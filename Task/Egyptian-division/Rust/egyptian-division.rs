fn egyptian_divide(dividend: u32, divisor: u32) -> (u32, u32) {
    let dividend = dividend as u64;
    let divisor = divisor as u64;

    let pows = (0..32).map(|p| 1 << p);
    let doublings = (0..32).map(|p| divisor << p);

    let (answer, sum) = doublings
        .zip(pows)
        .rev()
        .skip_while(|(i, _)| i > &dividend )
        .fold((0, 0), |(answer, sum), (double, power)| {
            if sum + double < dividend {
                (answer + power, sum + double)
            } else {
                (answer, sum)
            }
        });

    (answer as u32, (dividend - sum) as u32)
}

fn main() {
    let (div, rem) = egyptian_divide(580, 34);
    println!("580 divided by 34 is {} remainder {}", div, rem);
}
