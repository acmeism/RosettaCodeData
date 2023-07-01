# syntax: GAWK -f GUESS_THE_NUMBER_WITH_FEEDBACK.AWK
BEGIN {
    L = 1
    H = 100
    srand()
    n = int(rand() * (H-L+1)) + 1
    printf("I am thinking of a number between %d and %d. Try to guess it.\n",L,H)
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
      if (n > ans) {
        print("Incorrect, your answer was too low. Try again.")
        continue
      }
      if (n < ans) {
        print("Incorrect, your answer was too high. Try again.")
        continue
      }
    }
    exit(0)
}
