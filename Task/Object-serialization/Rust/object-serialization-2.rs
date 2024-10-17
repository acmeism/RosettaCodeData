use std::fmt;

use bincode::{deserialize, serialize};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
enum Animal {
    Dog { name: String, color: String },
    Bird { name: String, wingspan: u8 },
}

impl fmt::Display for Animal {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Animal::Dog { name, color } => write!(f, "{} is a dog with {} fur", name, color),
            Animal::Bird { name, wingspan } => {
                write!(f, "{} is a bird with a wingspan of {}", name, wingspan)
            }
        }
    }
}

fn main() -> bincode::Result<()> {
    let animals = vec![
        Animal::Dog {
            name: "Rover".into(),
            color: "brown".into(),
        },
        Animal::Bird {
            name: "Tweety".into(),
            wingspan: 3,
        },
    ];

    for animal in &animals {
        println!("{}", animal);
    }

    let serialized = serialize(&animals)?;

    println!("Serialized into {} bytes", serialized.len());

    let deserialized: Vec<Animal> = deserialize(&serialized)?;

    println!("{:#?}", deserialized);

    Ok(())
}
