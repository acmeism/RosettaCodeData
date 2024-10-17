fn multi_hello() -> (&'static str, i32) {
    ("Hello",42)
}

fn main() {
    let (str,num)=multi_hello();
    println!("{},{}",str,num);
}
