use std::{io, time, thread};

fn main() {
    println!("How long should we sleep in milliseconds?");

    let mut sleep_string = String::new();

    io::stdin().read_line(&mut sleep_string)
               .expect("Failed to read line");

    let sleep_timer: u64 = sleep_string.trim()
                                       .parse()
                                       .expect("Not an integer");
    let sleep_duration = time::Duration::from_millis(sleep_timer);

    println!("Sleeping...");
    thread::sleep(sleep_duration);
    println!("Awake!");
}
