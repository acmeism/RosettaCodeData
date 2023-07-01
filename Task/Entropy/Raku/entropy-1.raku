sub entropy(@a) {
    [+] map -> \p { p * -log p }, bag(@a).values »/» +@a;
}

say log(2) R/ entropy '1223334444'.comb;
