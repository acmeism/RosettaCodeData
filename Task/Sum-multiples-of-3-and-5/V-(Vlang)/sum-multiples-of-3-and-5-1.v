fn s35(n int) int {
    mut nn := n-1
    mut threes := nn/3
    mut fives := nn/5
    mut fifteen := nn/15

    threes = 3 * threes * (threes + 1)
    fives = 5 * fives * (fives + 1)
    fifteen = 15 * fifteen * (fifteen + 1)

    nn = (threes + fives - fifteen) / 2

    return nn
}

fn main(){
    println(s35(1000))
}
