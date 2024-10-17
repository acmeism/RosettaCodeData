fn main() {
    let s = "Hello,How,Are,You,Today";
    let tokens: Vec<&str> = s.split(",").collect();
    println!("{}", tokens.join("."));
}
