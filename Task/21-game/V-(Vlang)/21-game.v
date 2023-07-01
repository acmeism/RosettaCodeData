import os
import rand
import rand.seed
import strconv

fn get_choice(mut total &int) bool {
    for {
        text := os.input("Your choice 1 to 3 : ")
        if text == "q" || text == "Q" {
            return true
        }
        input := strconv.atoi(text) or {-1}
        if input == -1 {
            println("Invalid number, try again")
            continue
        }
        new_total := *total + input
        match true {
            input < 1 || input > 3 {
                println("Out of range, try again")
            }
            new_total > 21 {
                println("Too big, try again")
            }
            else {
                total = new_total
                println("Running total is now ${*total}")
                return false
            }
        }
    }
    return false
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    mut computer := rand.intn(2) or {0} != 0
    println("Enter q to quit at any time\n")
    if computer {
        println("The computer will choose first")
    } else {
        println("You will choose first")
    }
    println("\nRunning total is now 0\n")
    mut choice := 0
    mut total := 0
    for round := 1; ; round++ {
        println("ROUND $round:\n")
        for i := 0; i < 2; i++ {
            if computer {
                if total < 18 {
                    choice = 1 + rand.intn(3) or {1}
                } else {
                    choice = 21 - total
                }
                total += choice
                println("The computer chooses $choice")
                println("Running total is now $total")
                if total == 21 {
                    println("\nSo, commiserations, the computer has won!")
                    return
                }
            } else {
                quit := get_choice(mut total)
                if quit {
                    println("OK, quitting the game")
                    return
                }
                if total == 21 {
                    println("\nSo, congratulations, you've won!")
                    return
                }
            }
            println('')
            computer = !computer
        }
    }
}
