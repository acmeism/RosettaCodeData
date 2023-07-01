object GuessNumber extends App {
  val n = 1 + scala.util.Random.nextInt(20)

  println("Guess which number I've chosen in the range 1 to 20\n")
  do println("Your guess, please: ")
  while (io.StdIn.readInt() match {
    case `n` => println("Correct, well guessed!"); false
    case guess if (n + 1 to 20).contains(guess) => println("Your guess is higher than the chosen number, try again"); true
    case guess if (1 until n).contains(guess) => println("Your guess is lower than the chosen number, try again"); true
    case _ => println("Your guess is inappropriate, try again"); true
  })

}
