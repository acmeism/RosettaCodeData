use std::fs::File;
use std::io::Read;

use reqwest::blocking::Client;
use reqwest::Identity;

fn main() -> std::io::Result<()> {
    let identity = {
        let mut buf = Vec::new();

        // Downloaded from https://badssl.com/certs/badssl.com-client.p12
        File::open("badssl.com-client.p12")?.read_to_end(&mut buf)?;

        // Password is badssl.com
        Identity::from_pkcs12_der(&buf, "badssl.com").unwrap()
    };

    let client = Client::builder().identity(identity).build().unwrap();
    let response = client.get("https://client.badssl.com/").send().unwrap();

    if !response.status().is_success() {
        eprintln!("HTTP error requesting URL: {}", response.status());
    }

    println!("Got response from server: {}", response.text().unwrap());

    Ok(())
}
