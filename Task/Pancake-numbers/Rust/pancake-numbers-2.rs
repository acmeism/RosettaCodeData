use std::collections::HashMap;

fn pancake_flips(len: usize) -> Option<(Vec<i32>, i32)> {
    if len < 1 {
        return None;
    }
    let goal_stack: Vec<i32> = (1..len as i32 + 1).collect();
    let mut stacks: HashMap<Vec<i32>, i32> = HashMap::new();
    stacks.insert(goal_stack.clone(), 0);
    let mut num_stacks = 1;
    let mut new_stacks = stacks.clone();
    for i in 1..1001 {
        let mut next_stacks: HashMap<Vec<i32>, i32> = HashMap::new();
        for (arr, _steps) in &new_stacks {
            for pos in 1_usize..(len + 1) {
                let mut new_stack = arr[0..pos].to_vec();
                new_stack.reverse();
                new_stack.extend_from_slice(&arr[pos..arr.len()]);
                if !stacks.contains_key(&new_stack) {
                    next_stacks.insert(new_stack.clone(), i);
                }
            }
        }
        new_stacks = next_stacks;
        stacks.extend(new_stacks.clone().into_iter());
        let perms = stacks.len();
        if perms == num_stacks {
            match stacks.into_iter().max_by_key(|p| p.1) {
                Some(pair) => return Some(pair),
                None => break,
            }
        }
        num_stacks = perms;
    }
    None
}

fn main() {
    for i in 1..=10 {
        match pancake_flips(i) {
            Some(p) => println!("pancake({:>2}) = {:<5} example: {:?}", i, p.1, p.0),
            None => println!("Error: cannot flip stack with size {i}"),
        }
    }
}
