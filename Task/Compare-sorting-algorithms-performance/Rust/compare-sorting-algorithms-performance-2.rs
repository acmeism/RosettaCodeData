fn ones(len: u32) -> Vec<u32> {
    vec![1; len as usize]
}

fn sequence(len: u32) -> Vec<u32> {
    (1..=len).collect()
}

fn random(mut rng: &mut rand::rngs::ThreadRng, len: u32) -> Vec<u32> {
    use rand::seq::SliceRandom;

    let mut seq = sequence(len);
    seq.shuffle(&mut rng);

    seq
}
