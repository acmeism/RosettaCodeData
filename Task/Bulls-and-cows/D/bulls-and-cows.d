import std.stdio, std.random, std.string, std.algorithm,
       std.range, std.conv;

void main() {
  enum size = 4;
  immutable ddigits = "123456789"d;
  //immutable chosen = ddigits.randomCover.take(size).array;
  const chosen = ddigits.randomCover(rndGen).take(size).array;
  writeln("Guess a number composed of ", size,
          " unique digits from 1 to 9 in random order.");

  uint nGuesses;
  while (true) {
    nGuesses++;
    dstring guess;
    while (true) {
      writef("\nNext guess (%d): ", nGuesses);
      guess = readln.strip.dtext;
      if (guess.countchars(ddigits) == size &&
          guess.dup.sort().uniq.walkLength == size)
        break;
      writefln("I need %d unique digits from 1 to 9, no spaces", size);
    }

    if (guess == chosen) {
      writefln("\nYou guessed correctly in %d attempts.", nGuesses);
      break;
    }

    immutable bulls = zip(guess, chosen).count!q{ a[0] == a[1] };
    immutable cows = iota(size)
                     .count!(i => guess[i] != chosen[i] &&
                                  chosen.canFind(guess[i]));
    writefln("  %d Bulls\n  %d Cows", bulls, cows);
  }
}
