use chrono::{NaiveDate, ParseError, TimeDelta};
use num_traits::float::FloatConst;

const PHYSICAL_WAVE: i64 = 23;
const EMOTIONAL_WAVE: i64 = 28;
const MENTAL_WAVE: i64 = 33;
const CYCLES: [&str; 3] = ["Physical day ", "Emotional day", "Mental day   "];
const LENGTHS: [i64; 3] = [PHYSICAL_WAVE, EMOTIONAL_WAVE, MENTAL_WAVE];
const QUADRANTS: [[&str; 2]; 4] = [
    ["up and rising", "peak"],
    ["up but falling", "transition"],
    ["down and falling", "valley"],
    ["down but rising", "transition"],
];

/// Parameters assumed to be in YYYY-MM-DD format.
fn biorhythms(birth_date: &str, target_date: &str) -> Result<i64, ParseError> {
    let bd = NaiveDate::parse_from_str(birth_date, "%Y-%m-%d")?;
    let td = NaiveDate::parse_from_str(target_date, "%Y-%m-%d")?;
    let days = (td - bd).num_days();
    println!("Born {}, Target {}", birth_date, target_date);
    println!("Day {}:", days);
    for i in 0..3 {
        let length = LENGTHS[i];
        let cycle = CYCLES[i];
        let position = days % length;
        let quadrant: usize = (4 * position as usize) / length as usize;
        let mut percent = f64::sin(2. * f64::PI() * position as f64 / length as f64);
        percent = percent * 100.0;
        let description: String;
        if percent > 95. {
            description = " peak".to_owned();
        } else if percent < -95. {
            description = " valley".to_owned();
        } else if percent.abs() < 5. {
            description = " critical transition".to_owned();
        } else {
            let days_to_add = (quadrant as i64 + 1) * length / 4 - position;
            let transition = td + TimeDelta::days(days_to_add);
            let trend = QUADRANTS[quadrant][0];
            let next = QUADRANTS[quadrant][1];
            description = format!("{:5.1}% ({}, next {} {})", percent, trend, next, transition);
        }
        println!("{} {:>2} : {}", cycle, position, description);
    }
    println!();
    Ok(0)
}

fn main() {
    let date_pairs = [
        ["1943-03-09", "1972-07-11"],
        ["1809-01-12", "1863-11-19"],
        ["1809-02-12", "1863-11-19"], // correct DOB for Abraham Lincoln
    ];

    for date_pair in date_pairs {
        match biorhythms(date_pair[0], date_pair[1]) {
            Err(_) => println!("Error in biorhythms function parsing {:?}", date_pair),
            _ => {}
        }
    }
}
