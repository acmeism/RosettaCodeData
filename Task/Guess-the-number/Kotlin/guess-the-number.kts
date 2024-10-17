// version 1.0.5-2

fun main(args: Array<String>) {
	val n = (1 + java.util.Random().nextInt(10)).toString()
	println("Guess which number I've chosen in the range 1 to 10\n")
	do { print(" Your guess : ") } while (n != readLine())
	println("\nWell guessed!")
}
