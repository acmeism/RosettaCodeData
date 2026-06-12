struct BinaryTree<T> {
    node: Option<T>,
    left_subtree: Option<Box<BinaryTree<T>>>,
    right_subtree: Option<Box<BinaryTree<T>>>,
}

impl<T: Ord + Clone> BinaryTree<T> {
    fn new() -> Self {
        BinaryTree {
            node: None,
            left_subtree: None,
            right_subtree: None,
        }
    }

    fn insert(&mut self, item: T) {
        if self.node.is_none() {
            self.node = Some(item);
            self.left_subtree = Some(Box::new(BinaryTree::new()));
            self.right_subtree = Some(Box::new(BinaryTree::new()));
        } else if item < self.node.clone().unwrap() {
            self.left_subtree.as_mut().unwrap().insert(item);
        } else {
            self.right_subtree.as_mut().unwrap().insert(item);
        }
    }

    fn in_order(&self, result: &mut Vec<T>) {
        if self.node.is_none() {
            return;
        }
        self.left_subtree.as_ref().unwrap().in_order(result);
        result.push(self.node.clone().unwrap());
        self.right_subtree.as_ref().unwrap().in_order(result);
    }
}

fn tree_sort<T: Ord + Clone>(data: &[T]) -> Vec<T> {
    let mut search_tree = BinaryTree::new();
    for item in data {
        search_tree.insert(item.clone());
    }

    let mut sorted_list = Vec::new();
    search_tree.in_order(&mut sorted_list);
    sorted_list
}

fn print_list<T: std::fmt::Display>(data: &[T], sorted_flag: bool) {
    for item in data {
        print!("{} ", item);
    }
    if !sorted_flag {
        print!("-> ");
    } else {
        println!();
    }
}

fn main() {
    let sl = vec![5, 3, 7, 9, 1];
    print_list(&sl, false);
    let lls = tree_sort(&sl);
    print_list(&lls, true);

    let sl2 = vec!['d', 'c', 'e', 'b', 'a'];
    print_list(&sl2, false);
    let lls2 = tree_sort(&sl2);
    print_list(&lls2, true);
}
