trait ListExt<T> {
    fn insert(&mut self, elt: T, at: usize);
}

impl<T> ListExt<T> for std::collections::LinkedList<T> {
    // The following references the standard library's implementation of `LinkedList::remove`
    fn insert(&mut self, elt: T, at: usize) {
        let len = self.len();
        assert!(
            at <= len,
            "The given index must be a valid index after insertion",
        );

        let offset_from_end = len - at;
        if at < offset_from_end {
            let mut cursor = self.cursor_front_mut();
            for _ in 0..at {
                cursor.move_next();
            }
            cursor.insert_before(elt);
        } else {
            let mut cursor = self.cursor_back_mut();
            for _ in 0..offset_from_end {
                cursor.move_prev();
            }
            cursor.insert_after(elt);
        }
    }
}

fn definition() {
    use std::collections::LinkedList;

    let mut list = LinkedList::new();
    list.push_back('B');
    list.push_front('A');
    list.insert('C', 1);

    assert_eq!(list, ['A', 'C', 'B'].into());
}
