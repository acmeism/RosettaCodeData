use std::cell::RefCell;
use std::fmt;
use std::rc::{Rc, Weak};

#[derive(Debug)]
struct Node {
    val: i32,
    parent: Option<Weak<RefCell<Node>>>,
    left: Option<Rc<RefCell<Node>>>,
    right: Option<Rc<RefCell<Node>>>,
    color: i32, // 1 for Red, 0 for Black
}

impl Node {
    fn new(val: i32) -> Rc<RefCell<Self>> {
        Rc::new(RefCell::new(Node {
            val,
            parent: None,
            left: None,
            right: None,
            color: 1, // Red by default
        }))
    }
}

struct RBTree {
    null_node: Rc<RefCell<Node>>,
    root: Option<Rc<RefCell<Node>>>,
}

impl RBTree {
    fn new() -> Self {
        let null_node = Node::new(0);
        null_node.borrow_mut().color = 0; // Black

        RBTree {
            null_node,
            root: None,
        }
    }

    fn insert_node(&mut self, key: i32) {
        let node = Node::new(key);
        node.borrow_mut().left = Some(self.null_node.clone());
        node.borrow_mut().right = Some(self.null_node.clone());

        let mut y: Option<Rc<RefCell<Node>>> = None;
        let mut x = self.root.clone();

        while let Some(current) = x {
            if current.borrow().val == self.null_node.borrow().val {
                break;
            }

            y = Some(current.clone());

            if node.borrow().val < current.borrow().val {
                let left = current.borrow().left.clone();
                x = if let Some(left_node) = left {
                    if left_node.borrow().val != self.null_node.borrow().val {
                        Some(left_node)
                    } else {
                        None
                    }
                } else {
                    None
                };
            } else {
                let right = current.borrow().right.clone();
                x = if let Some(right_node) = right {
                    if right_node.borrow().val != self.null_node.borrow().val {
                        Some(right_node)
                    } else {
                        None
                    }
                } else {
                    None
                };
            }
        }

        node.borrow_mut().parent = y.as_ref().map(|n| Rc::downgrade(n));

        match &y {
            None => {
                self.root = Some(node.clone());
            }
            Some(parent) => {
                if node.borrow().val < parent.borrow().val {
                    parent.borrow_mut().left = Some(node.clone());
                } else {
                    parent.borrow_mut().right = Some(node.clone());
                }
            }
        }

        if y.is_none() {
            node.borrow_mut().color = 0; // Black
            return;
        }

        let parent = y.unwrap();
        if parent.borrow().parent.is_none() {
            return;
        }

        self.fix_insert(node.clone());
    }

    fn minimum(&self, node: Rc<RefCell<Node>>) -> Rc<RefCell<Node>> {
        let mut current = node;
        while current.borrow().left.is_some() {
            let left = current.borrow().left.as_ref().unwrap().clone();
            if left.borrow().val == self.null_node.borrow().val {
                break;
            }
            current = left;
        }
        current
    }

    fn lr(&mut self, x: Rc<RefCell<Node>>) {
        let y = x.borrow().right.as_ref().unwrap().clone();
        x.borrow_mut().right = y.borrow().left.clone();

        if let Some(left) = &y.borrow().left {
            if left.borrow().val != self.null_node.borrow().val {
                left.borrow_mut().parent = Some(Rc::downgrade(&x));
            }
        }

        y.borrow_mut().parent = x.borrow().parent.clone();

        match &x.borrow().parent {
            None => {
                self.root = Some(y.clone());
            }
            Some(parent_weak) => {
                let parent = parent_weak.upgrade().unwrap();
                if Rc::ptr_eq(&x, parent.borrow().left.as_ref().unwrap()) {
                    parent.borrow_mut().left = Some(y.clone());
                } else {
                    parent.borrow_mut().right = Some(y.clone());
                }
            }
        }

        y.borrow_mut().left = Some(x.clone());
        x.borrow_mut().parent = Some(Rc::downgrade(&y));
    }

    fn rr(&mut self, x: Rc<RefCell<Node>>) {
        let y = x.borrow().left.as_ref().unwrap().clone();
        x.borrow_mut().left = y.borrow().right.clone();

        if let Some(right) = &y.borrow().right {
            if right.borrow().val != self.null_node.borrow().val {
                right.borrow_mut().parent = Some(Rc::downgrade(&x));
            }
        }

        y.borrow_mut().parent = x.borrow().parent.clone();

        match &x.borrow().parent {
            None => {
                self.root = Some(y.clone());
            }
            Some(parent_weak) => {
                let parent = parent_weak.upgrade().unwrap();
                if Rc::ptr_eq(&x, parent.borrow().right.as_ref().unwrap()) {
                    parent.borrow_mut().right = Some(y.clone());
                } else {
                    parent.borrow_mut().left = Some(y.clone());
                }
            }
        }

        y.borrow_mut().right = Some(x.clone());
        x.borrow_mut().parent = Some(Rc::downgrade(&y));
    }

