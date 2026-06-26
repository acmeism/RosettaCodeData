fn main() {
    let x = 5;
    let y = -5;
    let z = -2;
    let one = 1;
    let three = 3;
    let seven = 7;

    let ranges = [
        Range::new(-three, 3i32.pow(3)).step_by(three),
        Range::new(-seven, seven).step_by(x),
        Range::new(555, 550 - y),
        Range::new(22, -28).step_by(-three),
        Range::new(1927, 1939),
        Range::new(x, y).step_by(z),
        Range::new(11i32.pow(x as u32), 11i32.pow(x as u32) + one),
    ];

    let mut prod: i32 = 1;
    let mut sum = 0;

    for j in ranges.into_iter().flatten() {
        sum += j.abs();
        if prod.abs() < 2i32.pow(27) && j != 0 {
            prod *= j;
        }
    }

    println!("sum = {sum}");
    println!("prod = {prod}");
}
