use std::collections::HashMap;
use std::sync::{Arc, Mutex, OnceLock};
use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum MultitonType {
    Zero,
    One,
    Two,
}

#[derive(Debug)]
struct Multiton {
    multiton_type: MultitonType,
}

impl Multiton {
    // Private constructor
    fn new(multiton_type: MultitonType) -> Self {
        Self { multiton_type }
    }

    // Thread-safe method to get instance
    // Returns None if the type is not found in the map
    pub fn get_instance(multiton_type: MultitonType) -> Option<Arc<Multiton>> {
        static INSTANCES: OnceLock<Mutex<HashMap<MultitonType, Arc<Multiton>>>> = OnceLock::new();

        let instances = INSTANCES.get_or_init(|| {
            let mut map = HashMap::new();
            map.insert(MultitonType::Zero, Arc::new(Multiton::new(MultitonType::Zero)));
            map.insert(MultitonType::One, Arc::new(Multiton::new(MultitonType::One)));
            map.insert(MultitonType::Two, Arc::new(Multiton::new(MultitonType::Two)));
            Mutex::new(map)
        });

        let instances_guard = instances.lock().unwrap();
        instances_guard.get(&multiton_type).cloned()
    }

    // Override toString equivalent
    pub fn to_string(&self) -> String {
        let type_str = match self.multiton_type {
            MultitonType::Zero => "ZERO",
            MultitonType::One => "ONE",
            MultitonType::Two => "TWO",
        };
        format!("This is Multiton {}", type_str)
    }
}

// Implement Display trait for easy printing (equivalent to << operator overload)
impl fmt::Display for Multiton {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.to_string())
    }
}

fn main() {
    let alpha = Multiton::get_instance(MultitonType::Zero);
    let beta = Multiton::get_instance(MultitonType::Zero);
    let gamma = Multiton::get_instance(MultitonType::One);
    let delta = Multiton::get_instance(MultitonType::Two);

    if let Some(ref a) = alpha {
        println!("{}", a);
    }
    if let Some(ref b) = beta {
        println!("{}", b);
    }
    if let Some(ref g) = gamma {
        println!("{}", g);
    }
    if let Some(ref d) = delta {
        println!("{}", d);
    }

    // Verify that alpha and beta point to the same instance
    match (alpha, beta) {
        (Some(a), Some(b)) => {
            println!("alpha == beta: {}", Arc::ptr_eq(&a, &b));
        }
        _ => println!("One or both instances are None"),
    }
}