    fn fix_insert(&mut self, mut k: Rc<RefCell<Node>>) {
        loop {
            let k_parent = match &k.borrow().parent {
                Some(parent_weak) => parent_weak.upgrade().unwrap(),
                None => break,
            };

            let k_grandparent = match &k_parent.borrow().parent {
                Some(grandparent_weak) => grandparent_weak.upgrade().unwrap(),
                None => break,
            };

            if k_parent.borrow().color != 1 {
                break;
            }

            if Rc::ptr_eq(&k_parent, k_grandparent.borrow().right.as_ref().unwrap()) {
                let u = k_grandparent.borrow().left.as_ref().unwrap().clone();

                if u.borrow().color == 1 {
                    u.borrow_mut().color = 0;
                    k_parent.borrow_mut().color = 0;
                    k_grandparent.borrow_mut().color = 1;
                    k = k_grandparent.clone();
                } else {
                    if Rc::ptr_eq(&k, k_parent.borrow().left.as_ref().unwrap()) {
                        k = k_parent.clone();
                        self.rr(k.clone());
                    }
                    let k_parent = k.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    let k_grandparent = k_parent.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    k_parent.borrow_mut().color = 0;
                    k_grandparent.borrow_mut().color = 1;
                    self.lr(k_grandparent.clone());
                }
            } else {
                let u = k_grandparent.borrow().right.as_ref().unwrap().clone();

                if u.borrow().color == 1 {
                    u.borrow_mut().color = 0;
                    k_parent.borrow_mut().color = 0;
                    k_grandparent.borrow_mut().color = 1;
                    k = k_grandparent.clone();
                } else {
                    if Rc::ptr_eq(&k, k_parent.borrow().right.as_ref().unwrap()) {
                        k = k_parent.clone();
                        self.lr(k.clone());
                    }
                    let k_parent = k.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    let k_grandparent = k_parent.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    k_parent.borrow_mut().color = 0;
                    k_grandparent.borrow_mut().color = 1;
                    self.rr(k_grandparent.clone());
                }
            }

            if Rc::ptr_eq(&k, self.root.as_ref().unwrap()) {
                break;
            }
        }

        self.root.as_ref().unwrap().borrow_mut().color = 0;
    }

    fn fix_delete(&mut self, mut x: Rc<RefCell<Node>>) {
        while !Rc::ptr_eq(&x, self.root.as_ref().unwrap()) && x.borrow().color == 0 {
            let x_parent = x.borrow().parent.as_ref().unwrap().upgrade().unwrap();

            if Rc::ptr_eq(&x, x_parent.borrow().left.as_ref().unwrap()) {
                let mut s = x_parent.borrow().right.as_ref().unwrap().clone();

                if s.borrow().color == 1 {
                    s.borrow_mut().color = 0;
                    x_parent.borrow_mut().color = 1;
                    self.lr(x_parent.clone());
                    let x_parent = x.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    s = x_parent.borrow().right.as_ref().unwrap().clone();
                }

                let s_left = s.borrow().left.as_ref().unwrap().clone();
                let s_right = s.borrow().right.as_ref().unwrap().clone();

                if s_left.borrow().color == 0 && s_right.borrow().color == 0 {
                    s.borrow_mut().color = 1;
                    x = x_parent.clone();
                } else {
                    if s_right.borrow().color == 0 {
                        s_left.borrow_mut().color = 0;
                        s.borrow_mut().color = 1;
                        self.rr(s.clone());
                        let x_parent = x.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                        s = x_parent.borrow().right.as_ref().unwrap().clone();
                    }

                    s.borrow_mut().color = x_parent.borrow().color;
                    x_parent.borrow_mut().color = 0;

                    let s_right = s.borrow().right.as_ref().unwrap().clone();
                    s_right.borrow_mut().color = 0;

                    self.lr(x_parent.clone());
                    x = self.root.as_ref().unwrap().clone();
                }
            } else {
                let mut s = x_parent.borrow().left.as_ref().unwrap().clone();

                if s.borrow().color == 1 {
                    s.borrow_mut().color = 0;
                    x_parent.borrow_mut().color = 1;
                    self.rr(x_parent.clone());
                    let x_parent = x.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                    s = x_parent.borrow().left.as_ref().unwrap().clone();
                }

                let s_left = s.borrow().left.as_ref().unwrap().clone();
                let s_right = s.borrow().right.as_ref().unwrap().clone();

                if s_right.borrow().color == 0 && s_left.borrow().color == 0 {
                    s.borrow_mut().color = 1;
                    x = x_parent.clone();
                } else {
                    if s_left.borrow().color == 0 {
                        s_right.borrow_mut().color = 0;
                        s.borrow_mut().color = 1;
                        self.lr(s.clone());
                        let x_parent = x.borrow().parent.as_ref().unwrap().upgrade().unwrap();
                        s = x_parent.borrow().left.as_ref().unwrap().clone();
                    }

                    s.borrow_mut().color = x_parent.borrow().color;
                    x_parent.borrow_mut().color = 0;

                    let s_left = s.borrow().left.as_ref().unwrap().clone();
                    s_left.borrow_mut().color = 0;

                    self.rr(x_parent.clone());
                    x = self.root.as_ref().unwrap().clone();
                }
            }
        }
        x.borrow_mut().color = 0;
    }

