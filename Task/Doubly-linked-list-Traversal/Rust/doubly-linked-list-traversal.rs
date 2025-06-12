fn traversal() {
    use std::collections::LinkedList;

    let numbers = LinkedList::from([1, 5, 7, 0, 3, 2]);

    for i in &numbers {
        print!("{i} ");
    }
    println!();

    for i in numbers.iter().rev() {
        print!("{i} ");
    }
    println!();
}
