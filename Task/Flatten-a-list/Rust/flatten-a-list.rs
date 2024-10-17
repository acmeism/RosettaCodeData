use std::{vec, mem, iter};

enum List<T> {
    Node(Vec<List<T>>),
    Leaf(T),
}

impl<T> IntoIterator for List<T> {
    type Item = List<T>;
    type IntoIter = ListIter<T>;
    fn into_iter(self) -> Self::IntoIter {
        match self {
            List::Node(vec) => ListIter::NodeIter(vec.into_iter()),
            leaf @ List::Leaf(_) => ListIter::LeafIter(iter::once(leaf)),
        }
    }
}

enum ListIter<T> {
    NodeIter(vec::IntoIter<List<T>>),
    LeafIter(iter::Once<List<T>>),
}

impl<T> ListIter<T> {
    fn flatten(self) -> Flatten<T> {
        Flatten {
            stack: Vec::new(),
            curr: self,
        }
    }
}

impl<T> Iterator for ListIter<T> {
    type Item = List<T>;
    fn next(&mut self) -> Option<Self::Item> {
        match *self {
            ListIter::NodeIter(ref mut v_iter) => v_iter.next(),
            ListIter::LeafIter(ref mut o_iter) => o_iter.next(),
        }
    }
}

struct Flatten<T> {
    stack: Vec<ListIter<T>>,
    curr: ListIter<T>,
}

// Flatten code is a little messy since we are shoehorning recursion into an Iterator
impl<T> Iterator for Flatten<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        loop {
            match self.curr.next() {
                Some(list) => {
                    match list {
                        node @ List::Node(_) => {
                            self.stack.push(node.into_iter());
                            let len = self.stack.len();
                            mem::swap(&mut self.stack[len - 1], &mut self.curr);
                        }
                        List::Leaf(item) => return Some(item),
                    }
                }
                None => {
                    if let Some(next) = self.stack.pop() {
                        self.curr = next;
                    } else {
                        return None;
                    }
                }
            }
        }
    }
}

use List::*;
fn main() {
    let list = Node(vec![Node(vec![Leaf(1)]),
                         Leaf(2),
                         Node(vec![Node(vec![Leaf(3), Leaf(4)]), Leaf(5)]),
                         Node(vec![Node(vec![Node(vec![])])]),
                         Node(vec![Node(vec![Node(vec![Leaf(6)])])]),
                         Leaf(7),
                         Leaf(8),
                         Node(vec![])]);

    for elem in list.into_iter().flatten() {
        print!("{} ", elem);
    }
    println!();

}
