use std::rc::Rc;
use std::cell::RefCell;

fn main() {
    let size = 3;

    // Clone the given element to fill out the vector.
    let mut v: Vec<String> = vec![String::new(); size];
    v[0].push('a');
    println!("{:?}", v);

    // Run a given closure to create each element.
    let mut v: Vec<String> = (0..size).map(|i| i.to_string()).collect();
    v[0].push('a');
    println!("{:?}", v);

    // For multiple mutable views of the same thing, use something like Rc and RefCell.
    let v: Vec<Rc<RefCell<String>>> = vec![Rc::new(RefCell::new(String::new())); size];
    v[0].borrow_mut().push('a');
    println!("{:?}", v);
}
