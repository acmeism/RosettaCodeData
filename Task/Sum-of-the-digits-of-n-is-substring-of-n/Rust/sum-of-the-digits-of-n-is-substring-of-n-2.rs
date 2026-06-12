// Here is a one-liner version for education
//
fn main() {println!("{:?}", (0..1000).filter(|n|n.to_string().contains(&n.to_string().chars().map(|c| c.to_digit(10).unwrap()).sum::<u32>().to_string())).collect::<Vec<u32>>());}
