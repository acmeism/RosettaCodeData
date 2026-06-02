use std::collections::{HashMap, HashSet};

#[derive(Debug)]
struct Library<'a> {
    name: &'a str,
    children: Vec<&'a str>,
    num_parents: usize,
}

impl<'a> Library<'a> {
    const fn new(name: &'a str) -> Self {
        Self {
            name,
            children: Vec::new(),
            num_parents: 0,
        }
    }
}

fn build_libraries<'a>(input: &'a str) -> HashMap<&'a str, Library<'a>> {
    let mut libraries: HashMap<&'a str, Library<'a>> = HashMap::new();

    for input_line in input.lines() {
        let mut line_split = input_line.split_whitespace();
        let name = line_split.next().unwrap();
        let mut num_parents: usize = 0;
        for parent in line_split {
            if parent == name {
                continue;
            }
            libraries
                .entry(parent)
                .or_insert_with(|| Library::new(parent))
                .children
                .push(name);
            num_parents += 1;
        }

        libraries
            .entry(name)
            .or_insert_with(|| Library::new(name))
            .num_parents = num_parents;
    }
    libraries
}

fn topological_sort<'a>(
    mut libraries: HashMap<&'a str, Library<'a>>,
) -> Result<Vec<&'a str>, String> {
    let mut needs_processing = libraries.keys().copied().collect::<HashSet<&str>>();
    let mut options: Vec<&str> = libraries
        .iter()
        .filter_map(|(k, v)| (v.num_parents == 0).then_some(*k))
        .collect();
    let mut sorted: Vec<&str> = Vec::new();
    while let Some(cur) = options.pop() {
        let children = libraries.get(cur).unwrap().children.clone();
        for child_name in children {
            let child = libraries.get_mut(child_name).unwrap();
            child.num_parents -= 1;
            if child.num_parents == 0 {
                options.push(child.name);
            }
        }
        sorted.push(cur);
        needs_processing.remove(cur);
    }
    if needs_processing.is_empty() {
        Ok(sorted)
    } else {
        Err(format!("Cycle detected among {needs_processing:?}"))
    }
}

fn main() {
    let input: &str = "\
        des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee\n\
        dw01             ieee dw01 dware gtech\n\
        dw02             ieee dw02 dware\n\
        dw03             std synopsys dware dw03 dw02 dw01 ieee gtech\n\
        dw04             dw04 ieee dw01 dware gtech\n\
        dw05             dw05 ieee dware\n\
        dw06             dw06 ieee dware\n\
        dw07             ieee dware\n\
        dware            ieee dware\n\
        gtech            ieee gtech\n\
        ramlib           std ieee\n\
        std_cell_lib     ieee std_cell_lib\n\
        synopsys\
    ";

    let libraries = build_libraries(input);
    match topological_sort(libraries) {
        Ok(sorted) => println!("{sorted:?}"),
        Err(msg) => println!("{msg:?}"),
    }
}

