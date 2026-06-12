import  std/editdistance, sugar

# Build list of words with length >= 12.
let words = collect(newSeq):
              for word in "unixdict.txt".lines:
                if word.len >= 12:
                  word

echo "List of changeable words:\n"
var count = 0
for i in 0..<words.high:
  let word1 = words[i]
  for j in i+1..words.high:
    let word2 = words[j]
    if word1.len == word2.len and editDistance(word1, word2) == 1:
      echo word1, " <-> ", word2
      inc count, 2

echo "\nFound ", count, " changeable words."
