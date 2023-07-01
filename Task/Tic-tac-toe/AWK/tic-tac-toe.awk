# syntax: GAWK -f TIC-TAC-TOE.AWK
BEGIN {
    move[12] = "3 7 4 6 8"; move[13] = "2 8 6 4 7"; move[14] = "7 3 2 8 6"
    move[16] = "8 2 3 7 4"; move[17] = "4 6 8 2 3"; move[18] = "6 4 7 3 2"
    move[19] = "8 2 3 7 4"; move[23] = "1 9 6 4 8"; move[24] = "1 9 3 7 8"
    move[25] = "8 3 7 4 0"; move[26] = "3 7 1 9 8"; move[27] = "6 4 1 9 8"
    move[28] = "1 9 7 3 4"; move[29] = "4 6 3 7 8"; move[35] = "7 4 6 8 2"
    move[45] = "6 7 3 2 0"; move[56] = "4 7 3 2 8"; move[57] = "3 2 8 4 6"
    move[58] = "2 3 7 4 6"; move[59] = "3 2 8 4 6"
    split("7 4 1 8 5 2 9 6 3",rotate)
    n = split("253 280 457 254 257 350 452 453 570 590",special)
    i = 0
    while (i < 9) { s[++i] = " " }
    print("")
    print("You move first, use the keypad:")
    board = "\n7 * 8 * 9\n*********\n4 * 5 * 6\n*********\n1 * 2 * 3\n\n? "
    printf(board)
}
state < 7 {
    x = $0
    if (s[x] != " ") {
      printf("? ")
      next
    }
    s[x] = "X"
    ++state
    print("")
    if (state > 1) {
      for (i=0; i<r; ++i) { x = rotate[x] }
    }
}
state == 1 {
    for (r=0; x>2 && x!=5; ++r) { x = rotate[x] }
    k = x
    if (x == 5) { d = 1 } else { d = 5 }
}
state == 2 {
    c = 5.5 * (k + x) - 4.5 * abs(k - x)
    split(move[c],t)
    d = t[1]
    e = t[2]
    f = t[3]
    g = t[4]
    h = t[5]
}
state == 3 {
    k = x / 2.
    c = c * 10
    d = f
    if (abs(c-350) == 100) {
      if (x != 9) { d = 10 - x }
      if (int(k) == k) { g = f }
      h = 10 - g
      if (x+0 == e+0) {
        h = g
        g = 9
      }
    }
    else if (x+0 != e+0) {
      d = e
      state = 6
    }
}
state == 4 {
    if (x+0 == g+0) {
      d = h
    }
    else {
      d = g
      state = 6
    }
    x = 6
    for (i=1; i<=n; ++i) {
      b = special[i]
      if (b == 254) { x = 4 }
      if (k+0 == abs(b-c-k)) { state = x }
    }
}
state < 7 {
    if (state != 5) {
      for (i=0; i<4-r; ++i) { d = rotate[d] }
      s[d] = "O"
    }
    for (b=7; b>0; b-=5) {
      printf("%s * %s * %s\n",s[b++],s[b++],s[b])
      if (b > 3) { print("*********") }
    }
    print("")
}
state < 5 {
    printf("? ")
}
state == 5 {
    printf("tie game")
    state = 7
}
state == 6 {
    printf("you lost")
    state = 7
}
state == 7 {
    printf(", play again? ")
    ++state
    next
}
state == 8 {
    if ($1 !~ /^[yY]$/) { exit(0) }
    i = 0
    while (i < 9) { s[++i] = " " }
    printf(board)
    state = 0
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
