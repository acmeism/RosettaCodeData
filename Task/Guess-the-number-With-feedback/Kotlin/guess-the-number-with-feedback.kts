import kotlin.random.Random

fun main() {
    val n = 1 + rand.nextInt(20)
    println("Guess which number I've chosen in the range 1 to 20\n")
    while (true) {
        print(" Your guess : ")
        val guess = readLine()?.toInt()
        when (guess) {
            n              ->  { println("Correct, well guessed!") ; return }
            in n + 1 .. 20 ->    println("Your guess is higher than the chosen number, try again")
            in 1 .. n - 1  ->    println("Your guess is lower than the chosen number, try again")
            else           ->    println("Your guess is inappropriate, try again")
        }
    }
}
