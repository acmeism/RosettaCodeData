fn main() {
    println!("Sum: {}", (1..10).fold(0, |acc, n| acc + n));
    println!("Product: {}", (1..10).fold(1, |acc, n| acc * n));
    let chars = ['a', 'b', 'c', 'd', 'e'];
    println!("Concatenation: {}",
             chars.iter().map(|&c| (c as u8 + 1) as char).collect::<String>());
}
