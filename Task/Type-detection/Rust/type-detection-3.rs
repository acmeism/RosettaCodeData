use std::any::Any;

pub fn is_string(thing: &dyn Any) {
    if thing.is::<&str>() {
        println!("It's a string slice!");
    } else {
        println!("Dunno");
    }
}

fn main() {
    is_string(&"Hello, World!");
    is_string(&5u16);
}
