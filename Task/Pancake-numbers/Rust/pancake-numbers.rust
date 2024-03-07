fn pancake(n: i32) -> i32 {
    let mut gap = 2;
    let mut sum = 2;
    let mut adj = -1;

    while sum < n {
        adj += 1;
        gap = gap * 2 - 1;
        sum += gap;
    }

    n + adj
}

fn main() {
    for i in 0..4 {
        for j in 1..6 {
            let n = i * 5 + j;
            print!("p({:2}) = {:2}  ", n, pancake(n));
        }
        println!();
    }
}
