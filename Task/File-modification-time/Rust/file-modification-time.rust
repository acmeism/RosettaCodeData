use std::fs;

fn main() -> std::io::Result<()> {
    let metadata = fs::metadata("foo.txt")?;

    if let Ok(time) = metadata.accessed() {
        println!("{:?}", time);
    } else {
        println!("Not supported on this platform");
    }
    Ok(())
}
