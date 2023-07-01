use std::ptr;

pub struct Queue<T> {
    head: Link<T>,
    tail: *mut Item<T>, // Raw, C-like pointer. Cannot be guaranteed safe
}

type Link<T> = Option<Box<Item<T>>>;

struct Item<T> {
    elem: T,
    next: Link<T>,
}

pub struct IntoIter<T>(Queue<T>);

pub struct Iter<'a, T:'a> {
    next: Option<&'a Item<T>>,
}

pub struct IterMut<'a, T: 'a> {
    next: Option<&'a mut Item<T>>,
}


impl<T> Queue<T> {
    pub fn new() -> Self {
        Queue { head: None, tail: ptr::null_mut() }
    }

    pub fn enqueue(&mut self, elem: T) {
        let mut new_tail = Box::new(Item {
            elem: elem,
            next: None,
        });

        let raw_tail: *mut _ = &mut *new_tail;

        if !self.tail.is_null() {
            unsafe {
                (*self.tail).next = Some(new_tail);
            }
        } else {
            self.head = Some(new_tail);
        }

        self.tail = raw_tail;
    }

    pub fn dequeue(&mut self) -> Option<T> {
        self.head.take().map(|head| {
            let head = *head;
            self.head = head.next;

            if self.head.is_none() {
                self.tail = ptr::null_mut();
            }

            head.elem
        })
    }

    pub fn peek(&self) -> Option<&T> {
        self.head.as_ref().map(|item| {
            &item.elem
        })
    }

    pub fn peek_mut(&mut self) -> Option<&mut T> {
        self.head.as_mut().map(|item| {
            &mut item.elem
        })
    }

    pub fn into_iter(self) -> IntoIter<T> {
        IntoIter(self)
    }

    pub fn iter(&self) -> Iter<T> {
        Iter { next: self.head.as_ref().map(|item| &**item) }
    }

    pub fn iter_mut(&mut self) -> IterMut<T> {
        IterMut { next: self.head.as_mut().map(|item| &mut **item) }
    }
}

impl<T> Drop for Queue<T> {
    fn drop(&mut self) {
        let mut cur_link = self.head.take();
        while let Some(mut boxed_item) = cur_link {
            cur_link = boxed_item.next.take();
        }
    }
}

impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.dequeue()
    }
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;

    fn next(&mut self) -> Option<Self::Item> {
        self.next.map(|item| {
            self.next = item.next.as_ref().map(|item| &**item);
            &item.elem
        })
    }
}

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        self.next.take().map(|item| {
            self.next = item.next.as_mut().map(|item| &mut **item);
            &mut item.elem
        })
    }
}
