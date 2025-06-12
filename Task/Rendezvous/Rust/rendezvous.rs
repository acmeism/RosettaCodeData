use std::error::Error;
use std::fmt;
use std::sync::{Arc, Mutex, Condvar};
use std::thread;
use std::time::Duration; // Only for potential debug sleeps, not strictly needed for logic

// --- Custom Error Type ---
#[derive(Debug)]
struct OutOfInkError;

impl fmt::Display for OutOfInkError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Printer out of ink")
    }
}

impl Error for OutOfInkError {}

// --- Printer Struct ---
#[derive(Debug, Clone, PartialEq)] // Add traits for comparison, debugging, and cloning
struct Printer {
    name: String,
    client_ink_level: u32,
}

impl Printer {
    fn new(name: &str, ink_level: u32) -> Self {
        Printer {
            name: name.to_string(),
            client_ink_level: ink_level,
        }
    }
}

// --- Shared State Struct ---
// Group all shared mutable data together
struct SharedState {
    printer: Printer,
    primary_printer_config: Printer, // Keep original config separate
    reserve_printer_config: Printer, // Keep original config separate
    goose_working: bool,
    humpty_working: bool,
    turn: u32,
}

// --- Display Function ---
// Takes a mutable reference to the shared state
// Returns Result to indicate success or OutOfInkError
fn display(state: &mut SharedState, text: &str) -> Result<(), OutOfInkError> {
    // Check if primary is out and switch to reserve if needed
    if state.printer == state.primary_printer_config && state.printer.client_ink_level == 0 {
        println!("      Switching to Reserve printer");
        state.printer = state.reserve_printer_config.clone(); // Use cloned config
    }

    // Attempt to print
    if state.printer.client_ink_level > 0 {
        state.printer.client_ink_level -= 1;
        println!("({}) {}", state.printer.name, text);
        Ok(())
    } else {
        println!("      Printer out of ink");
        Err(OutOfInkError)
    }
}

// --- Messenger Logic ---
// Takes Arc clones for shared data
fn messenger(
    message: Vec<String>,
    my_turn: u32,
    turn_count: u32,
    state_sync: Arc<(Mutex<SharedState>, Condvar)>, // Tuple of Mutex and Condvar
    worker_name: String, // For identifying which worker finished
) {
    let (lock, cvar) = &*state_sync; // Destructure the tuple
    let mut index: usize = 0;

    // Loop as long as *any* worker is potentially active
    // We re-check specific worker status inside the lock
    loop {
        // Acquire the lock. The MutexGuard 'state' is automatically released when it goes out of scope
        let mut state = lock.lock().expect("Mutex lock failed");

        // Wait while it's not our turn AND at least one worker is still supposed to be working
        // The wait_while unlocks the mutex and re-acquires it upon waking up
        state = cvar.wait_while(state, |s| {
             // Predicate: Keep waiting if...
             s.turn % turn_count != my_turn // it's not our turn
             && (s.goose_working || s.humpty_working) // AND someone is still working (prevents deadlock if other thread finishes)
        }).expect("Condition variable wait failed");


        // Check if *all* work is done *after* waking up or if we didn't need to wait
        if !state.goose_working && !state.humpty_working {
           // println!("{} sees both workers finished, exiting.", worker_name); // Debug
            break; // Exit the loop
        }

        // Check if *this specific worker* should still be working
        let should_be_working = if my_turn == 0 { state.goose_working } else { state.humpty_working };

        if !should_be_working {
            // This worker finished its text or an error occurred previously.
            // It needs to potentially wake up the *other* worker if it's waiting.
           // println!("{} sees it shouldn't be working, notifying and breaking.", worker_name); // Debug
           // We still increment the turn and notify to potentially unblock the other thread
           // if it's waiting for its turn number, even if it will also exit soon.
           state.turn += 1;
           cvar.notify_one();
           break; // Exit the loop
        }


        // --- Perform Work ---
        if index < message.len() {
            match display(&mut state, &message[index]) {
                Ok(()) => {
                    index += 1;
                }
                Err(_) => {
                    // Out of ink! Stop both workers.
                    println!("      Error detected by {}, stopping all work.", worker_name);
                    state.goose_working = false;
                    state.humpty_working = false;
                    // No break here yet, let the loop condition handle exit naturally after notification
                }
            }
        } else {
            // This worker finished its message
           // println!("{} finished text.", worker_name); // Debug
            if my_turn == 0 {
                state.goose_working = false;
            } else {
                state.humpty_working = false;
            }
        }

        // Increment turn and notify the *next* worker
        state.turn += 1;
        //println!("{} finished turn, new turn {}. Notifying.", worker_name, state.turn); // Debug
        cvar.notify_one();

        // MutexGuard 'state' is dropped here, releasing the lock
    }
     //println!("{} thread finished.", worker_name); // Debug
}


fn main() {
    let goose_text: Vec<String> = [
        "Old Mother Goose,",
        "When she wanted to wander,",
        "Would ride through the air,",
        "On a very fine gander.",
        "Jack's mother came in,",
        "And caught the goose soon,",
        "And mounting its back,",
        "Flew up to the moon.",
    ]
    .iter()
    .map(|s| s.to_string())
    .collect();

    let humpty_text: Vec<String> = [
        "Humpty Dumpty sat on a wall.",
        "Humpty Dumpty had a great fall.",
        "All the king's horses and all the king's men,",
        "Couldn't put Humpty together again.",
    ]
    .iter()
    .map(|s| s.to_string())
    .collect();

    // --- Initial State Setup ---
    let primary = Printer::new("Primary", 5);
    let reserve = Printer::new("Reserve", 5);

    let initial_state = SharedState {
        printer: primary.clone(), // Start with primary
        primary_printer_config: primary, // Store config
        reserve_printer_config: reserve, // Store config
        goose_working: true,
        humpty_working: true,
        turn: 0,
    };

    // Wrap state and condvar in Arc for shared ownership
    let state_sync = Arc::new((Mutex::new(initial_state), Condvar::new()));

    // --- Spawn Threads ---
    let state_sync_goose = Arc::clone(&state_sync);
    let goose_thread = thread::spawn(move || {
        messenger(goose_text, 0, 2, state_sync_goose, "Goose".to_string());
    });

    let state_sync_humpty = Arc::clone(&state_sync);
    let humpty_thread = thread::spawn(move || {
        messenger(humpty_text, 1, 2, state_sync_humpty, "Humpty".to_string());
    });

    // --- Wait for Threads to Finish ---
    goose_thread.join().expect("Goose thread panicked");
    humpty_thread.join().expect("Humpty thread panicked");

    println!("Both threads finished.");
}
