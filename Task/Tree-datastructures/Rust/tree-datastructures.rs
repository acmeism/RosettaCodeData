#[derive(Debug, Clone, PartialEq)]
pub struct NestTree {
    name: String,
    children: Vec<NestTree>,
}

impl NestTree {
    pub fn new(name: &str) -> Self {
        NestTree {
            name: name.to_string(),
            children: Vec::new(),
        }
    }

    pub fn add_child(&mut self, name: &str) {
        self.children.push(NestTree::new(name));
    }

    pub fn get_child_mut(&mut self, index: usize) -> Option<&mut NestTree> {
        self.children.get_mut(index)
    }

    pub fn print(&self) {
        self.print_with_level(0);
    }

    fn print_with_level(&self, level: usize) {
        let indent = " ".repeat(level * 4);
        println!("{}{}", indent, self.name);
        for child in &self.children {
            child.print_with_level(level + 1);
        }
    }

    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn children(&self) -> &[NestTree] {
        &self.children
    }

    pub fn equals(&self, other: &NestTree) -> bool {
        self == other
    }
}

pub struct IndentTree {
    items: Vec<(i32, String)>,
}

impl IndentTree {
    pub fn new(nest: &NestTree) -> Self {
        let mut items = Vec::new();
        items.push((0, nest.name().to_string()));

        let mut indent_tree = IndentTree { items };
        indent_tree.from_nest(nest, 0);
        indent_tree
    }

    fn from_nest(&mut self, nest: &NestTree, level: i32) {
        for child in nest.children() {
            self.items.push((level + 1, child.name().to_string()));
            self.from_nest(child, level + 1);
        }
    }

    pub fn print(&self) {
        for (level, name) in &self.items {
            println!("{} {}", level, name);
        }
    }

    pub fn to_nest(&self) -> NestTree {
        let mut nest = NestTree::new(&self.items[0].1);
        self.to_nest_recursive(&mut nest, 1, 0);
        nest
    }

    fn to_nest_recursive(&self, nest: &mut NestTree, mut pos: usize, level: i32) -> usize {
        while pos < self.items.len() && self.items[pos].0 == level + 1 {
            nest.add_child(&self.items[pos].1);
            let child_index = nest.children().len() - 1;
            if let Some(child) = nest.get_child_mut(child_index) {
                pos = self.to_nest_recursive(child, pos + 1, level + 1);
            } else {
                pos += 1;
            }
        }
        pos
    }
}

fn main() {
    let mut n = NestTree::new("RosettaCode");

    // Add children
    n.add_child("rocks");
    n.add_child("mocks");

    // Access children by index to avoid borrowing issues
    if let Some(child1) = n.get_child_mut(0) {
        child1.add_child("code");
        child1.add_child("comparison");
        child1.add_child("wiki");
    }

    if let Some(child2) = n.get_child_mut(1) {
        child2.add_child("trolling");
    }

    println!("Initial nest format:");
    n.print();

    let i = IndentTree::new(&n);
    println!("\nIndent format:");
    i.print();

    let n2 = i.to_nest();
    println!("\nFinal nest format:");
    n2.print();

    println!("\nAre initial and final nest formats equal? {}", n.equals(&n2));
}
