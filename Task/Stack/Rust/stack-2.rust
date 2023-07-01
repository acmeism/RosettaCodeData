type Link<T> = Option<Box<Frame<T>>>;

pub struct Stack<T> {
    head: Link<T>,
}
struct Frame<T> {
    elem: T,
    next: Link<T>,
}

/// Iterate by value (consumes list)
pub struct IntoIter<T>(Stack<T>);
impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.pop()
    }
}

/// Iterate by immutable reference
pub struct Iter<'a, T: 'a> {
    next: Option<&'a Frame<T>>,
}
impl<'a, T> Iterator for Iter<'a, T> { // Iterate by immutable reference
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        self.next.take().map(|frame| {
            self.next = frame.next.as_ref().map(|frame| &**frame);
            &frame.elem
        })
    }
}

/// Iterate by mutable reference
pub struct IterMut<'a, T: 'a> {
    next: Option<&'a mut Frame<T>>,
}
impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;
    fn next(&mut self) -> Option<Self::Item> {
        self.next.take().map(|frame| {
            self.next = frame.next.as_mut().map(|frame| &mut **frame);
            &mut frame.elem
        })
    }
}


impl<T> Stack<T> {
    /// Return new, empty stack
    pub fn new() -> Self {
        Stack { head: None }
    }

    /// Add element to top of the stack
    pub fn push(&mut self, elem: T) {
        let new_frame = Box::new(Frame {
            elem: elem,
            next: self.head.take(),
        });
        self.head = Some(new_frame);
    }

    /// Remove element from top of stack, returning the value
    pub fn pop(&mut self) -> Option<T> {
        self.head.take().map(|frame| {
            let frame = *frame;
            self.head = frame.next;
            frame.elem
        })
    }

    /// Get immutable reference to top element of the stack
    pub fn peek(&self) -> Option<&T> {
        self.head.as_ref().map(|frame| &frame.elem)
    }

    /// Get mutable reference to top element on the stack
    pub fn peek_mut(&mut self) -> Option<&mut T> {
        self.head.as_mut().map(|frame| &mut frame.elem)
    }

    /// Iterate over stack elements by value
    pub fn into_iter(self) -> IntoIter<T> {
        IntoIter(self)
    }

    /// Iterate over stack elements by immutable reference
    pub fn iter<'a>(&'a self) -> Iter<'a,T> {
        Iter { next: self.head.as_ref().map(|frame| &**frame) }
    }

    /// Iterate over stack elements by mutable reference
    pub fn iter_mut(&mut self) -> IterMut<T> {
        IterMut { next: self.head.as_mut().map(|frame| &mut **frame) }
    }
}

// The Drop trait tells the compiler how to free an object after it goes out of scope.
// By default, the compiler would do this recursively which *could* blow the stack for
// extraordinarily long lists. This simply tells it to do it iteratively.
impl<T> Drop for Stack<T> {
    fn drop(&mut self) {
        let mut cur_link = self.head.take();
        while let Some(mut boxed_frame) = cur_link {
            cur_link = boxed_frame.next.take();
        }
    }
}
