use std::fmt::Display;

#[derive(Debug)]
struct Node<T> {
    value: T,
    next: Option<Box<Node<T>>>,
}

impl<T> Node<T> {
    fn new(value: T) -> Self {
        Node {
            value,
            next: None,
        }
    }
}

#[derive(Debug)]
pub struct SinglyLinkedList<T> {
    head: Option<Box<Node<T>>>,
}

impl<T> SinglyLinkedList<T>
where
    T: PartialEq + Clone,
{
    pub fn new() -> Self {
        SinglyLinkedList { head: None }
    }

    pub fn add(&mut self, new_value: T) -> bool {
        if self.head.is_none() {
            self.head = Some(Box::new(Node::new(new_value)));
            return true;
        }

        Self::add_recursive(&mut self.head, new_value)
    }

    fn add_recursive(node: &mut Option<Box<Node<T>>>, new_value: T) -> bool {
        if let Some(current) = node {
            if current.next.is_none() {
                current.next = Some(Box::new(Node::new(new_value)));
                true
            } else {
                Self::add_recursive(&mut current.next, new_value)
            }
        } else {
            false
        }
    }

    pub fn remove(&mut self, remove_value: &T) -> bool {
        Self::remove_recursive(&mut self.head, remove_value)
    }

    fn remove_recursive(node: &mut Option<Box<Node<T>>>, remove_value: &T) -> bool {
        if let Some(current) = node {
            if current.value == *remove_value {
                *node = current.next.take();
                true
            } else {
                Self::remove_recursive(&mut current.next, remove_value)
            }
        } else {
            false
        }
    }

    pub fn reverse(&mut self) -> bool {
        let mut previous: Option<Box<Node<T>>> = None;
        let mut current = self.head.take();

        while let Some(mut current_node) = current {
            let next = current_node.next.take();
            current_node.next = previous;
            previous = Some(current_node);
            current = next;
        }

        self.head = previous;
        true
    }

    pub fn print(&self)
    where
        T: Display,
    {
        print!("[");
        Self::print_recursive(&self.head);
        println!("]");
    }

    fn print_recursive(node: &Option<Box<Node<T>>>)
    where
        T: Display,
    {
        if let Some(current) = node {
            print!("{} ", current.value);
            Self::print_recursive(&current.next);
        }
    }
}

impl<T> Default for SinglyLinkedList<T>
where
    T: PartialEq + Clone,
{
    fn default() -> Self {
        Self::new()
    }
}

fn main() {
    let mut linked_list = SinglyLinkedList::new();

    for i in 1..=9u32 {
        linked_list.add(i);
    }
    print!("Linked list   : ");
    linked_list.print();

    linked_list.remove(&1);
    print!("After remove 1: ");
    linked_list.print();

    linked_list.remove(&5);
    print!("After remove 5: ");
    linked_list.print();

    linked_list.remove(&9);
    print!("After remove 9: ");
    linked_list.print();

    linked_list.remove(&5);
    print!("After remove 5: ");
    linked_list.print();

    linked_list.reverse();
    print!("After reverse : ");
    linked_list.print();
}
