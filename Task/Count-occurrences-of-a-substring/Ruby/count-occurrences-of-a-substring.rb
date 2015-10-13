def countSubstrings str, subStr
  str.scan(subStr).length
end

p countSubstrings "the three truths", "th"      #=> 3
p countSubstrings "ababababab", "abab"          #=> 2
