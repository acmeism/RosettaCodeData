//cargo-deps: hyper="0.6"
// The above line can be used with cargo-script which makes cargo's dependency handling more convenient for small programs
extern crate hyper;

use std::io::Read;
use hyper::client::Client;

fn main() {
    let client = Client::new();
    let mut resp = client.get("http://rosettacode.org").send().unwrap();
    let mut body = String::new();
    resp.read_to_string(&mut body).unwrap();
    println!("{}", body);
}
