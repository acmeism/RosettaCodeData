import math

fn min_of(x int, y int) int {
    if x < y {
        return x
    }
    return y
}

fn throw_die(n_sides int, n_dice int, s int, mut counts []int) {
    if n_dice == 0 {
        counts[s]++
        return
    }
    for i := int(1); i <= n_sides; i++ {
        throw_die(n_sides, n_dice - 1, s + i, mut counts)
    }
}

fn beating_probability(n_sides1 int, n_dice1 int, n_sides2 int, n_dice2 int) f64 {
    len1 := (n_sides1 + 1) * n_dice1
    mut c1 := []int{len: len1}  // all elements zero by default
    throw_die(n_sides1, n_dice1, 0, mut c1)

    len2 := (n_sides2 + 1) * n_dice2
    mut c2 := []int{len: len2}
    throw_die(n_sides2, n_dice2, 0, mut c2)
    p12 := math.pow(f64(n_sides1), f64(n_dice1)) *
           math.pow(f64(n_sides2), f64(n_dice2))

    mut tot := 0.0
    for i := int(0); i < len1; i++ {
        for j := int(0); j < min_of(i, len2); j++ {
            tot += f64(c1[i] * c2[j]) / p12
        }
    }
    return tot
}

fn main() {
    println(beating_probability(4, 9, 6, 6))
    println(beating_probability(10, 5, 7, 6))
}
