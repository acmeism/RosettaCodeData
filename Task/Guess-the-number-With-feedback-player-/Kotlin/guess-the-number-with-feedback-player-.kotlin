// version 1.0.5-2

fun main(args: Array<String>) {
    var hle: Char
    var lowest  = 1
    var highest = 20
    var guess   = 10
    println("Please choose a number between 1 and 20 but don't tell me what it is yet\n")

    while (true) {
        println("My guess is $guess")

        do {
            print("Is this higher/lower than or equal to your chosen number h/l/e : ")
            hle = readLine()!!.first().toLowerCase()
            if (hle == 'l' && guess == highest) {
                println("It can't be more than $highest, try again")
                hle = 'i' // signifies invalid
            }
            else if (hle == 'h' && guess == lowest) {
                println("It can't be less than $lowest, try again")
                hle = 'i'
            }
        }
        while (hle !in "hle")

        when (hle) {
            'e' -> { println("Good, thanks for playing the game with me!") ; return }
            'h' ->   if (highest > guess - 1) highest = guess - 1
            'l' ->   if (lowest  < guess + 1) lowest  = guess + 1
        }

        guess = (lowest + highest) / 2
    }
}
