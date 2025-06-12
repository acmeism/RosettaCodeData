#![feature(linked_list_cursors)]

pub struct Cursor<'a, T: 'a> {
    index: usize,
    current: Option<NonNull<Node<T>>>,
    list: &'a LinkedList<T>,
}

pub struct CursorMut<'a, T: 'a> {
    index: usize,
    current: Option<NonNull<Node<T>>>,
    list: &'a mut LinkedList<T>,
}
