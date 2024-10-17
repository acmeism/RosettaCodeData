use std::{
    sync::{Arc, Mutex},
    thread,
    time::Duration,
};

fn main() {
    let shared = Arc::new(Mutex::new(String::new()));

    let handle1 = {
        let value = shared.clone();
        thread::spawn(move || {
            for _ in 0..20 {
                thread::sleep(Duration::from_millis(200));
                // The guard is valid until the end of the block
                let mut guard = value.lock().unwrap();
                guard.push_str("A");
                println!("{}", guard);
            }
        })
    };

    let handle2 = {
        let value = shared.clone();
        thread::spawn(move || {
            for _ in 0..20 {
                thread::sleep(Duration::from_millis(300));

                {
                    // Making the guard scope explicit here
                    let mut guard = value.lock().unwrap();
                    guard.push_str("B");
                    println!("{}", guard);
                }
            }
        })
    };

    handle1.join().ok();
    handle2.join().ok();
    shared.lock().ok().map_or((), |it| println!("Done: {}", it));
}
