use std::net::{TcpListener, TcpStream};
use std::io::{BufReader, BufRead, Write};
use std::thread;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:12321").unwrap();
    println!("server is running on 127.0.0.1:12321 ...");

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        thread::spawn(move || handle_client(stream));
    }
}

fn handle_client(stream: TcpStream) {
    let mut stream = BufReader::new(stream);
    loop {
        let mut buf = String::new();
        if stream.read_line(&mut buf).is_err() {
            break;
        }
        stream
            .get_ref()
            .write(buf.as_bytes())
            .unwrap();
    }
}
