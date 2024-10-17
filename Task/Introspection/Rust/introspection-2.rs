use rustc_version::{version_meta, Channel, version, Version};

fn main() {
    // We can check the Rust channel currently being used: stable, nightly, etc.
    match version_meta().unwrap().channel {
        Channel::Stable => {
            println!("Rust Stable");
        }
        Channel::Beta => {
            println!("Rust Beta");
        }
        Channel::Nightly => {
            println!("Rust Nightly");
        }
        Channel::Dev => {
            println!("Rust Dev");
        }
    }

    // We can print the Rust compiler version
    println!("{}",version().unwrap());

    // We can check for a minimum Rust compiler version
    if version().unwrap() >= Version::parse("1.50.0").unwrap() {
        println!("Rust compiler version is ok.");
    } else {
        eprintln!("Rust compiler version is too old. Please update to a more recent version.");
        std::process::exit(1);
    }
}
