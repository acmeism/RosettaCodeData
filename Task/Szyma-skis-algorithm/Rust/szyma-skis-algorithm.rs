use std::collections::HashMap;
use std::sync::{Arc, Mutex, Condvar};
use std::thread;
use std::time::Duration;
use rand::Rng; // Import the Rng trait
use crossbeam::thread::scope; // Crossbeam for easier thread management. Add crossbeam = "0.8" to Cargo.toml

// Define constants for state representation
const OUTSIDE: i32 = 0;
const WAITING_ROOM: i32 = 1;
const DOORWAY: i32 = 3;
const WAITING_FOR_OTHERS: i32 = 2;
const IN_CRITICAL_SECTION: i32 = 4;


fn main() {
    test_szymanski(20);
}

fn run_szymanski(id: i32, all_szy: Arc<Vec<i32>>, dict: Arc<(Mutex<HashMap<i32, i32>>, Condvar)>, critical_value: Arc<Mutex<i32>>) {
    let others: Vec<i32> = all_szy.iter().filter(|&t| *t != id).cloned().collect();

    // Standing outside waiting room
    {
        let (lock, cvar) = &*dict;
        let mut flags = lock.lock().unwrap();
        flags.insert(id, WAITING_ROOM);
        cvar.notify_all();
    }

    // Wait until no other process is in or passing through the doorway.
    while others.iter().any(|&t| {
        let (lock, _) = &*dict;
        let flags = lock.lock().unwrap();
        flags.get(&t).map_or(false, |&flag| flag >= DOORWAY)
    }) {
        thread::yield_now();
    }

    // Standing in doorway
    {
        let (lock, cvar) = &*dict;
        let mut flags = lock.lock().unwrap();
        flags.insert(id, DOORWAY);
        cvar.notify_all();
    }

    // Check if other processes are still waiting
    if others.iter().any(|&t| {
        let (lock, _) = &*dict;
        let flags = lock.lock().unwrap();
        flags.get(&t).map_or(false, |&flag| flag == WAITING_ROOM)
    }) {
        // Waiting for other processes to enter
        {
            let (lock, cvar) = &*dict;
            let mut flags = lock.lock().unwrap();
            flags.insert(id, WAITING_FOR_OTHERS);
            cvar.notify_all();
        }


        // Wait for other processes to close the door
        while !others.iter().any(|&t| {
            let (lock, _) = &*dict;
            let flags = lock.lock().unwrap();
            flags.get(&t).map_or(false, |&flag| flag == IN_CRITICAL_SECTION)
        }) {
            thread::yield_now();
        }
    }

    // The door is closed
    {
        let (lock, cvar) = &*dict;
        let mut flags = lock.lock().unwrap();
        flags.insert(id, IN_CRITICAL_SECTION);
        cvar.notify_all();
    }

    // Wait for lower numbered processes
    for &t in &others {
        if t >= id {
            continue;
        }
        while {
            let (lock, _) = &*dict;
            let flags = lock.lock().unwrap();
            flags.get(&t).map_or(false, |&flag| flag > WAITING_ROOM)
        } {
            thread::yield_now();
        }
    }

    // Critical section
    {
        let mut critical_value_guard = critical_value.lock().unwrap();
        *critical_value_guard += id * 3;
        *critical_value_guard /= 2;
        println!("Thread {} changed the critical value to {}.", id, *critical_value_guard);
    }

    // Exit protocol
    for &t in &others {
        if t <= id {
            continue;
        }

        while {
            let (lock, _) = &*dict;
            let flags = lock.lock().unwrap();
            flags.get(&t).map_or(true, |&flag| ![OUTSIDE, WAITING_ROOM, IN_CRITICAL_SECTION].contains(&flag)) // Ensure flags is in a known state.
        } {
            thread::yield_now();
        }
    }

    // Leave
    {
        let (lock, cvar) = &*dict;
        let mut flags = lock.lock().unwrap();
        flags.insert(id, OUTSIDE);
        cvar.notify_all();
    }
}


fn test_szymanski(n: i32) {
    let all_szy: Vec<i32> = (1..=n).collect();
    let all_szy_arc = Arc::new(all_szy);
    let dict: Arc<(Mutex<HashMap<i32, i32>>, Condvar)> = Arc::new((Mutex::new(HashMap::new()), Condvar::new()));
    let critical_value = Arc::new(Mutex::new(1));

    scope(|s| {
        for &i in all_szy_arc.iter() {
            let all_szy_arc_clone = Arc::clone(&all_szy_arc);
            let dict_clone = Arc::clone(&dict);
            let critical_value_clone = Arc::clone(&critical_value);

            s.spawn(move |_| {
                run_szymanski(i, all_szy_arc_clone, dict_clone, critical_value_clone);
            });
        }
    }).unwrap(); // use scope to ensure all threads are finished
}
