 struct Node<T> {
    elem: T,
    next: Option<Box<Node<T>>>,
}
