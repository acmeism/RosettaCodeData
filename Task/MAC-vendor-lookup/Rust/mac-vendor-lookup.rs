extern crate reqwest;
extern crate trpl;

use std::{thread, time};

async fn get_vendor(mac: &str) -> Option<String> {
    let mut url = String::from("http://api.macvendors.com/");
    url.push_str(mac);
    let url_ref = &url;
    match reqwest::get(url_ref).await {
        Ok(res) => match res.text().await {
            Ok(text) => {
                if text.contains("Not Found") {
                    Some("N/A".to_string())
                } else {
                    Some(text)
                }
            }
            Err(e) => {
                println!("{:?}", e);
                None
            }
        },
        Err(e) => {
            println!("{:?}", e);
            None
        }
    }
}

fn main() {
    let duration = time::Duration::from_millis(1000);
    trpl::block_on(async {
        match get_vendor("88:53:2E:67:07:BE").await {
            None => println!("Error!"),
            Some(text) => println!("{}", text),
        }
    });
    thread::sleep(duration);
    trpl::block_on(async {
        match get_vendor("FC:FB:FB:01:FA:21").await {
            None => println!("Error!"),
            Some(text) => println!("{}", text),
        }
    });
    thread::sleep(duration);
    trpl::block_on(async {
        match get_vendor("FC-A1-3E").await {
            None => println!("Error!"),
            Some(text) => println!("{}", text),
        }
    });
    thread::sleep(duration);
    trpl::block_on(async {
        match get_vendor("abcdefg").await {
            None => println!("Error!"),
            Some(text) => println!("{}", text),
        }
    });
}
