import time

fn main() {
    t := time.Now()
    println(t)                                    // default format YYYY-MM-DD HH:MM:SS
    println(t.custom_format("ddd MMM d HH:mm:ss YYYY")) // some custom format
}
