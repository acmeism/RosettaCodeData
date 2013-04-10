import std.stdio, std.random, std.algorithm, std.range, std.ascii;

auto scoreCalc(in dchar[] guess, in dchar[] chosen) {
   immutable bulls = guess.zip(chosen).count!q{ a[0] == a[1] };
   immutable cows = count!(p => p[0] != p[1] && chosen.canFind(p[0]))
                          (zip(guess, chosen));
   return [bulls, cows];
}

void main() {
  auto d9 = "123456789"d.dup;
  auto choices = cartesianProduct(d9, d9, d9, d9)
                 .map!(t => [t[]])
                 .filter!(a => a.sort().uniq.walkLength == 4)
                 .array;
   choices.randomShuffle;

   do {
      const ans = choices[0];
      writef("My guess is %s. How many bulls and cows? ", ans);
      const score = readln.filter!isDigit.map!q{ a-'0' }.array;
      choices = choices.filter!(c => scoreCalc(c, ans) == score).array;
      if (choices.empty)
        return writeln("Nothing fits the scores you gave.");
   } while (choices.length > 1);

   writeln("Solution found: ", choices[0]);
}
