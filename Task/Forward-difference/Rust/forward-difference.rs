fn forward_difference(input_seq: Vec<i32>, order: u32) -> Vec<i32> {
    match order {
        0 => input_seq,
        1 => {
            let input_seq_iter = input_seq.into_iter();
            let clone_of_input_seq_iter = input_seq_iter.clone();
            input_seq_iter.zip(clone_of_input_seq_iter.skip(1)).map(|(current, next)| next - current).collect()
        },
        _ => forward_difference(forward_difference(input_seq, order - 1), 1),
    }
}

fn main() {
    let mut sequence = vec![90, 47, 58, 29, 22, 32, 55, 5, 55, 73];
    loop {
        println!("{:?}", sequence);
        sequence = forward_difference(sequence, 1);
        if sequence.is_empty() {
            break;
        }
    }
}
