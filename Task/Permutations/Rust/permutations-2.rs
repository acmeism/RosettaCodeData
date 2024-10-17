use std::collections::VecDeque;

fn permute<T, F: Fn(&[T])>(used: &mut Vec<T>, unused: &mut VecDeque<T>, action: &F) {
    if unused.is_empty() {
        action(used);
    } else {
        for _ in 0..unused.len() {
            used.push(unused.pop_front().unwrap());
            permute(used, unused, action);
            unused.push_back(used.pop().unwrap());
        }
    }
}

fn main() {
    let mut queue = (1..4).collect::<VecDeque<_>>();
    permute(&mut Vec::new(), &mut queue, &|perm| println!("{:?}", perm));
}
