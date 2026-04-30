use chrono::{Datelike, Duration, NaiveDate};

const MONTHS: [&str; 13] = [
    "Vendemiaire", "Brumaire", "Frimaire", "Nivose", "Pluviose", "Ventose", "Germinal",
    "Floreal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide",
];

const SANSCULOTTIDES: [&str; 6] = [
    "Fete de la vertu", "Fete du genie", "Fete du travail",
    "Fete de l'opinion", "Fete des recompenses", "Fete de la Revolution",
];

const GREGORIAN_MONTHS: [&str; 12] = [
    "January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December",
];

const INTRODUCTION_DATE: NaiveDate = match NaiveDate::from_ymd_opt(1792, 9, 22) {
    Some(date) => date,
    None => panic!("Invalid introduction date"),
};

const TERMINATION_DATE: NaiveDate = match NaiveDate::from_ymd_opt(1805, 12, 31) {
    Some(date) => date,
    None => panic!("Invalid termination date"),
};

#[derive(Debug, Clone, Copy)]
struct FrenchRcDate {
    year: u32,
    month: u32,
    day: u32,
}

fn split_string(text: &str, delimiter: char) -> Vec<&str> {
    text.split(delimiter).collect()
}

fn index_of(vec: &[&str], element: &str) -> u32 {
    vec.iter()
        .position(|&x| x == element)
        .map(|i| i as u32)
        .unwrap_or_else(|| panic!("Element not found: {}", element))
}

fn additional_days_for_year(year: u32) -> u32 {
    if year > 11 {
        3
    } else if year > 7 {
        2
    } else if year > 3 {
        1
    } else {
        0
    }
}

fn to_french_rc_date_string(french_rc_date: FrenchRcDate) -> String {
    if french_rc_date.month < 13 {
        format!(
            "{} {} {}",
            french_rc_date.day, MONTHS[(french_rc_date.month - 1) as usize], french_rc_date.year
        )
    } else {
        format!(
            "{} {}",
            SANSCULOTTIDES[(french_rc_date.day - 1) as usize], french_rc_date.year
        )
    }
}

fn to_gregorian_date_string(gregorian_date: NaiveDate) -> String {
    let year = gregorian_date.year();
    let month = gregorian_date.month() as usize;
    let day = gregorian_date.day();
    let month_string = GREGORIAN_MONTHS[month - 1];
    format!("{} {} {}", day, month_string, year)
}

fn parse_gregorian_date(gregorian_string: &str) -> NaiveDate {
    let splits: Vec<&str> = split_string(gregorian_string, ' ');
    let day: u32 = splits[0].parse().expect("Invalid day");
    let month = index_of(&GREGORIAN_MONTHS, splits[1]) + 1;
    let year: i32 = splits[2].parse().expect("Invalid year");

    NaiveDate::from_ymd_opt(year, month, day)
        .unwrap_or_else(|| panic!("Invalid Gregorian date: {}", gregorian_string))
}

fn parse_french_rc_date(french_rc_date: &str) -> FrenchRcDate {
    let splits: Vec<&str> = split_string(french_rc_date, ' ');
    if splits.len() == 3 {
        let day: u32 = splits[0].parse().expect("Invalid day");
        let month = index_of(&MONTHS, splits[1]) + 1;
        let year: u32 = splits[2].parse().expect("Invalid year");
        FrenchRcDate { year, month, day }
    } else {
        let year_string = splits[splits.len() - 1];
        let year: u32 = year_string.parse().expect("Invalid year");
        let sansculottides_day = &french_rc_date[..french_rc_date.len() - year_string.len() - 1];
        let day = index_of(&SANSCULOTTIDES, sansculottides_day) + 1;
        FrenchRcDate {
            year,
            month: 13,
            day,
        }
    }
}

fn to_french_rc_date(gregorian_date: NaiveDate) -> FrenchRcDate {
    let days_after = (gregorian_date - INTRODUCTION_DATE).num_days();
    let days_before = (TERMINATION_DATE - gregorian_date).num_days();

    if days_after < 0 || days_before < 0 {
        panic!("French Republican Calendar date out of range.");
    }

    let mut year = (days_after + 366) / 365;
    let mut days = (days_after + 366) % 365 - additional_days_for_year(year as u32) as i64;

    if days == 0 {
        year -= 1;
        days += 366;
    }

    if days < 361 {
        FrenchRcDate {
            year: year as u32,
            month: (days / 30 + 1) as u32,
            day: (days % 30) as u32,
        }
    } else {
        FrenchRcDate {
            year: year as u32,
            month: 13,
            day: (days - 360) as u32,
        }
    }
}

fn to_gregorian_date(french_rc_date: FrenchRcDate) -> NaiveDate {
    let days = (french_rc_date.year - 1) * 365
        + additional_days_for_year(french_rc_date.year)
        + (french_rc_date.month - 1) * 30
        + french_rc_date.day
        - 1;
    INTRODUCTION_DATE + Duration::days(days as i64)
}

fn main() {
    let gregorian_strings = vec![
        "22 September 1792",
        "20 May 1795",
        "15 July 1799",
        "23 September 1803",
        "31 December 1805",
    ];

    let mut french_rc_strings = Vec::new();

    for gregorian_string in &gregorian_strings {
        let gregorian_date = parse_gregorian_date(gregorian_string);
        let french_rc_date = to_french_rc_date(gregorian_date);
        let french_rc_date_string = to_french_rc_date_string(french_rc_date);
        french_rc_strings.push(french_rc_date_string.clone());
        println!("{} => {}", gregorian_string, french_rc_date_string);
    }

    println!();

    for french_rc_string in &french_rc_strings {
        let french_rc_date = parse_french_rc_date(french_rc_string);
        let gregorian_date = to_gregorian_date(french_rc_date);
        let gregorian_date_string = to_gregorian_date_string(gregorian_date);
        println!("{} => {}", french_rc_string, gregorian_date_string);
    }
}
