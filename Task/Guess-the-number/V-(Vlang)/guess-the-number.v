import rand
import rand.seed
import os

fn main() {
    seed_array := seed.time_seed_array(2)
    rand.seed(seed_array)
    num := rand.intn(10) + 1  // Random number 1-10
    for {
        print('Please guess a number from 1-10 and press <Enter>: ')
        guess := os.get_line()
        if guess.int() == num {
            println("Well guessed! '$guess' is correct.")
            return
        } else {
            println("'$guess' is Incorrect. Try again.")
        }
    }
}
