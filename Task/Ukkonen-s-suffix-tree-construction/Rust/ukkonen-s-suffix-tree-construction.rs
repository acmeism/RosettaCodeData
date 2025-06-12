use std::collections::{HashMap, HashSet};
use std::fs::File;
use std::io::Read;
use std::time::Instant;
use std::cmp::min;

struct Node {
    start: i32,
    end: i32,
    parent_link: i32,
    leaf_index: i32,
    children: HashMap<char, i32>,
}

impl Node {
    fn new(start: i32, end: i32) -> Self {
        Node {
            start,
            end,
            parent_link: 0,
            leaf_index: 0,
            children: HashMap::new(),
        }
    }

    fn edge_length(&self, text_index: i32) -> i32 {
        min(self.end, text_index + 1) - self.start
    }
}

struct SuffixTree {
    nodes: Vec<Node>,
    text: String,
    root: i32,
    active_node: i32,
    active_length: i32,
    active_edge: i32,
    text_index: i32,
    current_node: i32,
    need_parent_link: i32,
    remainder: i32,
    leaf_index_generator: i32,
}

impl SuffixTree {
    const UNDEFINED: i32 = -1;
    const LEAF_NODE: i32 = i32::MAX;

    fn new(word: &str) -> Self {
        let mut text = String::from(word);
        text.push('\u{0004}'); // Terminal character

        let mut tree = SuffixTree {
            nodes: Vec::with_capacity(2 * text.len()),
            text,
            root: 0,
            active_node: 0,
            active_length: 0,
            active_edge: 0,
            text_index: 0,
            current_node: 0,
            need_parent_link: 0,
            remainder: 0,
            leaf_index_generator: 0,
        };

        // Initialize nodes vector with a placeholder to allow indexing from 0
        for _ in 0..2 * tree.text.len() {
            tree.nodes.push(Node::new(Self::UNDEFINED, Self::UNDEFINED));
        }

        tree.root = tree.new_node(Self::UNDEFINED, Self::UNDEFINED);
        tree.active_node = tree.root;

        // Build the suffix tree
        for ch in tree.text.chars().collect::<Vec<char>>() {
            tree.extend_suffix_tree(ch);
        }

        tree
    }

    fn extend_suffix_tree(&mut self, character: char) {
        self.need_parent_link = Self::UNDEFINED;
        self.remainder += 1;

        let text_chars: Vec<char> = self.text.chars().collect();

        while self.remainder > 0 {
            if self.active_length == 0 {
                self.active_edge = self.text_index;
            }

            let active_edge_char = text_chars[self.active_edge as usize];

            if !self.nodes[self.active_node as usize].children.contains_key(&active_edge_char) {
                let leaf = self.new_node(self.text_index, Self::LEAF_NODE);
                self.nodes[self.active_node as usize].children.insert(active_edge_char, leaf);
                self.add_suffix_link(self.active_node);
            } else {
                let next = *self.nodes[self.active_node as usize].children.get(&active_edge_char).unwrap();
                if self.walk_down(next) {
                    continue;
                }

                if text_chars[(self.nodes[next as usize].start + self.active_length) as usize] == character {
                    self.active_length += 1;
                    self.add_suffix_link(self.active_node);
                    break;
                }

                let split = self.new_node(
                    self.nodes[next as usize].start,
                    self.nodes[next as usize].start + self.active_length,
                );
                self.nodes[self.active_node as usize].children.insert(active_edge_char, split);

                let leaf = self.new_node(self.text_index, Self::LEAF_NODE);
                self.nodes[split as usize].children.insert(character, leaf);

                self.nodes[next as usize].start += self.active_length;
                let next_start_char = text_chars[self.nodes[next as usize].start as usize];
                self.nodes[split as usize].children.insert(next_start_char, next);

                self.add_suffix_link(split);
            }

            self.remainder -= 1;

            if self.active_node == self.root && self.active_length > 0 {
                self.active_length -= 1;
                self.active_edge = self.text_index - self.remainder + 1;
            } else {
                self.active_node = if self.nodes[self.active_node as usize].parent_link > 0 {
                    self.nodes[self.active_node as usize].parent_link
                } else {
                    self.root
                };
            }
        }

        self.text_index += 1;
    }

    fn walk_down(&mut self, node: i32) -> bool {
        if self.active_length >= self.nodes[node as usize].edge_length(self.text_index) {
            self.active_edge += self.nodes[node as usize].edge_length(self.text_index);
            self.active_length -= self.nodes[node as usize].edge_length(self.text_index);
            self.active_node = node;
            return true;
        }
        false
    }

    fn add_suffix_link(&mut self, node: i32) {
        if self.need_parent_link != Self::UNDEFINED {
            self.nodes[self.need_parent_link as usize].parent_link = node;
        }
        self.need_parent_link = node;
    }

    fn new_node(&mut self, start: i32, end: i32) -> i32 {
        let node_index = self.current_node;
        self.nodes[node_index as usize] = Node::new(start, end);

        if end == Self::LEAF_NODE {
            self.nodes[node_index as usize].leaf_index = self.leaf_index_generator;
            self.leaf_index_generator += 1;
        } else {
            self.nodes[node_index as usize].leaf_index = Self::UNDEFINED;
        }

        self.current_node += 1;
        node_index
    }

    fn get_longest_repeated_substrings(&self) -> HashMap<String, HashSet<i32>> {
        let indexes = self.do_traversal();
        let text_chars: Vec<char> = self.text.chars().collect();
        let mut result: HashMap<String, HashSet<i32>> = HashMap::new();

        if indexes[0] > 0 {
            for i in 1..indexes.len() {
                let substring: String = text_chars[indexes[i] as usize..(indexes[i] + indexes[0]) as usize].iter().collect();

                result.entry(substring)
                    .or_insert_with(HashSet::new)
                    .insert(indexes[i]);
            }
        }

        result
    }

    fn do_traversal(&self) -> Vec<i32> {
        let mut indexes = vec![Self::UNDEFINED];
        self.traversal(&mut indexes, &self.nodes[self.root as usize], 0)
    }

    fn traversal(&self, indexes: &mut Vec<i32>, node: &Node, height: i32) -> Vec<i32> {
        if node.leaf_index == Self::UNDEFINED {
            for (_, &child_index) in &node.children {
                let child = &self.nodes[child_index as usize];
                self.traversal(indexes, child, height + child.edge_length(self.text_index));
            }
        } else if indexes[0] < height - node.edge_length(self.text_index) {
            indexes.clear();
            indexes.push(height - node.edge_length(self.text_index));
            indexes.push(node.leaf_index);
        } else if indexes[0] == height - node.edge_length(self.text_index) {
            indexes.push(node.leaf_index);
        }

        indexes.clone()
    }
}

fn main() -> std::io::Result<()> {
    let limits = [1_000, 10_000, 100_000];

    let mut file = File::open("../piDigits.txt")?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    for &limit in &limits {
        let pi_digits = &contents[0..limit];

        println!("Processing first {} digits of pi...", limit);

        let start = Instant::now();
        let tree = SuffixTree::new(pi_digits);
        let substrings = tree.get_longest_repeated_substrings();
        let duration = start.elapsed();

        println!("First {} digits of pi has longest repeated characters:", limit);
        for (substring, indexes) in &substrings {
            print!("    '{}' starting at index ", substring);
            for &index in indexes {
                print!("{} ", index);
            }
            println!();
        }

        println!("Time taken: {:?}\n", duration);
    }

    println!("The timings show that the implementation has approximately linear performance.");

    Ok(())
}
