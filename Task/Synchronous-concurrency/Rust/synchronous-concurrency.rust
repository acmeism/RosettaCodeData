use std::fs::File;
use std::io::BufRead;
use std::io::BufReader;

use std::sync::mpsc::{channel, sync_channel};
use std::thread;

fn main() {
    // The reader sends lines to the writer via an async channel, so the reader is never blocked.
    let (reader_send, writer_recv) = channel();

    // The writer sends the final count via a blocking channel with bound 0,
    // meaning the buffer is exactly the size of the result.
    let (writer_send, reader_recv) = sync_channel(0);

    // Define the work the reader will do.
    let reader_work = move || {
        let file = File::open("input.txt").expect("Failed to open input.txt");
        let reader = BufReader::new(file);

        for line in reader.lines() {
            match line {
                Ok(msg) => reader_send
                    .send(msg)
                    .expect("Failed to send via the channel"),
                Err(e) => println!("{}", e),
            }
        }

        // Dropping the sender disconnects it and tells the receiver the connection is closed.
        drop(reader_send);

        // Now that we've sent all the lines,
        // block until the writer gives us the final count.
        let count = reader_recv
            .recv()
            .expect("Failed to receive count from printer.");

        println!("{}", count);
    };

    // Define the work the writer will do.
    let writer_work = move || {
        let mut line_count = 0;

        loop {
            match writer_recv.recv() {
                Ok(msg) => {
                    println!("{}", msg);
                    line_count += 1;
                }
                Err(_) => break, // indicates the connection has been closed by the sender.
            }
        }

        // Send the final count back to the reader.
        writer_send
            .send(line_count)
            .expect("Failed to send line count from writer.");

        drop(writer_send);
    };

    // Spawn each as a thread.
    let reader_handle = thread::spawn(reader_work);
    thread::spawn(writer_work);

    reader_handle
        .join()
        .expect("Failed to join the reader thread.");
}
