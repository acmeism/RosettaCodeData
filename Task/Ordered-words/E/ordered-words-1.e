pragma.enable("accumulator")

def words := <http://www.puzzlers.org/pub/wordlists/unixdict.txt>.getText().split("\n")
def ordered := accum [] for word ? (word.sort() <=> word) in words { _.with(word) }
def maxLen := accum 0 for word in ordered { _.max(word.size()) }
def maxOrderedWords := accum [] for word ? (word.size() <=> maxLen) in ordered { _.with(word) }
println(" ".rjoin(maxOrderedWords))
