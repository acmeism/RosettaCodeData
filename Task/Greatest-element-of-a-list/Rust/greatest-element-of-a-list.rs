fn main() {
    let nums = [1,2,39,34,20];
    println!("{:?}", nums.iter().max());
    println!("{}", nums.iter().max().unwrap());
}
