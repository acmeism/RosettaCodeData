use std::fmt::{self, Debug, Display};

use bincode::{deserialize, serialize};
use serde::{Deserialize, Serialize};

#[typetag::serde(tag = "animal")]
trait Animal: Display + Debug {
    fn name(&self) -> Option<&str>;
    fn feet(&self) -> u32;
}

#[derive(Debug, Deserialize, Serialize)]
struct Dog {
    name: String,
    color: String,
}

impl Display for Dog {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} is a dog with {} fur", self.name, self.color)
    }
}

#[typetag::serde]
impl Animal for Dog {
    fn name(&self) -> Option<&str> {
        Some(&self.name)
    }

    fn feet(&self) -> u32 {
        4
    }
}

#[derive(Debug, Deserialize, Serialize)]
struct Bird {
    name: String,
    wingspan: u32,
}

impl Display for Bird {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{} is a bird with a wingspan of {}",
            self.name, self.wingspan
        )
    }
}

#[typetag::serde]
impl Animal for Bird {
    fn name(&self) -> Option<&str> {
        Some(&self.name)
    }

    fn feet(&self) -> u32 {
        2
    }
}

fn main() -> bincode::Result<()> {
    let animals: Vec<Box<dyn Animal>> = vec![
        Box::new(Dog {
            name: "Rover".into(),
            color: "brown".into(),
        }),
        Box::new(Bird {
            name: "Tweety".into(),
            wingspan: 3,
        }),
    ];

    for animal in &animals {
        println!("{}", animal);
    }

    let serialized = serialize(&animals)?;
    println!("Serialized into {} bytes", serialized.len());

    let deserialized: Vec<Box<dyn Animal>> = deserialize(&serialized)?;

    println!("{:#?}", deserialized);

    Ok(())
}
