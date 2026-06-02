import "std/string.zc"

fn main() {
    let s = String::from("Hello,How,Are,You,Today");
    let words = s.split(',');
    for i in 0..words.length() { print "{words[i]}."; }
    println "\b ";
}
