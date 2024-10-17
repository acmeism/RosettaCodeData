use std::collections::BTreeMap;
use std::collections::binary_heap::BinaryHeap;

#[derive(Debug, Eq, PartialEq)]
enum NodeKind {
    Internal(Box<Node>, Box<Node>),
    Leaf(char),
}

#[derive(Debug, Eq, PartialEq)]
struct Node {
    frequency: usize,
    kind: NodeKind,
}

impl Ord for Node {
    fn cmp(&self, rhs: &Self) -> std::cmp::Ordering {
        rhs.frequency.cmp(&self.frequency)
    }
}

impl PartialOrd for Node {
    fn partial_cmp(&self, rhs: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(&rhs))
    }
}

type HuffmanCodeMap = BTreeMap<char, Vec<u8>>;

fn main() {
    let text = "this is an example for huffman encoding";

    let mut frequencies = BTreeMap::new();
    for ch in text.chars() {
        *frequencies.entry(ch).or_insert(0) += 1;
    }

    let mut prioritized_frequencies = BinaryHeap::new();
    for counted_char in frequencies {
        prioritized_frequencies.push(Node {
            frequency: counted_char.1,
            kind: NodeKind::Leaf(counted_char.0),
        });
    }

    while prioritized_frequencies.len() > 1 {
        let left_child = prioritized_frequencies.pop().unwrap();
        let right_child = prioritized_frequencies.pop().unwrap();
        prioritized_frequencies.push(Node {
            frequency: right_child.frequency + left_child.frequency,
            kind: NodeKind::Internal(Box::new(left_child), Box::new(right_child)),
        });
    }

    let mut codes = HuffmanCodeMap::new();
    generate_codes(
        prioritized_frequencies.peek().unwrap(),
        vec![0u8; 0],
        &mut codes,
    );

    for item in codes {
        print!("{}: ", item.0);
        for bit in item.1 {
            print!("{}", bit);
        }
        println!();
    }
}

fn generate_codes(node: &Node, prefix: Vec<u8>, out_codes: &mut HuffmanCodeMap) {
    match node.kind {
        NodeKind::Internal(ref left_child, ref right_child) => {
            let mut left_prefix = prefix.clone();
            left_prefix.push(0);
            generate_codes(&left_child, left_prefix, out_codes);

            let mut right_prefix = prefix;
            right_prefix.push(1);
            generate_codes(&right_child, right_prefix, out_codes);
        }
        NodeKind::Leaf(ch) => {
            out_codes.insert(ch, prefix);
        }
    }
}
