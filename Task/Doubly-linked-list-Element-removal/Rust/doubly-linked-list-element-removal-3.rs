#![feature(linked_list_cursors)]

trait CursorExt2<T> {
    fn find(&mut self, elem: &T) -> bool;
    fn rfind(&mut self, elem: &T) -> bool;
}

impl<T: PartialEq> CursorExt2<T> for std::collections::linked_list::CursorMut<'_, T> {
    fn find(&mut self, elem: &T) -> bool {
        // Pointing at the sentinel, move to head
        if self.current().is_none() {
            self.move_next();
        }

        while let Some(e) = self.current() {
            if e == elem {
                return true;
            }

            self.move_next();
        }

        false
    }

    fn rfind(&mut self, elem: &T) -> bool {
        // Pointing at the sentinel, move to tail
        if self.current().is_none() {
            self.move_prev();
        }

        while let Some(e) = self.current() {
            if e == elem {
                return true;
            }

            self.move_prev();
        }

        false
    }
}

fn cursor_removal() {
    use std::collections::LinkedList;

    let mut dll = LinkedList::from(["dog", "cat", "bear"]);
    println!("Before removals: {dll:?}");
    {
        let mut cursor = dll.cursor_front_mut();
        if cursor.find(&"cat") {
            cursor.remove_current(); // Moves cursor to "bear" after deletion
        }
        // cursor = dll.cursor_back_mut();
        // if cursor.rfind(&"cat") {
        //     cursor.remove_current();
        // }
    }
    println!("After removal 1: {dll:?}");
    {
        let mut cursor = dll.cursor_back_mut();
        cursor.pop_front(); // We can modify elements at back and front at any time
    }
    println!("After removal 2: {dll:?}");
}
