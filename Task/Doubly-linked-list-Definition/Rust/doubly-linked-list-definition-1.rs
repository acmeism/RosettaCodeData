// We are ommitting the allocator for these examples
pub struct LinkedList<T> {
    head: Option<NonNull<Node<T>>>,
    tail: Option<NonNull<Node<T>>>,
    len: usize,
    marker: PhantomData<Box<Node<T>>>, // We logically hold an owned pointer to Node<T>
}
