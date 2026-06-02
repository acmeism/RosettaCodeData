import "std/math.zc"

fn min(i: int, j: int) -> int {
    return i < j ? i : j;
}

fn throw_die(n_sides: int, n_dice: int, s: int, counts: int*) {
    if n_dice == 0 {
        counts[s]++;
        return;
    }
    for i in 1..=n_sides { throw_die(n_sides, n_dice - 1, s + i, counts) }
}

fn beating_probability(n_sides1: int, n_dice1: int, n_sides2: int, n_dice2: int) -> f64 {
    let len1 = (n_sides1 + 1) * n_dice1;
    autofree let c1: int* = calloc(len1, sizeof(int));
    throw_die(n_sides1, n_dice1, 0, c1);

    let len2 = (n_sides2 + 1) * n_dice2;
    autofree let c2: int* = calloc(len2, sizeof(int));
    throw_die(n_sides2, n_dice2, 0, c2);

    let p12 = Math::pow(n_sides1, n_dice1) * Math::pow(n_sides2, n_dice2);
    let tot = 0.0;
    for i in 0..len1 {
        for j in 0..min(i, len2) {
            tot += c1[i] * c2[j] / p12;
        }
    }
    return tot;
}

fn main() {
    println "{beating_probability( 4, 9, 6, 6):0.16f}";
    println "{beating_probability(10, 5, 7, 6):0.16f}";
}
