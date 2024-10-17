// 20210210 Rust programming solution

extern crate chrono;
use chrono::prelude::*;

fn main() {
   let utc: DateTime<Utc> = Utc::now();
   println!("{}", utc.format("%d/%m/%Y %T"));
}
