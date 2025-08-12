use std::sync::{Arc, Mutex, OnceLock};

// Thread-safe singleton using OnceLock (stable since Rust 1.70)
pub struct GlobalSingleton {
    data: String,
    counter: u32,
}

impl GlobalSingleton {
    // Private constructor
    fn new() -> Self {
        Self {
            data: String::from("Singleton initialized"),
            counter: 0,
        }
    }

    // Get the singleton instance
    pub fn instance() -> Arc<Mutex<GlobalSingleton>> {
        static INSTANCE: OnceLock<Arc<Mutex<GlobalSingleton>>> = OnceLock::new();

        INSTANCE.get_or_init(|| {
            Arc::new(Mutex::new(GlobalSingleton::new()))
        }).clone()
    }

    // Non-static methods that operate on the singleton instance
    pub fn get_data(&self) -> &str {
        &self.data
    }

    pub fn set_data(&mut self, new_data: String) {
        self.data = new_data;
    }

    pub fn increment_counter(&mut self) {
        self.counter += 1;
    }

    pub fn get_counter(&self) -> u32 {
        self.counter
    }
}

// Alternative implementation using std::sync::LazyLock (stable since Rust 1.80)
// This is the most modern and clean approach
use std::sync::LazyLock;

static LAZY_SINGLETON: LazyLock<Arc<Mutex<GlobalSingleton>>> = LazyLock::new(|| {
    Arc::new(Mutex::new(GlobalSingleton::new()))
});

impl GlobalSingleton {
    // Alternative method using LazyLock
    pub fn lazy_instance() -> Arc<Mutex<GlobalSingleton>> {
        LAZY_SINGLETON.clone()
    }
}

fn main() {
    // Usage example with OnceLock
    {
        let singleton = GlobalSingleton::instance();
        let mut instance = singleton.lock().unwrap();
        println!("Initial data: {}", instance.get_data());
        instance.increment_counter();
        instance.set_data("Modified data".to_string());
        println!("Counter: {}", instance.get_counter());
    }

    // Access from another scope - same instance
    {
        let singleton = GlobalSingleton::instance();
        let instance = singleton.lock().unwrap();
        println!("Data from another scope: {}", instance.get_data());
        println!("Counter from another scope: {}", instance.get_counter());
    }

    // Demonstrate thread safety
    use std::thread;

    let handles: Vec<_> = (0..3)
        .map(|i| {
            thread::spawn(move || {
                let singleton = GlobalSingleton::instance();
                let mut instance = singleton.lock().unwrap();
                instance.increment_counter();
                println!("Thread {} incremented counter to: {}", i, instance.get_counter());
            })
        })
        .collect();

    for handle in handles {
        handle.join().unwrap();
    }

    // Final state
    let singleton = GlobalSingleton::instance();
    let instance = singleton.lock().unwrap();
    println!("Final counter value: {}", instance.get_counter());

    // Demonstrate LazyLock alternative
    println!("\n--- Using LazyLock alternative ---");
    {
        let singleton = GlobalSingleton::lazy_instance();
        let mut instance = singleton.lock().unwrap();
        instance.set_data("LazyLock data".to_string());
        println!("LazyLock data: {}", instance.get_data());
    }
}
