import "/fmt" for Conv
import "/ioutil" for Input
import "random" for Random

var total = 0
var quit = false

var getChoice = Fn.new {
    while (true) {
        var input = Input.integer("Your choice 1 to 3: ", 0, 3)
        if (input == 0) {
            quit = true
            return
        }
        var newTotal = total + input
        if (newTotal > 21) {
            System.print("Too big, try again")
        } else {
            total = newTotal
            System.print("Running total is now %(total)")
            return
        }
    }
}

var rand = Random.new()
var computer = Conv.itob(rand.int(2))
System.print("Enter 0 to quit at any time\n")
if (computer) {
    System.print("The computer will choose first")
} else {
    System.print("You will choose first")
}
System.print("\nRunning total is now 0\n")
var round = 1
while (true) {
    System.print("ROUND %(round):\n")
    for (i in 0..1) {
        if (computer) {
            var choice = (total < 18) ? 1 + rand.int(3) : 21 - total
            total = total + choice
            System.print("The computer chooses %(choice)")
            System.print("Running total is now %(total)")
            if (total == 21) {
                System.print("\nSo, commiserations, the computer has won!")
                return
            }
        } else {
            getChoice.call()
            if (quit) {
                System.print("OK, quitting the game")
                return
            }
            if (total == 21) {
                System.print("\nSo, congratulations, you've won!")
                return
            }
        }
        System.print()
        computer = !computer
    }
    round = round + 1
}
