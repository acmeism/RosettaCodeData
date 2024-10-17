impl<T> Node<T> {
    fn new(v: T) -> Node<T> {
        Node {value: v, next: None, prev: Rawlink::none()}
    }
}

impl<T> Rawlink<T> {
    fn none() -> Self {
        Rawlink {p: ptr::null_mut()}
    }

    fn some(n: &mut T) -> Rawlink<T> {
        Rawlink{p: n}
    }
}

impl<'a, T> From<&'a mut Link<T>> for Rawlink<Node<T>> {
    fn from(node: &'a mut Link<T>) -> Self {
        match node.as_mut() {
            None => Rawlink::none(),
            Some(ptr) => Rawlink::some(ptr)
        }
    }
}


fn link_no_prev<T>(mut next: Box<Node<T>>) -> Link<T> {
    next.prev = Rawlink::none();
    Some(next)
}

impl<T> LinkedList<T> {
    #[inline]
    fn push_front_node(&mut self, mut new_head: Box<Node<T>>) {
        match self.list_head {
            None => {
                self.list_head = link_no_prev(new_head);
                self.list_tail = Rawlink::from(&mut self.list_head);
            }
            Some(ref mut head) => {
                new_head.prev = Rawlink::none();
                head.prev = Rawlink::some(&mut *new_head);
                mem::swap(head, &mut new_head);
                head.next = Some(new_head);
            }
        }
        self.length += 1;
    }
    pub fn push_front(&mut self, elt: T) {
        self.push_front_node(Box::new(Node::new(elt)));
    }
}
