fn is_harshad (n : u32) -> bool {
    let sum_digits = n.to_string()
                      .chars()
                      .map(|c| c.to_digit(10).unwrap())
                      .fold(0, |a, b| a+b);
    n % sum_digits == 0
}

fn main() {
    for i in (1u32..).filter(|num| is_harshad(*num)).take(20) {
        println!("Harshad : {}", i);
    }
    for i in (1_001u32..).filter(|num| is_harshad(*num)).take(1) {
        println!("First Harshad bigger than 1_000 : {}", i);
    }
}
