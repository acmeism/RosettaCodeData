fn stable_removal() {
    use std::collections::LinkedList;

    let mut dll = LinkedList::from(["dog", "cat", "bear"]);
    println!("Before removals: {dll:?}");
    {
        let mut right = dll.split_off(2);
        dll.pop_back();
        dll.append(&mut right);
    }
    println!("After removal 1: {dll:?}");
    dll.pop_front();
    println!("After removal 2: {dll:?}");
}
