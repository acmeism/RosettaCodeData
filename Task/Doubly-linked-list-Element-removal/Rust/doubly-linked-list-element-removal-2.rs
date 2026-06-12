#![feature(linked_list_remove)]

fn list_removal() {
    use std::collections::LinkedList;

    let mut dll = LinkedList::from(["dog", "cat", "bear"]);
    println!("Before removals: {dll:?}");
    dll.remove(dll.iter().position(|&elt| elt == "cat").unwrap());
    println!("After removal 1: {dll:?}");
    dll.pop_front();
    println!("After removal 2: {dll:?}");
}
