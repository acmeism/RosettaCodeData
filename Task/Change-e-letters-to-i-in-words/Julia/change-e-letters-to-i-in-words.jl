e2i(w, d) = (if 'e' in w   s = replace(w, "e" => "i"); haskey(d, s) && return "$w => $s" end; "")
foreachword("unixdict.txt", e2i, minlen=6, colwidth=23, numcols=4)
