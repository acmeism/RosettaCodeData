#![feature(linked_list_cursors)]

trait CursorExt<T> {
    fn insert_between(&mut self, l: &T, elt: T, r: &T);
    fn rinsert_between(&mut self, l: &T, elt: T, r: &T);
}

impl<T: PartialEq> CursorExt<T> for std::collections::linked_list::CursorMut<'_, T> {
    fn insert_between(&mut self, l: &T, elt: T, r: &T) {
        // Pointing at the sentinel, move to head
        if self.current().is_none() {
            self.move_next();
        }

        let next = |cursor: &mut Self| {
            let left = cursor.current()? == a;
            let right = cursor.peek_next()? == b;

            Some(left && right)
        };

        while let Some(found) = next(self) {
            if found {
                self.insert_after(elt);

                return;
            }
        }
    }

    fn rinsert_between(&mut self, l: &T, elt: T, r: &T) {
        // Pointing at the sentinel, move to tail
        if self.current().is_none() {
            self.move_prev();
        }

        let prev = |cursor: &mut Self| {
            let left = cursor.peek_prev()? == a;
            let right = cursor.current()? == b;

            Some(left && right)
        };

        while let Some(found) = prev(self) {
            if found {
                self.insert_before(elt);

                return;
            }
        }
    }
}

fn element_insertion() {
    use std::collections::LinkedList;

    let mut list = LinkedList::from(['A', 'B']);

    list.cursor_front_mut().insert_between(&'A', 'C', &'B');
    // list.cursor_back_mut().rinsert_between(&'A', 'C', &'B');

    assert_eq!(list, ['A', 'C', 'B'].into());
}
