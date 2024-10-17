use std::collections::VecDeque;

fn main() {
    let mut queue = VecDeque::new();
    queue.push_back("Hello");
    queue.push_back("World");
    while let Some(item) = queue.pop_front() {
        println!("{}", item);
    }

    if queue.is_empty() {
        println!("Yes, it is empty!");
    }
}
