# syntax: GAWK -f SNAKE_AND_LADDER.AWK [players]
# example: GAWK -f SNAKE_AND_LADDER.AWK 3
BEGIN {
    players = (ARGV[1] ~ /^[0-9]+$/) ? ARGV[1] : 2
    load_board()
    show_board()
    if (players == 0) { exit(0) }
    for (i=1; i<=players; i++) {
      sq_arr[i] = 1 # all players start on square 1
    }
    srand() # seed rand() with time of day
    while (1) {
      printf("\nTurn #%d\n",++turns)
      for (i=1; i<=players; i++) {
        ns = turn(i,sq_arr[i])
        if (ns == 100) {
          printf("Player %d wins after %d moves\n",i,moves)
          exit(0)
        }
        sq_arr[i] = ns
      }
    }
}
function load_board() {
# index < value is a ladder
# index > value is a snake
    sl_arr[ 4] = 14
    sl_arr[ 9] = 31
    sl_arr[17] =  7
    sl_arr[20] = 38
    sl_arr[28] = 84
    sl_arr[40] = 59
    sl_arr[51] = 67
    sl_arr[54] = 34
    sl_arr[62] = 19
    sl_arr[63] = 81
    sl_arr[64] = 60
    sl_arr[71] = 91
    sl_arr[87] = 24
    sl_arr[93] = 73
    sl_arr[95] = 75
    sl_arr[99] = 78
}
function show_board(  board_arr,i,pos,row,L,S) {
    PROCINFO["sorted_in"] = "@ind_num_asc"
# populate board with cell numbers
    for (i=1; i<=100; i++) {
      board_arr[i] = i
    }
# add in Snakes & Ladders
    for (i in sl_arr) {
      board_arr[sl_arr[i]] = board_arr[i] = (i+0 < sl_arr[i]) ? sprintf("L%02d",++L) : sprintf("S%02d",++S)
    }
# print board
    print("board: L=ladder S=snake")
    for (row=10; row>=1; row--) {
      if (row ~ /[02468]$/) {
        pos = row * 10
        for (i=1; i<=10; i++) {
          printf("%5s",board_arr[pos--])
        }
      }
      else {
        pos = row * 10 - 9
        for (i=1; i<=10; i++) {
          printf("%5s",board_arr[pos++])
        }
      }
      printf("\n")
    }
}
function turn(player,square,  position,roll) {
    while (1) {
      moves++
      roll = int(rand() * 6) + 1 # roll die
      printf("Player %d on square %d rolls a %d",player,square,roll)
      if (square + roll > 100) {
        printf(" but cannot move\n")
      }
      else {
        square += roll
        printf(" and moves to square %d\n",square)
        if (square == 100) {
          return(100)
        }
        position = (square in sl_arr) ? sl_arr[square] : square
        if (square < position) {
          printf("Yay! Landed on a ladder so climb up to %d\n",position)
        }
        else if (position < square) {
          printf("Oops! Landed on a snake so slither down to %d\n",position)
        }
        square = position
      }
      if (roll < 6) {
        return(square)
      }
      printf("Rolled a 6 so roll again\n")
    }
}
