import "io" for Stdin, Stdout
import "/str" for Char

var hle
var lowest = 1
var highest = 20
var guess = 10
System.print("Please choose a number between 1 and 20 but don't tell me what it is yet\n")

while (true) {
    System.print("My guess is %(guess)")
    while (true) {
        System.write("Is this higher/lower than or equal to your chosen number h/l/e : ")
        Stdout.flush()
        hle = Char.lower(Stdin.readLine())
        if (hle == "l" && guess == highest) {
            System.print("It can't be more than %(highest), try again")
            hle = "i" // signifies invalid
        } else if (hle == "h" && guess == lowest) {
            System.print("It can't be less than %(lowest), try again")
            hle  = "i"
        }
        if ("hle".contains(hle)) break
    }
    if (hle == "e") {
        System.print("Good, thanks for playing the game with me!")
        break
    }
    if (hle == "h") {
        if (highest > guess - 1) highest = guess - 1
    } else {
        if (lowest < guess + 1) lowest = guess + 1
    }
    guess = ((lowest + highest)/2).floor
}
