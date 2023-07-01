var tokens = 12

def playerTurn(curTokens: Int): Unit =
{
  val take = readLine("How many tokens would you like to take? ").toInt
  if (take < 1 || take > 3) {
    println("Number must be between 1 and 3.")
    playerTurn(curTokens)
  }
  else {
    tokens = curTokens - take
    println(s"You take $take tokens. $tokens tokens remaining.\n")
  }
}

def compTurn(curTokens: Int): Unit =
{
  val take = curTokens % 4
  tokens = curTokens - take
  println(s"Computer takes $take tokens. $tokens remaining.\n")
}

def main(args: Array[String]): Unit =
{
  while (tokens > 0)
  {
    playerTurn(tokens)
    compTurn(tokens)
  }
  println("Computer wins!")
}
