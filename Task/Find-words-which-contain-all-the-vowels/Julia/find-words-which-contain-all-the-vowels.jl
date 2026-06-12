hassallthevowels(w, d) = all(c -> count(x -> x == c, w) == 1, collect("aeiou")) ? w : ""
foreachword("unixdict.txt", hassallthevowels, colwidth=18, minlen=11, numcols=5)
