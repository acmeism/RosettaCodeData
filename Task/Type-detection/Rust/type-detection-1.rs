enum ExpectedTypes {
    Int(i64),
    UInt(u64),
    Real(f64),
    Text(String),
    Uncertain,
}

// Avoid having to prefix each variant name with ExpectedTypes::
use ExpectedTypes::*;

fn main() {
    let enum_test = &[Int(-5), UInt(10), Real(-15.5), Text("Twenty".to_owned()),
                     Uncertain];

    for entry in enum_test {
        match entry {
            Int(x) => println!("Got an integer: {}", x),
            UInt(x) => println!("Got an unsigned integer: {}", x),
            Real(x) => println!("Got a floating-point number: {}", x),
            Text(x) => println!("Got a string of text: {}", x),
            Uncertain => println!("Value is uncertain"),
        }
    }
}
