function bullsandcows ()
    bulls = cows = turns = 0
    result = (s = [] ; while length(unique(s))<4 push!(s,rand('1':'9')) end; unique(s))
    println("A game of bulls and cows!")
    while (bulls != 4)
      print("Your guess? ")
      guess = collect(chomp(readline(STDIN)))
      if ! (length(unique(guess)) == length(guess) == 4 && all(isdigit,guess))
         println("please, enter four distincts digits")
         continue
      end
      bulls = sum(map(==, guess, result))
      cows = length(intersect(guess,result)) - bulls
      println("$bulls bulls and $cows cows!") ; turns += 1
    end
    println("You win! You succeeded in $turns guesses.")
  end
