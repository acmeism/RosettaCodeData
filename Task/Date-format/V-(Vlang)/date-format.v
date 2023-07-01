import time

fn main() {
    println(time.now().custom_format("YYYY-MM-DD"))
    println(time.now().custom_format("dddd, MMMM D, YYYY"))
}
