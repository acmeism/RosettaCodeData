use std::fs;
use std::io;

fn main() {
    match run() {
        Ok(()) => {}
        Err(e) => eprintln!("Error: {}", e),
    }
}

fn run() -> Result<(), Box<dyn std::error::Error>> {
    let proc_stat_line = proc_stat()?;
    let percentages = parse_utilization(&proc_stat_line)?;

    println!("{:<10} {:.2}%", "idle", percentages.0 * 100.0);
    println!("{:<10} {:.2}%", "not-idle", percentages.1 * 100.0);

    Ok(())
}

fn proc_stat() -> Result<String, io::Error> {
    let data = fs::read_to_string("/proc/stat")?;
    Ok(data.lines().next().unwrap_or("").to_string())
}

/// Parse the /proc/stat line to extract CPU utilization percentages
///
/// # Arguments
/// * `line` - The first line from /proc/stat
///
/// # Returns
/// A tuple containing (idle_percentage, not_idle_percentage)
fn parse_utilization(line: &str) -> Result<(f64, f64), Box<dyn std::error::Error>> {
    // Remove "cpu " prefix and trim whitespace
    let values_str = line.strip_prefix("cpu ").unwrap_or(line).trim_start();

    let mut total = 0u64;
    let mut idle = 0u64;

    for (index, value_str) in values_str.split_whitespace().enumerate() {
        let num: u64 = value_str.parse()?;

        if index == 3 {
            idle = num;
        }
        total += num;
    }

    if total == 0 {
        return Err("Total CPU time is zero".into());
    }

    let idle_percentage = idle as f64 / total as f64;
    let not_idle_percentage = 1.0 - idle_percentage;

    Ok((idle_percentage, not_idle_percentage))
}
