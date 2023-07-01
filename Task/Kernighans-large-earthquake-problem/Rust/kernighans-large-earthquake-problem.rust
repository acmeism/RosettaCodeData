fn main() -> Result<(), Box<dyn std::error::Error>> {
    use std::io::{BufRead, BufReader};

    for line in BufReader::new(std::fs::OpenOptions::new().read(true).open("data.txt")?).lines() {
        let line = line?;

        let magnitude = line
            .split_whitespace()
            .nth(2)
            .and_then(|it| it.parse::<f32>().ok())
            .ok_or_else(|| format!("Could not parse scale: {}", line))?;

        if magnitude > 6.0 {
            println!("{}", line);
        }
    }

    Ok(())
}
