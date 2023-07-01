import rand.seed
import rand
import os
const (
    lower = 1
    upper = 100
)

fn main() {
    rand.seed(seed.time_seed_array(2))
    n := rand.intn(upper-lower+1) or {0} + lower
    for {
        guess := os.input("Guess integer number from $lower to $upper: ").int()

        if guess < n {
            println("Too low. Try again: ")
        } else if guess > n {
            println("Too high. Try again: ")
        } else {
            println("Well guessed!")
            return
        }
    }
}
