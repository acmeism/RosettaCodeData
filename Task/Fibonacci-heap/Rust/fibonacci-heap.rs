use std::collections::HashMap;
use std::fmt::{Display, Debug};
use std::error::Error;

pub trait Value: PartialOrd + Display + Debug + Clone {}

impl<T> Value for T where T: PartialOrd + Display + Debug + Clone {}

pub struct Node<T: Value> {
    value: T,
    parent: Option<*mut Node<T>>,
    child: Option<*mut Node<T>>,
    prev: *mut Node<T>,
    next: *mut Node<T>,
    rank: usize,
    mark: bool,
}

impl<T: Value> Node<T> {
    fn new(value: T) -> *mut Self {
        let node = Box::new(Self {
            value,
            parent: None,
            child: None,
            prev: std::ptr::null_mut(),
            next: std::ptr::null_mut(),
            rank: 0,
            mark: false,
        });
        let ptr = Box::into_raw(node);
        unsafe {
            (*ptr).prev = ptr;
            (*ptr).next = ptr;
        }
        ptr
    }

    pub fn value(&self) -> &T {
        &self.value
    }
}

pub struct Heap<T: Value> {
    root: Option<*mut Node<T>>,
}

impl<T: Value> Heap<T> {
    // task requirement
    pub fn new() -> Self {
        Self { root: None }
    }

    // task requirement
    pub fn insert(&mut self, value: T) -> *mut Node<T> {
        let node = Node::new(value);

        match self.root {
            None => {
                self.root = Some(node);
            },
            Some(root) => {
                unsafe {
                    Self::meld1(root, node);
                    if (*node).value < (*root).value {
                        self.root = Some(node);
                    }
                }
            }
        }

        node
    }

    unsafe fn meld1(list: *mut Node<T>, single: *mut Node<T>) {
        (*(*list).prev).next = single;
        (*single).prev = (*list).prev;
        (*single).next = list;
        (*list).prev = single;
    }

    // task requirement
    pub fn union(&mut self, other: &mut Self) {
        match (self.root, other.root) {
            (None, Some(other_root)) => {
                self.root = Some(other_root);
            },
            (Some(root), Some(other_root)) => {
                unsafe {
                    Self::meld2(root, other_root);
                    if (*other_root).value < (*root).value {
                        self.root = Some(other_root);
                    }
                }
            },
            _ => {}
        }

        other.root = None;
    }

    unsafe fn meld2(a: *mut Node<T>, b: *mut Node<T>) {
        (*(*a).prev).next = b;
        (*(*b).prev).next = a;
        let a_prev = (*a).prev;
        let b_prev = (*b).prev;
        (*a).prev = b_prev;
        (*b).prev = a_prev;
    }

    // task requirement
    pub fn minimum(&self) -> Option<T> {
        self.root.map(|root| unsafe { (*root).value.clone() })
    }

    // task requirement
    pub fn extract_min(&mut self) -> Option<T> {
        let root = match self.root {
            None => return None,
            Some(r) => r,
        };

        let min = unsafe { (*root).value.clone() };

        unsafe {
            let mut roots: HashMap<usize, *mut Node<T>> = HashMap::new();

            let mut add = |mut r: *mut Node<T>| {
                (*r).prev = r;
                (*r).next = r;

                loop {
                    if let Some(x) = roots.remove(&(*r).rank) {
                        let (parent, child) = if (*x).value < (*r).value {
                            (x, r)
                        } else {
                            (r, x)
                        };

                        (*child).parent = Some(parent);
                        (*child).mark = false;

                        if (*parent).child.is_none() {
                            (*child).next = child;
                            (*child).prev = child;
                            (*parent).child = Some(child);
                        } else {
                            Self::meld1((*parent).child.unwrap(), child);
                        }

                        (*parent).rank += 1;
                        r = parent;
                    } else {
                        break;
                    }
                }

                roots.insert((*r).rank, r);
            };

            // Add siblings to roots
            let mut curr = (*root).next;
            while curr != root {
                let next = (*curr).next;
                add(curr);
                curr = next;
            }

            // Add children to roots
            if let Some(child) = (*root).child {
                (*child).parent = None;
                let first_child = child;
                let mut curr = (*child).next;
                add(child);

                while curr != first_child {
                    let next = (*curr).next;
                    (*curr).parent = None;
                    add(curr);
                    curr = next;
                }
            }

            // If roots is empty, heap is now empty
            if roots.is_empty() {
                self.root = None;
                return Some(min);
            }

            // Find new minimum and consolidate roots
            let (_, first_node) = roots.iter().next().unwrap();
            let mut min_node = *first_node;
            roots.remove(&(*min_node).rank);

            (*min_node).next = min_node;
            (*min_node).prev = min_node;

            for (_, r) in roots {
                (*r).prev = min_node;
                (*r).next = (*min_node).next;
                (*(*min_node).next).prev = r;
                (*min_node).next = r;

                if (*r).value < (*min_node).value {
                    min_node = r;
                }
            }

            self.root = Some(min_node);
        }

        Some(min)
    }

