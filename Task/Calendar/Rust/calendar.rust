// Assume your binary name is 'calendar'.
// Command line:
// >>$ calendar 2019 150
// First argument: year number.
// Second argument (optional): text area width (in characters).

extern crate chrono;

use std::{env, cmp};
use chrono::{NaiveDate, Datelike};

const MONTH_WIDTH: usize = 22;

fn print_header(months: &[&str]) {
    const DAYS_OF_WEEK: &str = "SU MO TU WE TH FR SA  ";
    println!();
    for m in months {
        print!("{:^20}  ", m);
    }
    println!("\n{}", DAYS_OF_WEEK.repeat(months.len()));
}

fn get_week_str(days: i32, week_num: i32, start_day_of_week: i32) -> Option<String> {
    let start = week_num * 7 - start_day_of_week + 1;
    let end = (week_num + 1) * 7 - start_day_of_week;
    let mut ret = String::with_capacity(MONTH_WIDTH);
    if start > days {
        None
    } else {
        for i in start..(end + 1) {
            if i <= 0 || i > days {
                ret.push_str("  ");
            } else {
                if i < 10 {
                    ret.push_str(" ");
                }
                ret.push_str(&i.to_string());
            }
            ret.push_str(" ");
        }
        ret.push_str(" ");
        Some(ret)
    }
}

fn main() {
    const MONTH_NAMES: [&str; 12] = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY",
                                     "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
    const DEFAULT_TEXT_WIDTH: usize = 100;

    let args: Vec<String> = env::args().collect();
    let year: i32 = args[1].parse().expect("The first argument must be a year");
    let width: usize = if args.len() > 2 {
        cmp::max(MONTH_WIDTH, args[2].parse().expect("The second argument should be text width"))
    } else {
        DEFAULT_TEXT_WIDTH
    };
    let months_in_row = width / MONTH_WIDTH;
    let month_rows = if MONTH_NAMES.len() % months_in_row == 0 {
        MONTH_NAMES.len() / months_in_row
    } else {
        MONTH_NAMES.len() / months_in_row + 1
    };

    let start_days_of_week: Vec<i32> =
        (1..13).map(|x| NaiveDate::from_ymd(year, x, 1).weekday().num_days_from_sunday() as i32).collect();

    let month_days: [i32; 12] = if NaiveDate::from_ymd_opt(year, 2, 29).is_some() {
        [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    } else {
        [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    };

    println!("{year:^w$}", w=width, year=year.to_string());
    for i in 0..month_rows {
        let start = i * months_in_row;
        let end = cmp::min((i + 1) * months_in_row, MONTH_NAMES.len());
        print_header(&MONTH_NAMES[start..end]);
        let mut count = 0;
        let mut row_num = 0;
        while count < months_in_row {
            let mut row_str = String::with_capacity(width);
            for j in start..end {
                match get_week_str(month_days[j], row_num, start_days_of_week[j]) {
                    None => {
                        count += 1;
                        row_str.push_str(&" ".repeat(MONTH_WIDTH));
                    },
                    Some(week_str) => row_str.push_str(&week_str)
                }
            }
            if count < months_in_row {
                println!("{}", row_str);
            }
            row_num += 1;
        }
    }
}
