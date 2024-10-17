#[derive(Clone)]
struct FCNode {
    index: usize,
    name: String,
    weight: i32,
    coverage: f64,
    children: Vec<usize>,
    parent: Option<usize>,
}
impl FCNode {
    fn new() -> Self {
        Self {
            index: 0,
            name: "".to_string(),
            weight: 1,
            coverage: 0.0,
            children: vec![],
            parent: None,
        }
    }
}

fn update_coverage(nodes: &mut Vec<FCNode>, node: usize) {
    if !nodes[node].children.is_empty() {
        let num = nodes[node]
            .children
            .iter()
            .fold(0.0, |sum, child| sum + nodes[*child].weight as f64 * nodes[*child].coverage);
        let denom = nodes[node]
            .children
            .iter()
            .fold(0.0, |sum, child| sum + nodes[*child].weight as f64);
        nodes[node].coverage = num / denom;
    }
    match nodes[node].parent {
        Some(idx) => update_coverage(nodes, idx),
        None => (),
    }
}

fn add_children(nodes: &mut Vec<FCNode>, parent: usize, children: &mut Vec<usize>) {
    for child in children {
        nodes[parent].children.push(*child);
        nodes[*child].parent = Some(parent);
    }
    update_coverage(nodes, parent);
}

fn show(nodes: &Vec<FCNode>, node: usize, level: i32) {
    let indent = level * 4;
    let nl = nodes[node].name.len() + indent as usize;
    print!("{:>nl$}", nodes[node].name);
    print!("{1:>0$}", 32 - nl, "|");
    print!("  {:<3}   |", nodes[node].weight);
    println!(" {:<8.6} |", nodes[node].coverage);
    if !nodes[node].children.is_empty() {
        for child in nodes[node].children.iter() {
            show(nodes, *child, level + 1);
        }
    }
}

fn node1(nodes: &mut Vec<FCNode>, name: &str) -> usize {
    let mut new_node = FCNode::new();
    let idx = nodes.len();
    new_node.index = idx;
    new_node.name = name.to_owned();
    nodes.push(new_node);
    return idx;
}

fn node2(nodes: &mut Vec<FCNode>, name: &str, weight: i32) -> usize {
    let mut new_node = FCNode::new();
    let idx = nodes.len();
    new_node.index = idx;
    new_node.name = name.to_owned();
    new_node.weight = weight;
    nodes.push(new_node);
    return idx;
}
fn node3(nodes: &mut Vec<FCNode>, name: &str, weight: i32, coverage: f64) -> usize {
    let mut new_node = FCNode::new();
    let idx = nodes.len();
    new_node.index = idx;
    new_node.name = name.to_owned();
    new_node.weight = weight;
    new_node.coverage = coverage;
    nodes.push(new_node);
    return idx;
}

fn main() {
    let mut allnodes = vec![FCNode::new(); 1];
    let a = &mut allnodes;
    let mut houses = vec![node2(a, "house1", 40), node2(a, "house2", 60)];
    let mut house1 = vec![
        node3(a, "bedrooms", 1, 0.25),
        node1(a, "bathrooms"),
        node3(a, "attic", 1, 0.75),
        node3(a, "kitchen", 1, 0.1),
        node1(a, "living_rooms"),
        node1(a, "basement"),
        node1(a, "garage"),
        node3(a, "garden", 1, 0.8),
    ];
    let mut house2 = vec![
        node1(a, "upstairs"),
        node1(a, "groundfloor"),
        node1(a, "basement"),
    ];
    let mut h1_bathrooms = vec![
        node3(a, "bathroom1", 1, 0.5),
        node1(a, "bathroom2"),
        node3(a, "outside_lavatory", 1, 1.0),
    ];
    let mut h1_living_rooms = vec![
        node1(a, "lounge"),
        node1(a, "dining_room"),
        node1(a, "conservatory"),
        node3(a, "playroom", 1, 1.0),
    ];
    let mut h2_upstairs = vec![
        node1(a, "bedrooms"),
        node1(a, "bathroom"),
        node1(a, "toilet"),
        node3(a, "attics", 1, 0.6),
    ];
    let mut h2_ground_floor = vec![
        node1(a, "kitchen"),
        node1(a, "living_rooms"),
        node1(a, "wet_room_&_toilet"),
        node1(a, "garage"),
        node3(a, "garden", 1, 0.9),
        node3(a, "hot_tub_suite", 1, 1.0),
    ];
    let mut h2_basement = vec![
        node3(a, "cellars", 1, 1.0),
        node3(a, "wine_cellar", 1, 1.0),
        node3(a, "cinema", 1, 0.75),
    ];
    let mut h2_upstairs_bedrooms = vec![
        node1(a, "suite_1"),
        node1(a, "suite_2"),
        node1(a, "bedroom_3"),
        node1(a, "bedroom_4"),
    ];
    let mut h2_ground_floor_living_rooms = vec![
        node1(a, "lounge"),
        node1(a, "dining_room"),
        node1(a, "conservatory"),
        node1(a, "playroom"),
    ];
    let cleaning = node1(a, "cleaning");

    add_children(a, house1[1], &mut h1_bathrooms);
    add_children(a, house1[4], &mut h1_living_rooms);
    add_children(a, houses[0], &mut house1);

    add_children(a, h2_upstairs[0], &mut h2_upstairs_bedrooms);
    add_children(a, house2[0], &mut h2_upstairs);
    add_children(a, h2_ground_floor[1], &mut h2_ground_floor_living_rooms);
    add_children(a, house2[1], &mut h2_ground_floor);
    add_children(a, house2[2], &mut h2_basement);
    add_children(a, houses[1], &mut house2);

    add_children(a, cleaning, &mut houses);
    let top_coverage = a[cleaning].coverage;
    println!("TOP COVERAGE = {top_coverage:8.6}\n");
    println!("NAME HIERARCHY                 | WEIGHT | COVERAGE |");
    show(a, cleaning, 0);
    a[h2_basement[2]].coverage = 1.0; // change Cinema node coverage to 1.0
    update_coverage(a, h2_basement[2]);
    let diff = a[cleaning].coverage - top_coverage;
    println!("\nIf the coverage of the Cinema node were increased from 0.75 to 1.0");
    print!("the top level coverage would increase by ");
    println!("{:8.6} to {:8.6}", diff, top_coverage + diff);
    a[h2_basement[2]].coverage = 0.75; // restore to original value if required
}
