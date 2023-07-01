require "set"

UNIXDICT = File.read("unixdict.txt").lines

def word?(word : String)
  UNIXDICT.includes?(word)
end

# is it a word and is it a word backwards?
semordnilap = UNIXDICT.select { |word| word?(word) && word?(word.reverse) }

# consolidate pairs like [bad, dab] == [dab, bad]
final_results = semordnilap.map { |word| [word, word.reverse].to_set }.uniq

# sets of N=1 mean the word is identical backwards
# print out the size, and 5 random pairs
puts final_results.size, final_results.sample(5)
