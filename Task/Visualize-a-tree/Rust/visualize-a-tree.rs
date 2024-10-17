extern crate rustc_serialize;
extern crate term_painter;

use rustc_serialize::json;
use std::fmt::{Debug, Display, Formatter, Result};
use term_painter::ToStyle;
use term_painter::Color::*;

type NodePtr = Option<usize>;

#[derive(Debug, PartialEq, Clone, Copy)]
enum Side {
    Left,
    Right,
    Up,
}

#[derive(Debug, PartialEq, Clone, Copy)]
enum DisplayElement {
    TrunkSpace,
    SpaceLeft,
    SpaceRight,
    SpaceSpace,
    Root,
}

impl DisplayElement {
    fn string(&self) -> String {
        match *self {
            DisplayElement::TrunkSpace => "    │   ".to_string(),
            DisplayElement::SpaceRight => "    ┌───".to_string(),
            DisplayElement::SpaceLeft => "    └───".to_string(),
            DisplayElement::SpaceSpace => "        ".to_string(),
            DisplayElement::Root => "├──".to_string(),
        }
    }
}

#[derive(Debug, Clone, Copy, RustcDecodable, RustcEncodable)]
struct Node<K, V> {
    key: K,
    value: V,
    left: NodePtr,
    right: NodePtr,
    up: NodePtr,
}

impl<K: Ord + Copy, V: Copy> Node<K, V> {
    pub fn get_ptr(&self, side: Side) -> NodePtr {
        match side {
            Side::Up => self.up,
            Side::Left => self.left,
            _ => self.right,
        }
    }
}

#[derive(Debug, RustcDecodable, RustcEncodable)]
struct Tree<K, V> {
    root: NodePtr,
    store: Vec<Node<K, V>>,
}

impl<K: Ord + Copy + Debug + Display, V: Debug + Copy + Display> Tree<K, V> {
    pub fn get_node(&self, np: NodePtr) -> Node<K, V> {
        assert!(np.is_some());
        self.store[np.unwrap()]
    }

    pub fn get_pointer(&self, np: NodePtr, side: Side) -> NodePtr {
        assert!(np.is_some());
        self.store[np.unwrap()].get_ptr(side)
    }

    // Prints the tree with root p.  The idea is to do an in-order traversal
    // (reverse in-order in this case, where right is on top), and print nodes as they
    // are visited, one per line. Each invocation of display() gets its own copy
    // of the display element vector e, which is grown with either whitespace or
    // a trunk element, then modified in its last and possibly second-to-last
    // characters in context.
    fn display(&self, p: NodePtr, side: Side, e: &Vec<DisplayElement>, f: &mut Formatter) {
        if p.is_none() {
            return;
        }

        let mut elems = e.clone();
        let node = self.get_node(p);
        let mut tail = DisplayElement::SpaceSpace;
        if node.up != self.root {
            // If the direction is switching, I need the trunk element to appear in the lines
            // printed before that node is visited.
            if side == Side::Left && node.right.is_some() {
                elems.push(DisplayElement::TrunkSpace);
            } else {
                elems.push(DisplayElement::SpaceSpace);
            }
        }
        let hindex = elems.len() - 1;
        self.display(node.right, Side::Right, &elems, f);

        if p == self.root {
            elems[hindex] = DisplayElement::Root;
            tail = DisplayElement::TrunkSpace;
        } else if side == Side::Right {
            // Right subtree finished
            elems[hindex] = DisplayElement::SpaceRight;
            // Prepare trunk element in case there is a left subtree
            tail = DisplayElement::TrunkSpace;
        } else if side == Side::Left {
            elems[hindex] = DisplayElement::SpaceLeft;
            let parent = self.get_node(node.up);
            if parent.up.is_some() && self.get_pointer(parent.up, Side::Right) == node.up {
                // Direction switched, need trunk element starting with this node/line
                elems[hindex - 1] = DisplayElement::TrunkSpace;
            }
        }

        // Visit node => print accumulated elements. Each node gets a line and each line gets a
        // node.
        for e in elems.clone() {
            let _ = write!(f, "{}", e.string());
        }
        let _ = write!(f,
                       "{key:>width$} ",
                       key = Green.bold().paint(node.key),
                       width = 2);
        let _ = write!(f,
                       "{value:>width$}\n",
                       value = Blue.bold().paint(format!("{:.*}", 2, node.value)),
                       width = 4);

        // Overwrite last element before continuing traversal
        elems[hindex] = tail;

        self.display(node.left, Side::Left, &elems, f);
    }
}

impl<K: Ord + Copy + Debug + Display, V: Debug + Copy + Display> Display for Tree<K, V> {
    fn fmt(&self, f: &mut Formatter) -> Result {
        if self.root.is_none() {
            write!(f, "[empty]")
        } else {
            let mut v: Vec<DisplayElement> = Vec::new();
            self.display(self.root, Side::Up, &mut v, f);
            Ok(())
        }
    }
}

/// Decodes and prints a previously generated tree.
fn main() {
    let encoded = r#"{"root":0,"store":[{"key":0,"value":0.45,"left":1,"right":3,
        "up":null},{"key":-8,"value":-0.94,"left":7,"right":2,"up":0}, {"key":-1,
        "value":0.15,"left":8,"right":null,"up":1},{"key":7, "value":-0.29,"left":4,
        "right":9,"up":0},{"key":5,"value":0.80,"left":5,"right":null,"up":3},
        {"key":4,"value":-0.85,"left":6,"right":null,"up":4},{"key":3,"value":-0.46,
        "left":null,"right":null,"up":5},{"key":-10,"value":-0.85,"left":null,
        "right":13,"up":1},{"key":-6,"value":-0.42,"left":null,"right":10,"up":2},
        {"key":9,"value":0.63,"left":12,"right":null,"up":3},{"key":-3,"value":-0.83,
        "left":null,"right":11,"up":8},{"key":-2,"value":0.75,"left":null,"right":null,
        "up":10},{"key":8,"value":-0.48,"left":null,"right":null,"up":9},{"key":-9,
        "value":0.53,"left":null,"right":null,"up":7}]}"#;
    let tree: Tree<i32, f32> = json::decode(&encoded).unwrap();
    println!("{}", tree);
}
