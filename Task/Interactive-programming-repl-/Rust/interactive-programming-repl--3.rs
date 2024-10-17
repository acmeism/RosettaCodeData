#[macro_use]
extern crate clap;
use clap::App;
fn main() {
    let yaml = load_yaml!("cli.yaml");
    let matches = App::from(yaml).get_matches();

    let str1 = matches.value_of("STRING1").unwrap();
    let str2 = matches.value_of("STRING2").unwrap();
    let str3 = matches.value_of("SEPARATOR").unwrap();

    println!("{:?}", f(&str1, &str2, &str3));
}

fn f<'a>(s1: &'a str, s2: &'a str, sep :&'a str) -> String{
    [s1,sep,sep,s2].iter().map(|x| *x).collect()
}
