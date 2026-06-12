// [dependencies]
// chrono = "0.4"

use chrono::NaiveDate;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 3 {
        eprintln!("usage: {} start-date end-date", args[0]);
        std::process::exit(1);
    }
    if let Ok(start_date) = NaiveDate::parse_from_str(&args[1], "%F") {
        if let Ok(end_date) = NaiveDate::parse_from_str(&args[2], "%F") {
            let d = end_date.signed_duration_since(start_date);
            println!("{}", d.num_days());
        } else {
            eprintln!("Can't parse end date");
            std::process::exit(1);
        }
    } else {
        eprintln!("Can't parse start date");
        std::process::exit(1);
    }
}
