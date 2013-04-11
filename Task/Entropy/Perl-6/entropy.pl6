sub entropy(@a) {
    [+] map -> \p { p * -log p }, @a.bag.values »/» +@a;
}

say log(2) R/ entropy '1223334444'.comb;
