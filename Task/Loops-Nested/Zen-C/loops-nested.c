import "std/random.zc"

fn main() {
    let rng = Random::new();
    let a: int[20][20];
    for i in 0..=19 {
        for j in 0..=19 {
            a[i][j] = rng.next_int_range(1, 20);
        }
    }

    outer: for i in 0..=19 {
        for j in 0..=19 {
            print "{a[i][j]:2d} ";
            if a[i][j] == 20 {
                println "";
                break outer;
            }
            if (j + 1) % 10 == 0 { println ""; }
        }
    }
}
