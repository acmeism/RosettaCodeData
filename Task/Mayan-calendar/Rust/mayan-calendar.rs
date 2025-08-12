use chrono::{NaiveDate, Duration};

const TZOLKIN: [&str; 20] = [
    "Imix'", "Ik'", "Ak'bal", "K'an", "Chikchan", "Kimi", "Manik'",
    "Lamat", "Muluk", "Ok", "Chuwen", "Eb", "Ben", "Hix", "Men",
    "K'ib'", "Kaban", "Etz'nab'", "Kawak", "Ajaw"
];

const HAAB: [&str; 19] = [
    "Pop", "Wo'", "Sip", "Sotz'", "Sek", "Xul", "Yaxk'in", "Mol",
    "Ch'en", "Yax", "Sak'", "Keh", "Mak", "K'ank'in", "Muwan",
    "Pax", "K'ayab", "Kumk'u", "Wayeb'"
];

fn positive_modulus(base: i32, modulus: i32) -> i32 {
    let result = base % modulus;
    if result < 0 {
        result + modulus
    } else {
        result
    }
}

fn create_date(iso_date: &str) -> NaiveDate {
    let year: i32 = iso_date[0..4].parse().unwrap();
    let month: u32 = iso_date[5..7].parse().unwrap();
    let day: u32 = iso_date[8..10].parse().unwrap();

    NaiveDate::from_ymd_opt(year, month, day).unwrap()
}

fn days_per_mayan_month(month: &str) -> i32 {
    if month == "Wayeb'" { 5 } else { 20 }
}

fn tzolkin(gregorian: &NaiveDate) -> String {
    let creation_tzolkin = create_date("2012-12-21");
    let days_between = (*gregorian - creation_tzolkin).num_days() as i32;

    let mut remainder = positive_modulus(days_between, 13);
    remainder += if remainder <= 9 { 4 } else { -9 };

    let tzolkin_name = TZOLKIN[positive_modulus(days_between - 1, 20) as usize];
    format!("{} {}", remainder, tzolkin_name)
}

fn haab(gregorian: &NaiveDate) -> String {
    let zero_haab = create_date("2019-04-02");
    let days_between = (*gregorian - zero_haab).num_days() as i32;

    let remainder = positive_modulus(days_between, 365);
    let month = HAAB[positive_modulus(remainder + 1, 20) as usize];
    let day_of_month = remainder % 20 + 1;

    if day_of_month < days_per_mayan_month(month) {
        format!("{} {}", day_of_month, month)
    } else {
        format!("Chum {}", month)
    }
}

fn long_count(gregorian: &NaiveDate) -> String {
    let creation_tzolkin = create_date("2012-12-21");
    let mut days_between = (*gregorian - creation_tzolkin).num_days() as i32 + 13 * 360 * 400;

    let baktun = positive_modulus(days_between, 360 * 400);
    days_between %= 360 * 400;
    let katun = days_between / (20 * 360);
    days_between %= 20 * 360;
    let tun = days_between / 360;
    days_between %= 360;
    let winal = days_between / 20;
    let kin = days_between % 20;

    let numbers = [baktun, katun, tun, winal, kin];
    let mut result = String::new();

    for number in numbers {
        let value = if number <= 9 {
            format!("0{}.", number)
        } else {
            format!("{}.", number)
        };
        result.push_str(&value);
    }

    // Remove the last dot
    result.pop();
    result
}

fn lords_of_the_night(gregorian: &NaiveDate) -> String {
    let creation_tzolkin = create_date("2012-12-21");
    let days_between = (*gregorian - creation_tzolkin).num_days() as i32;
    let remainder = days_between % 9;

    let g_number = if remainder <= 0 { remainder + 9 } else { remainder };
    format!("G{}", g_number)
}

fn main() {
    let iso_dates = [
        "2004-06-19", "2012-12-18", "2012-12-21", "2019-01-19",
        "2019-03-27", "2020-02-29", "2020-03-01", "2071-05-16", "2020-02-02"
    ];

    println!("Gregorian      Long Count         Tzolk'in    Haab'         Lords of the Night");
    println!("------------------------------------------------------------------------------");

    for iso_date in &iso_dates {
        let date = create_date(iso_date);

        println!("{:<15}{:<19}{:<12}{:<18}{}",
            iso_date,
            long_count(&date),
            tzolkin(&date),
            haab(&date),
            lords_of_the_night(&date)
        );
    }
}
