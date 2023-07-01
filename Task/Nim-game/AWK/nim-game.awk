# syntax: GAWK -f NIM_GAME.AWK
BEGIN {
    tokens = 12
    printf("Nim game - using %d tokens\n",tokens)
    while (tokens > 0) {
      for (;;) {
        printf("how many tokens 1-3? ")
        getline ans
        if (ans ~ /^[123]$/) {
          tokens -= ans
          prn("player")
          break
        }
        print("invalid input, try again")
      }
      tokens -= ans = tokens % 4
      prn("computer")
    }
    print("computer wins")
    exit(0)
}
function prn(who) {
    printf("%s takes %d token%s; there are %d remaining\n",who,ans,(ans==1)?"":"s",tokens)
}
