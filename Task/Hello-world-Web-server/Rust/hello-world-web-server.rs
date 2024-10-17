use std::net::{Shutdown, TcpListener};
use std::thread;
use std::io::Write;

const RESPONSE: &'static [u8] = b"HTTP/1.1 200 OK\r
Content-Type: text/html; charset=UTF-8\r\n\r
<!DOCTYPE html><html><head><title>Bye-bye baby bye-bye</title>
<style>body { background-color: #111 }
h1 { font-size:4cm; text-align: center; color: black;
text-shadow: 0 0 2mm red}</style></head>
<body><h1>Goodbye, world!</h1></body></html>\r";


fn main() {
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();

    for stream in listener.incoming() {
        thread::spawn(move || {
            let mut stream = stream.unwrap();
            match stream.write(RESPONSE) {
                Ok(_) => println!("Response sent!"),
                Err(e) => println!("Failed sending response: {}!", e),
            }
            stream.shutdown(Shutdown::Write).unwrap();
        });
    }
}
