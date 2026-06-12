use std::{io, process::Command};

fn main() -> io::Result<()> {
    let duration = 5;
    let frequency = 220;

    let cmd = Command::new("play")
        .arg("-n")
        .arg("synth")
        .arg(duration.to_string())
        .arg("sine")
        .arg(frequency.to_string())
        .spawn();

    let status = cmd?.wait()?;
    if !status.success() {
        eprintln!("Play failed. Status: {}", status);
        std::process::exit(1);
    }
    Ok(())
}
