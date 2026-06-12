use std::collections::{HashMap, HashSet};

fn bron_kerbosch_v2(
    r: &HashSet<String>,
    p: &mut HashSet<String>,
    x: &mut HashSet<String>,
    g: &HashMap<String, HashSet<String>>,
    cliques: &mut Vec<Vec<String>>,
) {
    if p.is_empty() && x.is_empty() {
        if r.len() > 2 {
            let mut clique: Vec<String> = r.iter().cloned().collect();
            clique.sort();
            cliques.push(clique);
        }
        return;
    }

    // Choose a pivot with the maximum degree in P ∪ X
    let pivot = p
        .union(x)
        .max_by_key(|v| g.get(*v).map_or(0, |neighbors| neighbors.len()))
        .cloned();

    if let Some(pivot_vertex) = pivot {
        let neighbors = g.get(&pivot_vertex).cloned().unwrap_or_default();
        let candidates: Vec<String> = p.difference(&neighbors).cloned().collect();

        for v in candidates {
            // New R is R ∪ {v}
            let mut new_r = r.clone();
            new_r.insert(v.clone());

            // New P is P ∩ N(v)
            let neighbors_v = g.get(&v).cloned().unwrap_or_default();
            let mut new_p = p.intersection(&neighbors_v).cloned().collect::<HashSet<String>>();

            // New X is X ∩ N(v)
            let mut new_x = x.intersection(&neighbors_v).cloned().collect::<HashSet<String>>();

            // Recursive call
            bron_kerbosch_v2(&new_r, &mut new_p, &mut new_x, g, cliques);

            // Move v from P to X
            p.remove(&v);
            x.insert(v);
        }
    }
}

fn main() {
    // Define the input edges
    let input = vec![
        ("a", "b"),
        ("b", "a"),
        ("a", "c"),
        ("c", "a"),
        ("b", "c"),
        ("c", "b"),
        ("d", "e"),
        ("e", "d"),
        ("d", "f"),
        ("f", "d"),
        ("e", "f"),
        ("f", "e"),
    ];

    // Build the graph as an adjacency list
    let mut graph: HashMap<String, HashSet<String>> = HashMap::new();
    for (src, dest) in input.iter() {
        graph
            .entry(src.to_string())
            .or_insert_with(HashSet::new)
            .insert(dest.to_string());
    }

    // Initialize R, P, X
    let r: HashSet<String> = HashSet::new();
    let mut p: HashSet<String> = graph.keys().cloned().collect();
    let mut x: HashSet<String> = HashSet::new();

    // Collect cliques
    let mut cliques: Vec<Vec<String>> = Vec::new();
    bron_kerbosch_v2(&r, &mut p, &mut x, &graph, &mut cliques);

    // Sort the cliques for consistent output
    let mut sorted_cliques = cliques.clone();
    sorted_cliques.sort();

    // Print each clique
    for clique in sorted_cliques {
        println!("{}", clique.join(", "));
    }
}
