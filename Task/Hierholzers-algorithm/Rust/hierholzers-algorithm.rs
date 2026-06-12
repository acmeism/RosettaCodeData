use std::collections::HashMap;
use std::vec::Vec;

fn print_circuit(mut adj: Vec<Vec<usize>>) {
    // adj represents the adjacency list of
    // the directed graph
    // edge_count represents the number of edges
    // emerging from a vertex
    let mut edge_count: HashMap<usize, usize> = HashMap::new();

    for i in 0..adj.len() {
        //find the count of edges to keep track
        //of unused edges
        edge_count.insert(i, adj[i].len());
    }

    if adj.is_empty() {
        return; //empty graph
    }

    // Maintain a stack to keep vertices
    let mut curr_path: Vec<usize> = Vec::new();

    // vector to store final circuit
    let mut circuit: Vec<usize> = Vec::new();

    // start from any vertex
    curr_path.push(0);
    let mut curr_v: usize = 0; // Current vertex

    while !curr_path.is_empty() {
        // If there's remaining edge
        if *edge_count.get(&curr_v).unwrap() > 0 {
            // Push the vertex
            curr_path.push(curr_v);

            // Find the next vertex using an edge
            let next_v = adj[curr_v].pop().unwrap();

            // and remove that edge
            *edge_count.get_mut(&curr_v).unwrap() -= 1;


            // Move to next vertex
            curr_v = next_v;
        }
        // back-track to find remaining circuit
        else {
            circuit.push(curr_v);

            // Back-tracking
            curr_v = curr_path.pop().unwrap();
        }
    }

    // we've got the circuit, now print it in reverse
    for i in (0..circuit.len()).rev() {
        print!("{}", circuit[i]);
        if i > 0 {
            print!(" -> ");
        }
    }
}

// Driver program to check the above function
fn main() {
    let mut adj1: Vec<Vec<usize>> = Vec::new();

    // First adjacency list
    adj1.resize(3, Vec::new());

    // Build the edges
    adj1[0].push(1);
    adj1[1].push(2);
    adj1[2].push(0);
    print_circuit(adj1);
    println!();

    // Second adjacency list
    let mut adj2: Vec<Vec<usize>> = Vec::new();
    adj2.resize(7, Vec::new());
    adj2[0].push(1);
    adj2[0].push(6);
    adj2[1].push(2);
    adj2[2].push(0);
    adj2[2].push(3);
    adj2[3].push(4);
    adj2[4].push(2);
    adj2[4].push(5);
    adj2[5].push(0);
    adj2[6].push(4);
    print_circuit(adj2);
}
