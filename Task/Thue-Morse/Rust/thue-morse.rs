const ITERATIONS: usize = 8;

fn neg(sequence: &String) -> String {
    sequence.chars()
        .map(|ch| {
            (1 - ch.to_digit(2).unwrap()).to_string()
        })
        .collect::<String>()
}

fn main() {
    let mut sequence: String = String::from("0");
    for i in 0..ITERATIONS {
        println!("{}: {}", i + 1, sequence);
        sequence = format!("{}{}", sequence, neg(&sequence));
    }
}
