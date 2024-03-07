use std::collections::HashMap;
use std::convert::TryInto;

struct Node {
    length: isize,
    edges: HashMap<u8, usize>,
    suffix: usize,
}

impl Node {
    fn new(length: isize, suffix: usize) -> Self {
        Node {
            length,
            suffix,
            edges: HashMap::new(),
        }
    }
}

const EVEN_ROOT: usize = 0;
const ODD_ROOT: usize = 1;

fn eertree(s: &[u8]) -> Vec<Node> {
    let mut tree = vec![
        Node::new(0, ODD_ROOT), // even root
        Node::new(-1, ODD_ROOT), // odd root
    ];

    let mut suffix = ODD_ROOT;

    for (i, &c) in s.iter().enumerate() {
        let mut n = suffix;
        let mut k;

        loop {
            k = tree[n].length;
            let k_plus_one: usize = (k + 1).try_into().unwrap_or(0);
            if let Some(b) = i.checked_sub(k_plus_one) {
                if b < s.len() && s[b] == c {
                    break;
                }
            }
            n = tree[n].suffix;
        }

        if tree[n].edges.contains_key(&c) {
            suffix = tree[n].edges[&c];
            continue;
        }

        suffix = tree.len();
        tree.push(Node::new(k + 2, 0));
        tree[n].edges.insert(c, suffix);

        if tree[suffix].length == 1 {
            tree[suffix].suffix = EVEN_ROOT;
            continue;
        }

        loop {
            n = tree[n].suffix;
            let tree_n_length_plus_one: usize = (tree[n].length + 1).try_into().unwrap_or(0);
            if let Some(b) = i.checked_sub(tree_n_length_plus_one) {
                if b < s.len() && s[b] == c {
                    break;
                }
            }
        }

        tree[suffix].suffix = tree[n].edges[&c];
    }

    tree
}

fn sub_palindromes(tree: &[Node]) -> Vec<String> {
    let mut result = Vec::new();
    fn children(node: usize, p: String, tree: &[Node], result: &mut Vec<String>) {
        for (&c, &n) in &tree[node].edges {
            let c = c as char;
            let p_new = format!("{}{}{}", c, p, c);
            result.push(p_new.clone());
            children(n, p_new, tree, result);
        }
    }

    children(EVEN_ROOT, String::new(), tree, &mut result);

    for (&c, &n) in &tree[ODD_ROOT].edges {
        let c = c as char;
        let p = c.to_string();
        result.push(p.clone());
        children(n, p, tree, &mut result);
    }

    result
}

fn main() {
    let tree = eertree(b"eertree");
    let palindromes = sub_palindromes(&tree);
    for palindrome in palindromes {
        println!("{}", palindrome);
    }
}
