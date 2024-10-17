extern crate time; // 0.2.16

use time::Date;

fn main() {
    (2000..=2099)
        .filter(|&year| is_long_year(year))
        .for_each(|year| println!("{}", year));
}

fn is_long_year(year: i32) -> bool {
    Date::try_from_ymd(year, 12, 28).map_or(false, |date| date.week() == 53)
}
