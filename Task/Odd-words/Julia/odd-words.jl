isoddword(w, d) = (o = mapreduce(i -> w[i], *, 1:2:length(w)); haskey(d, o) ? rpad(w, 16) * ":  " * o : "")
foreachword("unixdict.txt", isoddword, minlen=9, numcols=1)
