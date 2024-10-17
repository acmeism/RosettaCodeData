use std::env::args;
use time::{Date, Duration};

fn main() {
    let year = args().nth(1).unwrap().parse::<i32>().unwrap();
    (1..=12)
        .map(|month| Date::try_from_ymd(year + month / 12, ((month % 12) + 1) as u8, 1))
        .filter_map(|date| date.ok())
        .for_each(|date| {
            let days_back =
                Duration::days(((date.weekday().number_from_sunday() as i64 + 5) % 7) + 1);
            println!("{}", date - days_back);
        });
}
