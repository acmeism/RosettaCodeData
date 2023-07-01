import java.util.Random
import java.util.Scanner

val scan = new Scanner(System.in)
val random = new Random
val (from , to) = (1, 100)
val randomNumber = random.nextInt(to - from + 1) + from
var guessedNumber = 0
printf("The number is between %d and %d.\n", from, to)

do {
  print("Guess what the number is: ")
  guessedNumber = scan.nextInt
  if (guessedNumber > randomNumber) println("Your guess is too high!")
  else if (guessedNumber < randomNumber) println("Your guess is too low!")
  else println("You got it!")
} while (guessedNumber != randomNumber)
