containsthe(w, d) = occursin("the", w) ? w : ""
foreachword("unixdict.txt", containsthe, minlen = 12)
