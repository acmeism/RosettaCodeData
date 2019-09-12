#[derive(Debug)]
enum U {
    U0(i32),
    U1(String),
}

fn baz(i: u8) -> Result<(), U> {
    match i {
        0 => Err(U::U0(42)),
        1 => Err(U::U1("This will be returned from main".into())),
        _ => Ok(()),
    }
}

fn bar(i: u8) -> Result<(), U> {
    baz(i)
}

fn foo() -> Result<(), U> {
    for i in 0..2 {
        match bar(i) {
            Ok(()) => {},
            Err(U::U0(n)) => eprintln!("Caught U0 in foo: {}", n),
            Err(e) => return Err(e),
        }
    }
    Ok(())
}

fn main() -> Result<(), U> {
    foo()
}
