s = .set~new
text = "the quick brown fox jumped over the lazy dog"
do word over text~makearray(' ')
   s~put(word)
end

say "text has" text~words", but only" s~items "unique words"
