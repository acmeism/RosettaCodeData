const primelettervalues = [67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]
isprimeword(w, _) = all(c -> Int(c) in primelettervalues, collect(w)) ? w : ""
foreachword("unixdict.txt", isprimeword, colwidth=10, numcols=9)
