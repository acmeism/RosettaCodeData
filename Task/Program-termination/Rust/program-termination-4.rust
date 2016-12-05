use std::thread;

fn main() {
    println!("The program is running");

    thread::spawn(move|| {
        println!("This is the second thread");
        panic!("A runtime panic occured");
    }).join();

    println!("This line should be printed");
}
