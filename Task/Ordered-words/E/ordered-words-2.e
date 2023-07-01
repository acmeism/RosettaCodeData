def best := [].diverge()
for `@word$\n` ? (word.sort() <=> word) in <http://www.puzzlers.org/pub/wordlists/unixdict.txt> {
  if (best.size() == 0) {
    best.push(word)
  } else if (word.size() > best[0].size()) {
    best(0) := [word] # replace all
  } else if (word.size() <=> best[0].size()) {
    best.push(word)
  }
}
println(" ".rjoin(best.snapshot()))
