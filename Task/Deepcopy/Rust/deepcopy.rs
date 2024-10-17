// The compiler can automatically implement Clone on structs (assuming all members have implemented Clone).
#[derive(Clone)]
struct Tree<T> {
    left: Leaf<T>,
    data: T,
    right: Leaf<T>,
}

type Leaf<T> = Option<Box<Tree<T>>>;

impl<T> Tree<T> {
    fn root(data: T) -> Self {
        Self { left: None, data, right: None }
    }

    fn leaf(d: T) -> Leaf<T> {
        Some(Box::new(Self::root(d)))
    }
}

fn main() {
    let mut tree = Tree::root([4, 5, 6]);
    tree.right = Tree::leaf([1, 2, 3]);
    tree.left = Tree::leaf([7, 8, 9]);

    let newtree = tree.clone();
}
