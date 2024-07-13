#![feature(box_syntax, box_patterns)]

use std::collections::VecDeque;

#[derive(Debug)]
struct TreeNode<T> {
    value: T,
    left: Option<Box<TreeNode<T>>>,
    right: Option<Box<TreeNode<T>>>,
}

enum TraversalMethod {
    PreOrder,
    InOrder,
    PostOrder,
    LevelOrder,
}

impl<T> TreeNode<T> {
    pub fn new(arr: &[[i8; 3]]) -> TreeNode<i8> {

        let l = match arr[0][1] {
            -1 => None,
            i @ _ => Some(Box::new(TreeNode::<i8>::new(&arr[(i - arr[0][0]) as usize..]))),
        };
        let r = match arr[0][2] {
            -1 => None,
            i @ _ => Some(Box::new(TreeNode::<i8>::new(&arr[(i - arr[0][0]) as usize..]))),
        };

        TreeNode {
            value: arr[0][0],
            left: l,
            right: r,
        }
    }

    pub fn traverse(&self, tr: &TraversalMethod) -> Vec<&TreeNode<T>> {
        match tr {
            &TraversalMethod::PreOrder => self.iterative_preorder(),
            &TraversalMethod::InOrder => self.iterative_inorder(),
            &TraversalMethod::PostOrder => self.iterative_postorder(),
            &TraversalMethod::LevelOrder => self.iterative_levelorder(),
        }
    }

    fn iterative_preorder(&self) -> Vec<&TreeNode<T>> {
        let mut stack: Vec<&TreeNode<T>> = Vec::new();
        let mut res: Vec<&TreeNode<T>> = Vec::new();

        stack.push(self);
        while !stack.is_empty() {
            let node = stack.pop().unwrap();
            res.push(node);
            match node.right {
                None => {}
                Some(box ref n) => stack.push(n),
            }
            match node.left {
                None => {}
                Some(box ref n) => stack.push(n),
            }
        }
        res
    }

    // From left to right
    fn iterative_inorder(&self) -> Vec<&TreeNode<T>> {
        let mut stack: Vec<&TreeNode<T>> = Vec::new();
        let mut res: Vec<&TreeNode<T>> = Vec::new();
        let mut opt = Some(self);

        while {
           // Descend leftwards
            while let Some(tree) = opt {
                stack.push(tree);
                opt = tree.left.as_deref();
            }
            !stack.is_empty()
        } {
            let tree = stack.pop().unwrap();
            res.push(tree);
            opt = tree.right.as_deref();
        }
        res
    }

    // Left-to-right postorder is same sequence as right-to-left preorder, reversed
    fn iterative_postorder(&self) -> Vec<&TreeNode<T>> {
        let mut stack: Vec<&TreeNode<T>> = Vec::new();
        let mut res: Vec<&TreeNode<T>> = Vec::new();

        stack.push(self);
        while !stack.is_empty() {
            let node = stack.pop().unwrap();
            res.push(node);
            match node.left {
                None => {}
                Some(box ref n) => stack.push(n),
            }
            match node.right {
                None => {}
                Some(box ref n) => stack.push(n),
            }
        }
        let rev_iter = res.iter().rev();
        let mut rev: Vec<&TreeNode<T>> = Vec::new();
        for elem in rev_iter {
            rev.push(elem);
        }
        rev
    }

    fn iterative_levelorder(&self) -> Vec<&TreeNode<T>> {
        let mut queue: VecDeque<&TreeNode<T>> = VecDeque::new();
        let mut res: Vec<&TreeNode<T>> = Vec::new();

        queue.push_back(self);
        while !queue.is_empty() {
            let node = queue.pop_front().unwrap();
            res.push(node);
            match node.left {
                None => {}
                Some(box ref n) => queue.push_back(n),
            }
            match node.right {
                None => {}
                Some(box ref n) => queue.push_back(n),
            }
        }
        res
    }
}

fn main() {
    // Array representation of task tree
    let arr_tree = [[1, 2, 3],
                    [2, 4, 5],
                    [3, 6, -1],
                    [4, 7, -1],
                    [5, -1, -1],
                    [6, 8, 9],
                    [7, -1, -1],
                    [8, -1, -1],
                    [9, -1, -1]];

    let root = TreeNode::<i8>::new(&arr_tree);

    for method_label in [(TraversalMethod::PreOrder, "pre-order:"),
                         (TraversalMethod::InOrder, "in-order:"),
                         (TraversalMethod::PostOrder, "post-order:"),
                         (TraversalMethod::LevelOrder, "level-order:")]
                            .iter() {
        print!("{}\t", method_label.1);
        for n in root.traverse(&method_label.0) {
            print!(" {}", n.value);
        }
        print!("\n");
    }
}
