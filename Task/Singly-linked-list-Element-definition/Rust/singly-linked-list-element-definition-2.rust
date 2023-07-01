type Link<T> = Option<Box<Node<T>>>; // Type alias
pub struct List<T> { // User-facing interface for list
    head: Link<T>,
}

struct Node<T> { // Private implementation of Node
    elem: T,
    next: Link<T>,
}

impl<T> List<T> {
    #[inline]
    pub fn new() -> Self { // List constructor
        List { head: None }
    // Add other methods here
}
