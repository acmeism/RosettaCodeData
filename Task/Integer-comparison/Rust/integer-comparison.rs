use std::io::{self, BufRead};

fn main() {
    let mut reader = io::stdin();
    let mut buffer = String::new();
    let mut lines = reader.lock().lines().take(2);
    let nums: Vec<i32>= lines.map(|string|
        string.unwrap().trim().parse().unwrap()
        ).collect();
    let a: i32 = nums[0];
    let b: i32 = nums[1];
    if a < b {
        println!("{} is less than {}" , a , b)
    } else if a == b {
        println!("{} equals {}" , a , b)
    } else if a > b {
        println!("{} is greater than {}" , a , b)
    };
}