    fn rb_transplant(&mut self, u: Rc<RefCell<Node>>, v: Rc<RefCell<Node>>) {
        match &u.borrow().parent {
            None => {
                self.root = Some(v.clone());
            }
            Some(parent_weak) => {
                let parent = parent_weak.upgrade().unwrap();
                if Rc::ptr_eq(&u, parent.borrow().left.as_ref().unwrap()) {
                    parent.borrow_mut().left = Some(v.clone());
                } else {
                    parent.borrow_mut().right = Some(v.clone());
                }
            }
        }
        v.borrow_mut().parent = u.borrow().parent.clone();
    }

    fn delete_node_helper(&mut self, node: Option<Rc<RefCell<Node>>>, key: i32) {
        let mut z: Option<Rc<RefCell<Node>>> = Some(self.null_node.clone());
        let mut temp = node;

        while let Some(current) = temp {
            if current.borrow().val == key {
                z = Some(current.clone());
            }

            temp = if current.borrow().val <= key {
                let right = current.borrow().right.clone();
                if let Some(right_node) = right {
                    if right_node.borrow().val != self.null_node.borrow().val {
                        Some(right_node)
                    } else {
                        None
                    }
                } else {
                    None
                }
            } else {
                let left = current.borrow().left.clone();
                if let Some(left_node) = left {
                    if left_node.borrow().val != self.null_node.borrow().val {
                        Some(left_node)
                    } else {
                        None
                    }
                } else {
                    None
                }
            };
        }

        let z = z.unwrap();
        if Rc::ptr_eq(&z, &self.null_node) {
            println!("Value not present in Tree !!");
            return;
        }

        let y = z.clone();
        let y_original_color = y.borrow().color;
        let x: Rc<RefCell<Node>>;

        let z_left = z.borrow().left.as_ref().unwrap().clone();
        let z_right = z.borrow().right.as_ref().unwrap().clone();

        if Rc::ptr_eq(&z_left, &self.null_node) {
            x = z_right.clone();
            self.rb_transplant(z.clone(), z_right);
        } else if Rc::ptr_eq(&z_right, &self.null_node) {
            x = z_left.clone();
            self.rb_transplant(z.clone(), z_left);
        } else {
            let y_min = self.minimum(z_right);
            let y_original_color = y_min.borrow().color;
            let x_temp = y_min.borrow().right.as_ref().unwrap().clone();
            x = x_temp.clone();

            let y_min_parent = y_min.borrow().parent.as_ref().unwrap().upgrade().unwrap();
            if Rc::ptr_eq(&y_min_parent, &z) {
                x.borrow_mut().parent = Some(Rc::downgrade(&y_min));
            } else {
                self.rb_transplant(y_min.clone(), x_temp);

                let y_min = y_min.clone();
                let z_right = z.borrow().right.as_ref().unwrap().clone();
                y_min.borrow_mut().right = Some(z_right.clone());
                z_right.borrow_mut().parent = Some(Rc::downgrade(&y_min));
            }

            self.rb_transplant(z.clone(), y_min.clone());

            let y_min = y_min.clone();
            let z_left = z.borrow().left.as_ref().unwrap().clone();
            y_min.borrow_mut().left = Some(z_left.clone());
            z_left.borrow_mut().parent = Some(Rc::downgrade(&y_min));
            y_min.borrow_mut().color = z.borrow().color;
        }

        if y_original_color == 0 {
            self.fix_delete(x);
        }
    }

    fn delete_node(&mut self, val: i32) {
        let root = self.root.clone();
        if let Some(root_node) = root {
            self.delete_node_helper(Some(root_node), val);
        }
    }

    fn print_call(&self, node: Option<Rc<RefCell<Node>>>, indent: String, last: bool) {
        if let Some(current) = node {
            if current.borrow().val == self.null_node.borrow().val {
                return;
            }

            print!("{}", indent);
            if last {
                print!("R----");
            } else {
                print!("L----");
            }

            let color = if current.borrow().color == 1 { "RED" } else { "BLACK" };
            println!("{}({})", current.borrow().val, color);

            let left_indent = if last {
                format!("{}     ", indent)
            } else {
                format!("{}|    ", indent)
            };

            let right_indent = left_indent.clone();

            self.print_call(
                current.borrow().left.clone().filter(|n| n.borrow().val != self.null_node.borrow().val),
                left_indent,
                false
            );
            self.print_call(
                current.borrow().right.clone().filter(|n| n.borrow().val != self.null_node.borrow().val),
                right_indent,
                true
            );
        }
    }

    fn print_tree(&self) {
        if let Some(root) = &self.root {
            self.print_call(Some(root.clone()), String::new(), true);
        }
    }
}

impl fmt::Display for RBTree {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "RBTree")
    }
}

fn main() {
    let mut bst = RBTree::new();

    println!("State of the tree after inserting the 30 keys:");
    for x in 1..30 {
        bst.insert_node(x);
    }
    bst.print_tree();

    println!("\nState of the tree after deleting the 15 keys:");
    for x in 1..15 {
        bst.delete_node(x);
    }
    bst.print_tree();
}
