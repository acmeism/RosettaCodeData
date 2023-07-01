import time
import os

fn main() {
    sec := os.input("Enter number of seconds to sleep: ").i64()
    println("Sleeping…")
    time.sleep(time.Duration(sec * time.second))
    println("Awake!")
}
