use std::collections::{HashMap, HashSet};

const ALL_COLOURS: [&str; 7] = ["PINK", "ORANGE", "CYAN", "YELLOW", "RED", "GREEN", "BLUE"];

#[derive(Debug, Clone)]
struct Node {
    id: i32,
    saturation: i32,
    colour: String,
    excluded_from_search: bool,
}

impl Node {
    fn new(id: i32, saturation: i32, colour: String) -> Self {
        Node {
            id,
            saturation,
            colour,
            excluded_from_search: false,
        }
    }

    fn default() -> Self {
        Node {
            id: 0,
            saturation: 0,
            colour: "NO_COLOUR".to_string(),
            excluded_from_search: false,
        }
    }
}

fn main() {
    let graph_representations: [&str; 4] = [
        "0-1 1-2 2-0 3",
        "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7",
        "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6",
        "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7",
    ];

    for graph_representation in graph_representations {
        let mut graph: HashMap<i32, Node> = HashMap::new();
        let mut neighbours: HashMap<i32, HashSet<i32>> = HashMap::new();

        for element in graph_representation.split_whitespace() {
            if element.contains("-") {
                let parts: Vec<&str> = element.split("-").collect();
                let id1: i32 = parts[0].parse().unwrap();
                let id2: i32 = parts[1].parse().unwrap();

                if !graph.contains_key(&id1) {
                    graph.insert(id1, Node::new(id1, 0, "NO_COLOUR".to_string()));
                }
                //let node1 = graph.get(&id1).unwrap().clone(); // No need to clone

                if !graph.contains_key(&id2) {
                    graph.insert(id2, Node::new(id2, 0, "NO_COLOUR".to_string()));
                }
                //let node2 = graph.get(&id2).unwrap().clone(); // No need to clone

                neighbours.entry(id1).or_insert(HashSet::new()).insert(id2);
                neighbours.entry(id2).or_insert(HashSet::new()).insert(id1);
            } else {
                let id: i32 = element.parse().unwrap();
                if !graph.contains_key(&id) {
                    graph.insert(id, Node::new(id, 0, "NO_COLOUR".to_string()));
                }
            }
        }

        for _ in 0..graph.len() {
            let mut max_node_id: i32 = -1;
            let mut max_saturation: i32 = -1;

            for (&key, value) in &graph {
                if !value.excluded_from_search && value.saturation > max_saturation {
                    max_saturation = value.saturation;
                    max_node_id = key;
                }
            }

            let mut colours_used: HashSet<String> = HashSet::new();
            if let Some(neighbors) = neighbours.get(&max_node_id) {
                for &neighbour in neighbors {
                    if let Some(neighbor_node) = graph.get(&neighbour) {
                        colours_used.insert(neighbor_node.colour.clone());
                    }
                }
            }

            let mut min_colour = String::new();
            for &colour in &ALL_COLOURS {
                if !colours_used.contains(colour) {
                    min_colour = colour.to_string();
                    break;
                }
            }

            if let Some(node) = graph.get_mut(&max_node_id) {
                node.excluded_from_search = true;
                node.colour = min_colour.clone();
            }

            if let Some(neighbors) = neighbours.get(&max_node_id) {
                for &neighbour in neighbors {
                    if let Some(neighbor_node) = graph.get_mut(&neighbour) {
                        if neighbor_node.colour == "NO_COLOUR" {
                            neighbor_node.saturation = colours_used.len() as i32;
                        }
                    }
                }
            }
        }

        let mut graph_colours: HashSet<String> = HashSet::new();
        for (&key, value) in &graph {
            graph_colours.insert(value.colour.clone());
            print!("Node {}:   colour = {}", key, value.colour);

            if let Some(neighbors) = neighbours.get(&key) {
                if !neighbors.is_empty() {
                    print!("{}", " ".repeat(8 - value.colour.len()));
                    print!("neighbours = ");
                    for &neighbour in neighbors {
                        print!("{} ", neighbour);
                    }
                }
            }
            println!();
        }
        println!("Number of colours used: {}", graph_colours.len());
        println!();
    }
}
