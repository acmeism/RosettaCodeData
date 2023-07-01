import os

fn main() {
    s := os.input('Enter string').int()
    if s == 75000 {
        println('good')
    } else {
        println('bad')
    }
}
