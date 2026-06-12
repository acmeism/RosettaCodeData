fn round_robin(n: usize) {
    assert!(n >= 2);
    let mut n = n;
    let mut list1: Vec<usize> = (2..=n).collect();

    if n % 2 == 1 {
        list1.push(0); // 0 denotes a "bye".
        n += 1;
    }

    for r in 1..n {
        print!("Round {:2}:", r);
        let list2 = vec![1].into_iter().chain(list1.iter().cloned()).collect::<Vec<_>>();

        for i in 0..(n / 2) {
            print!(" ({:>2} vs {:<2})", list2[i], list2[n - i - 1]);
        }

        println!();
        list1.rotate_right(1);
    }
}

fn main() {
    println!("Round robin for 12 players:\n");
    round_robin(12);

    println!("\n\nRound robin for 5 players (0 denotes a bye):\n");
    round_robin(5);
}
