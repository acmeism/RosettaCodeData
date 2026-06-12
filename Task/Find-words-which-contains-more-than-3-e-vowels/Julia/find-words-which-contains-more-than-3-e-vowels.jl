ecount(word) = count(x -> x == 'e', word)
vowelcount(word) = count(x -> x in ['a', 'e', 'i', 'o', 'u'], word)
onlyevowelsmorethan3(word, _) = begin n, m = vowelcount(word), ecount(word); n == m && m > 3 ? word : "" end

foreachword("unixdict.txt", onlyevowelsmorethan3, colwidth=15, numcols=8)
