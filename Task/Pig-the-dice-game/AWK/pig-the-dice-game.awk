# syntax: GAWK -f PIG_THE_DICE_GAME.AWK
# converted from LUA
BEGIN {
    players = 2
    p = 1 # start with first player
    srand()
    printf("Enter: Hold or Roll?\n\n")
    while (1) {
      printf("Player %d, your score is %d, with %d temporary points\n",p,scores[p],points)
      getline reply
      reply = toupper(substr(reply,1,1))
      if (reply == "R") {
        roll = int(rand() * 6) + 1 # roll die
        printf("You rolled a %d\n",roll)
        if (roll == 1) {
          printf("Too bad. You lost %d temporary points\n\n",points)
          points = 0
          p = (p % players) + 1
        }
        else {
          points += roll
        }
      }
      else if (reply == "H") {
        scores[p] += points
        points = 0
        if (scores[p] >= 100) {
          printf("Player %d wins with a score of %d\n",p,scores[p])
          break
        }
        printf("Player %d, your new score is %d\n\n",p,scores[p])
        p = (p % players) + 1
      }
      else if (reply == "Q") { # abandon game
        break
      }
    }
    exit(0)
}
