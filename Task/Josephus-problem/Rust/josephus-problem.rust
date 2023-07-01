const N: usize = 41;
const K: usize = 3;
const M: usize = 3;
const POSITION: usize = 5;

fn main() {
    let mut prisoners: Vec<usize> = Vec::new();
    let mut executed: Vec<usize> = Vec::new();
    for pos in 0..N {
        prisoners.push(pos);
    }

    let mut to_kill: usize = 0;
    let mut len: usize = prisoners.len();

    while len > M {
        to_kill = (to_kill + K - 1) % len;
        executed.push(prisoners.remove(to_kill));
        len -= 1;
    }

    println!("JOSEPHUS n={}, k={}, m={}", N, K, M);
    println!("Executed: {:?}", executed);
    println!("Executed position number {}: {}", POSITION, executed[POSITION - 1]);
    println!("Survivors: {:?}", prisoners);
}
