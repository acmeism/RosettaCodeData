import std.stdio, std.random, std.string, std.algorithm,
       std.range, std.conv;

void main() {
  enum size = 4;
  dchar[] ddigits = "123456789"d.dup;
  //immutable chosen = array(randomCover(ddigits))[0 .. size];
  const chosen = randomCover(ddigits, rndGen).take(size).array();
  writeln("Guess a number composed of ", size,
          " unique digits from 1 to 9 in random order.");

  int nGuesses;
  while (true) {
    nGuesses++;
    dstring guess;
    while (true) {
      writef("\nNext guess (%d): ", nGuesses);
      guess = readln().strip().dtext();
      if (guess.countchars(ddigits) == size &&
          guess.dup.sort().uniq().walkLength() == size)
        break;
      writefln("I need %d unique digits from 1 to 9, no spaces", size);
    }

    if (guess == chosen) {
      writefln("\nYou guessed correctly in %d attempts.", nGuesses);
      break;
    }

    immutable bulls = count!q{ a[0] == a[1] }(zip(guess, chosen));
    immutable cows = count!(i => guess[i] != chosen[i] &&
                                 chosen.canFind(guess[i]))
                           (iota(size));
    writefln("  %d Bulls\n  %d Cows", bulls, cows);
  }
}
