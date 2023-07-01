impl<T> List<T> {
    pub fn new() -> Self {
        List { head: None }
    }

    pub fn push(&mut self, elem: T) {
    let new_node = Box::new(Node {
        elem: elem,
        next: self.head.take(),
    });
    self.head = Some(new_node);
}