    // task requirement
    pub fn decrease_key(&mut self, node: *mut Node<T>, new_value: T) -> Result<(), Box<dyn Error>> {
        unsafe {
            if &new_value > &(*node).value {
                return Err("New value is greater than current value".into());
            }

            (*node).value = new_value.clone();

            if let Some(root) = self.root {
                if node == root {
                    return Ok(());
                }

                if let Some(parent) = (*node).parent {
                    if parent.is_null() {
                        if new_value < (*root).value {
                            self.root = Some(node);
                        }
                        return Ok(());
                    }

                    self.cut_and_meld(node);
                }
            }

            Ok(())
        }
    }

    unsafe fn cut(&self, x: *mut Node<T>) {
        if let Some(parent) = (*x).parent {
            (*parent).rank -= 1;

            if (*parent).rank == 0 {
                (*parent).child = None;
            } else {
                (*parent).child = Some((*x).next);
                (*(*x).prev).next = (*x).next;
                (*(*x).next).prev = (*x).prev;
            }

            if let Some(grand_parent) = (*parent).parent {
                if !grand_parent.is_null() {
                    if !(*parent).mark {
                        (*parent).mark = true;
                        return;
                    }

                    self.cut_and_meld(parent);
                }
            }
        }
    }

    unsafe fn cut_and_meld(&self, x: *mut Node<T>) {
        self.cut(x);
        (*x).parent = None;

        if let Some(root) = self.root {
            Self::meld1(root, x);
        }
    }

    // task requirement
    pub fn delete(&mut self, node: *mut Node<T>) {
        unsafe {
            if let Some(_parent) = (*node).parent {
                self.cut(node);
            } else if let Some(root) = self.root {
                if node == root {
                    self.extract_min();
                    return;
                }

                (*(*node).prev).next = (*node).next;
                (*(*node).next).prev = (*node).prev;
            }

            if let Some(child) = (*node).child {
                let first_child = child;
                let mut curr = child;

                loop {
                    (*curr).parent = None;
                    curr = (*curr).next;
                    if curr == first_child {
                        break;
                    }
                }

                if let Some(root) = self.root {
                    Self::meld2(root, child);
                }
            }
        }
    }

    pub fn visualize(&self) {
        if let Some(root) = self.root {
            unsafe {
                Self::visualize_node(root, "".to_string());
            }
        } else {
            println!("<empty>");
        }
    }

    unsafe fn visualize_node(node: *mut Node<T>, prefix: String) {
        let mut pc = "│ ".to_string();
        let mut curr = node;

        loop {
            if (*curr).next != node {
                print!("{}├─", prefix);
            } else {
                print!("{}└─", prefix);
                pc = "  ".to_string();
            }

            if (*curr).child.is_none() {
                println!("╴ {:?}", (*curr).value);
            } else {
                println!("┐ {:?}", (*curr).value);
                Self::visualize_node((*curr).child.unwrap(), format!("{}{}", prefix, pc));
            }

            if (*curr).next == node {
                break;
            }

            curr = (*curr).next;
        }
    }
}

impl<T: Value> Drop for Heap<T> {
    fn drop(&mut self) {
        // Memory cleanup would go here in a real implementation
        // This is just a placeholder to acknowledge that proper cleanup
        // would be necessary in a production implementation
    }
}

// Example program
fn main() {
    println!("MakeHeap:");
    let mut h = Heap::new();
    h.visualize();

    println!("\nInsert:");
    h.insert("cat".to_string());
    h.visualize();

    println!("\nUnion:");
    let mut h2 = Heap::new();
    h2.insert("rat".to_string());
    h.union(&mut h2);
    h.visualize();

    println!("\nMinimum:");
    if let Some(m) = h.minimum() {
        println!("{}", m);
    }

    println!("\nExtractMin:");
    // Add a couple more items to demonstrate parent-child linking that
    // happens on delete min.
    h.insert("bat".to_string());
    let x = h.insert("meerkat".to_string()); // save x for decrease key and delete demos
    if let Some(m) = h.extract_min() {
        println!("(extracted {})", m);
    }
    h.visualize();

    println!("\nDecreaseKey:");
    let _ = h.decrease_key(x, "gnat".to_string());
    h.visualize();

    println!("\nDelete:");
    // Add yet a couple more items to show how F&T's original delete was
    // lazier than CLRS's delete.
    h.insert("bobcat".to_string());
    h.insert("bat".to_string());
    unsafe {
        println!("(deleting {})", (*x).value());
    }
    h.delete(x);
    h.visualize();
}
