fn main() {
    use std::io::{self, Write};

    io::stderr().write(b"Goodbye, world!").expect("Could not write to stderr");
    // With some finagling, you can do a formatted string here as well
    let goodbye = "Goodbye";
    let world = "world";
    io::stderr().write(&*format!("{}, {}!", goodbye, world).as_bytes()).expect("Could not write to stderr");
    // Clearly, if you want formatted strings there's no reason not to just use writeln!
}
