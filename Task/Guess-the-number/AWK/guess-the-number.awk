# syntax: GAWK -f GUESS_THE_NUMBER.AWK
BEGIN {
    srand()
    n = int(rand() * 10) + 1
    print("I am thinking of a number between 1 and 10. Try to guess it.")
    while (1) {
      getline ans
      if (ans !~ /^[0-9]+$/) {
        print("Your input was not a number. Try again.")
        continue
      }
      if (n == ans) {
        print("Well done you.")
        break
      }
      print("Incorrect. Try again.")
    }
    exit(0)
}
