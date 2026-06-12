matchfirstlast3(word, _) = length(word) > 5 && word[1:3] == word[end-2:end] ? word : ""
foreachword("unixdict.txt", matchfirstlast3, numcols=4)
