extern crate chrono;

use chrono::prelude::*;

fn main() {
    let years = (2008..2121).filter(|&y| Local.ymd(y, 12, 25).weekday() == Weekday::Sun).collect::<Vec<i32>>();
    println!("Years = {:?}", years);
}
