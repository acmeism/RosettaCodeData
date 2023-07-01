// 202100302 Rust programming solution

use std::io::Read;
use regex::Regex;

fn main() {

   let client   = reqwest::blocking::Client::new();
   let site     = "https://www.utctime.net/";
   let mut res  = client.get(site).send().unwrap();
   let mut body = String::new();

   res.read_to_string(&mut body).unwrap();

   let re   = Regex::new(r#"<td>UTC</td><td>(.*Z)</td>"#).unwrap();
   let caps = re.captures(&body).unwrap();

   println!("Result : {:?}", caps.get(1).unwrap().as_str());
}
