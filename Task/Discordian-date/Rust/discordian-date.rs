extern crate chrono;

use chrono::NaiveDate;
use std::str::FromStr;

fn main() {
    let date = std::env::args().nth(1).expect("Please provide a YYYY-MM-DD date.");
    println!("{} is {}", date, NaiveDate::from_str(&date).unwrap().to_poee());
}

// The necessary constants for the seasons, weekdays, and holydays.
const APOSTLES: [&str; 5] = ["Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"];
const HOLYDAYS: [&str; 5] = ["Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"];
const SEASONS: [&str; 5] = ["Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"];
const WEEKDAYS: [&str; 5] = ["Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"];

// The necessary constants for the conversion.
const APOSTLE_HOLYDAY: usize = 5;
const CURSE_OF_GREYFACE: i32 = 1166;
const SEASON_DAYS: usize = 73;
const SEASON_HOLYDAY: usize = 50;
const ST_TIBS_DAY: usize = 59;
const WEEK_DAYS: usize = 5;

// This extends the `Datelike` trait of Rust's Chrono crate with a method that
// prints any Datelike type as a String.
impl<T: Datelike> DiscordianDate for T {}
pub trait DiscordianDate: Datelike {
    fn to_poee(&self) -> String {
        let day = self.ordinal0() as usize;
        let leap = self.year() % 4 == 0 && self.year() % 100 != 0 || self.year() % 400 == 0;
        let year = self.year() + CURSE_OF_GREYFACE;

        if leap && day == ST_TIBS_DAY { return format!("St. Tib's Day, in the YOLD {}", year); }

        let day_offset = if leap && day > ST_TIBS_DAY { day - 1 } else { day };

        let day_of_season = day_offset % SEASON_DAYS + 1;

        let season = SEASONS[day_offset / SEASON_DAYS];
        let weekday = WEEKDAYS[day_offset % WEEK_DAYS];

        let holiday = if day_of_season == APOSTLE_HOLYDAY {
            format!("\nCelebrate {}", APOSTLES[day_offset / SEASON_DAYS])
        } else if day_of_season == SEASON_HOLYDAY {
            format!("\nCelebrate {}", HOLYDAYS[day_offset / SEASON_DAYS])
        } else {
            String::with_capacity(0)
        };

        format!("{}, the {} day of {} in the YOLD {}{}",
            weekday, ordinalize(day_of_season), season, year, holiday)
    }
}

/// A helper function to ordinalize a numeral.
fn ordinalize(num: usize) -> String {
    let s = format!("{}", num);

    let suffix = if s.ends_with('1') && !s.ends_with("11") {
        "st"
    } else if s.ends_with('2') && !s.ends_with("12") {
        "nd"
    } else if s.ends_with('3') && !s.ends_with("13") {
        "rd"
    } else {
        "th"
    };

    format!("{}{}", s, suffix)
}
