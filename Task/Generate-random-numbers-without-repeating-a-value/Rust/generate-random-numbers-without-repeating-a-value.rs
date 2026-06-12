// [dependencies]
// rand = "0.7.2"

fn main() {
    use rand::seq::SliceRandom;
    use rand::thread_rng;
    let mut rng = thread_rng();
    let mut v: Vec<u32> = (1..=20).collect();
    v.shuffle(&mut rng);
    println!("{:?}", v);
}
