#[derive(Debug, Clone)]
struct Node {
    sub: String,        // a substring of the input string
    ch: Vec<usize>,     // vector of child node indices
}

impl Node {
    fn new() -> Self {
        Node {
            sub: String::new(),
            ch: Vec::new(),
        }
    }

    fn with_data(sub: String, children: Vec<usize>) -> Self {
        Node { sub, ch: children }
    }
}

struct SuffixTree {
    nodes: Vec<Node>,
}

impl SuffixTree {
    fn new(s: &str) -> Self {
        let mut tree = SuffixTree {
            nodes: vec![Node::new()],
        };

        for i in 0..s.len() {
            tree.add_suffix(&s[i..]);
        }

        tree
    }

    fn visualize(&self) {
        if self.nodes.is_empty() {
            println!("<empty>");
            return;
        }

        self.visualize_node(0, "");
    }

    fn visualize_node(&self, n: usize, pre: &str) {
        let children = &self.nodes[n].ch;

        if children.is_empty() {
            println!("- {}", self.nodes[n].sub);
            return;
        }

        println!("+ {}", self.nodes[n].sub);

        for (i, &child) in children.iter().enumerate() {
            if i == children.len() - 1 {
                // Last child
                print!("{}+-", pre);
                self.visualize_node(child, &format!("{}  ", pre));
            } else {
                print!("{}+-", pre);
                self.visualize_node(child, &format!("{}| ", pre));
            }
        }
    }

    fn add_suffix(&mut self, suf: &str) {
        let mut n = 0;
        let mut i = 0;
        let suf_bytes = suf.as_bytes();

        while i < suf.len() {
            let b = suf_bytes[i];
            let mut x2 = 0;
            let n2;

            loop {
                let children = self.nodes[n].ch.clone();
                if x2 == children.len() {
                    // no matching child, remainder of suf becomes new node
                    n2 = self.nodes.len();
                    self.nodes.push(Node::with_data(suf[i..].to_string(), Vec::new()));
                    self.nodes[n].ch.push(n2);
                    return;
                }

                let child_idx = children[x2];
                if self.nodes[child_idx].sub.as_bytes()[0] == b {
                    n2 = child_idx;
                    break;
                }
                x2 += 1;
            }

            // find prefix of remaining suffix in common with child
            let sub2 = self.nodes[n2].sub.clone();
            let sub2_bytes = sub2.as_bytes();
            let mut j = 0;

            while j < sub2.len() && i + j < suf.len() {
                if suf_bytes[i + j] != sub2_bytes[j] {
                    // split n2
                    let n3 = n2;
                    // new node for the part in common
                    let new_n2 = self.nodes.len();
                    let common_part = sub2[..j].to_string();
                    self.nodes.push(Node::with_data(common_part, vec![n3]));

                    // old node loses the part in common
                    self.nodes[n3].sub = sub2[j..].to_string();
                    self.nodes[n].ch[x2] = new_n2;
                    break; // continue down the tree
                }
                j += 1;
            }

            i += j; // advance past part in common
            n = if j < sub2.len() {
                // We split the node, use the new intermediate node
                self.nodes.len() - 1
            } else {
                n2
            }; // continue down the tree
        }
    }
}

fn main() {
    let tree = SuffixTree::new("banana$");
    tree.visualize();
}
