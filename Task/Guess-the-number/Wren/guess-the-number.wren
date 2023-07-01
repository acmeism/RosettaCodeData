import "io" for Stdin, Stdout
import "random" for Random

var rand = Random.new()
var n = rand.int(1, 11) // computer number from 1..10 inclusive
while (true) {
    System.write("Your guess 1-10 : ")
    Stdout.flush()
    var guess = Num.fromString(Stdin.readLine())
    if (n == guess) {
        System.print("Well guessed!")
        break
    }
}
