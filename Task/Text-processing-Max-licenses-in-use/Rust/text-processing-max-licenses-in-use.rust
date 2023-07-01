type Timestamp = String;

fn compute_usage<R, S, E>(lines: R) -> Result<(u32, Vec<Timestamp>), E>
where
    S: AsRef<str>,
    R: Iterator<Item = Result<S, E>>,
{
    let mut timestamps = Vec::new();
    let mut current = 0;
    let mut maximum = 0;

    for line in lines {
        let line = line?;
        let line = line.as_ref();

        if line.starts_with("License IN") {
            current -= 1;
        } else if line.starts_with("License OUT") {
            current += 1;

            if maximum <= current {
                let date = line.split_whitespace().nth(3).unwrap().to_string();

                if maximum < current {
                    maximum = current;
                    timestamps.clear();
                }

                timestamps.push(date);
            }
        }
    }

    Ok((maximum, timestamps))
}

fn main() -> std::io::Result<()> {
    use std::io::{BufRead, BufReader};
    let file = std::fs::OpenOptions::new().read(true).open("mlijobs.txt")?;
    let (max, timestamps) = compute_usage(BufReader::new(file).lines())?;
    println!("Maximum licenses out: {}", max);
    println!("At time(s): {:?}", timestamps);
    Ok(())
}
