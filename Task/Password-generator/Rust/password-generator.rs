use rand::distributions::Alphanumeric;
use rand::prelude::IteratorRandom;
use rand::{thread_rng, Rng};
use std::iter;
use std::process;
use structopt::StructOpt;
const OTHER_VALUES: &str = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~";

// the core logic that creates our password
fn generate_password(length: u8) -> String {
    // cache thread_rng for better performance
    let mut rng = thread_rng();
    // the Alphanumeric struct provides 3/4
    // of the characters for passwords
    // so we can sample from it
    let mut base_password: Vec<char> = iter::repeat(())
        .map(|()| rng.sample(Alphanumeric))
        .take(length as usize)
        .collect();
    let mut end_range = 10;
    // if the user supplies a password length less than 10
    // we need to adjust the random sample range
    if length < end_range {
        end_range = length;
    }
    // create a random count of how many other characters to add
    let mut to_add = rng.gen_range(1, end_range as usize);
    loop {
        // create an iterator of required other characters
        let special = OTHER_VALUES.chars().choose(&mut rng).unwrap();
        to_add -= 1;
        base_password[to_add] = special;
        if to_add == 0 {
            break;
        }
    }
    base_password.iter().collect()
}

#[derive(StructOpt, Debug)]
#[structopt(name = "password-generator", about = "A simple password generator.")]
struct Opt {
    // make it SECURE by default
    // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
    /// The password length
    #[structopt(default_value = "160")]
    length: u8,
    /// How many passwords to generate
    #[structopt(default_value = "1")]
    count: u8,
}

fn main() {
    // instantiate the options and use them as
    // arguments to our password generator
    let opt = Opt::from_args();
    const MINIMUM_LENGTH: u8 = 30;
    if opt.length < MINIMUM_LENGTH {
        eprintln!(
            "Please provide a password length greater than or equal to {}",
            MINIMUM_LENGTH
        );
        process::exit(1);
    }
    for index in 0..opt.count {
        let password = generate_password(opt.length);
        // do not print a newline after the last password
        match index + 1 == opt.count {
            true => print!("{}", password),
            _ => println!("{}", password),
        };
    }
}
