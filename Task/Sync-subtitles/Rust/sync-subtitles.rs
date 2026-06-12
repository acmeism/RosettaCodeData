use chrono::{NaiveTime, TimeDelta};
use lazy_static::lazy_static;
use regex::Regex;
use std::env;
use std::fs::File;
use std::io::{self, BufRead};
use std::io::{stdout, Write};
use std::path::Path;

lazy_static! {
    static ref RE: Regex =
        Regex::new(r"(\d{2}:\d{2}:\d{2},\d{3})\s+-->\s+(\d{2}:\d{2}:\d{2},\d{3})").unwrap();
    static ref FORMAT: String = String::from("%H:%M:%S,%3f");
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();

    match args.len() {
        3 => {
            let path = &args[1];
            let secs: i64 = args[2].parse()?;
            let mut lock = stdout().lock();
            for line in sync_file(path, secs)? {
                writeln!(lock, "{line}").unwrap()
            }
        }
        _ => println!("usage: subrip-sync <filename> <seconds>"),
    }

    Ok(())
}

fn sync_file<P>(path: P, secs: i64) -> Result<impl Iterator<Item = String>, io::Error>
where
    P: AsRef<Path>,
{
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);
    Ok(sync_lines(reader.lines().flatten(), secs))
}

fn sync_lines(lines: impl Iterator<Item = String>, secs: i64) -> impl Iterator<Item = String> {
    let delta = TimeDelta::new(secs, 0).unwrap();
    lines.map(move |line| {
        if let Some(groups) = RE.captures(&line) {
            format(&groups[1], &groups[2], &delta)
        } else {
            line
        }
    })
}

fn format(start: &str, stop: &str, delta: &TimeDelta) -> String {
    format!(
        "{} --> {}",
        (NaiveTime::parse_from_str(start, &FORMAT).unwrap() + *delta).format(&FORMAT),
        (NaiveTime::parse_from_str(stop, &FORMAT).unwrap() + *delta).format(&FORMAT)
    )
}
