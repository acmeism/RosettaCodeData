const SAILORS: [&str; 10] = [
    "Adrian", "Caspian", "Dune", "Finn", "Fisher", "Heron", "Kai", "Ray", "Sailor", "Tao",
];

const LADIES: [&str; 10] = [
    "Ariel", "Bertha", "Blue", "Cali", "Catalina", "Gale", "Hannah", "Isla", "Marina", "Shelly",
];

fn is_nice_girl(lady: &str) -> bool {
    (lady.as_bytes().first().unwrap()).is_multiple_of(2)
}

fn is_lovable(lady: &str, sailor: &str) -> bool {
    lady.as_bytes().last().unwrap() % 2 == sailor.as_bytes().last().unwrap() % 2
}

fn main() {
    for lady in LADIES {
        if is_nice_girl(lady) {
            println!("Dating service should offer a date with {lady}");
            for sailor in SAILORS {
                if is_lovable(lady, sailor) {
                    println!("\tSailor {sailor} should take an offer to date her")
                }
            }
        } else {
            println!("Dating service should NOT offer a date with {lady}")
        }
    }
}
