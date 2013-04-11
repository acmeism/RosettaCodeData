**
** Bulls and cows. A game pre-dating, and similar to, Mastermind.
**
class BullsAndCows
{

  Void main()
  {
    digits := [1,2,3,4,5,6,7,8,9]
    size := 4
    chosen := [,]
    size.times { chosen.add(digits.removeAt(Int.random(0..<digits.size))) }

    echo("I've chosen $size unique digits from 1 to 9 at random.
          Try to guess my number!")
    guesses := 0
    while (true) // game loop
    {
      guesses += 1
      guess := Int[,]
      while (true) // input loop
      {
        // get a good guess
        Sys.out.print("\nNext guess [$guesses]: ")
        Sys.out.flush
        inString := Sys.in.readLine?.trim ?: ""
        inString.each |ch|
        { if (ch >= '1' && ch <= '9' && !guess.contains(ch)) guess.add(ch-'0') }
        if (guess.size == 4)
          break // input loop
        echo("Oops, try again. You need to enter $size unique digits from 1 to 9")
      }
      if (guess.all |v, i->Bool| { return v == chosen[i] })
      {
        echo("\nCongratulations! You guessed correctly in $guesses guesses")
        break // game loop
      }
      bulls := 0
      cows  := 0
      (0 ..< size).each |i|
      {
        if (guess[i] == chosen[i])
          bulls += 1
        else if (chosen.contains(guess[i]))
          cows += 1
      }
      echo("\n  $bulls Bulls\n  $cows Cows")
    }
  }
}
