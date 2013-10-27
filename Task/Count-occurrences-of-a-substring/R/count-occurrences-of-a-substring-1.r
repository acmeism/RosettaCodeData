count = function(haystack, needle)
   {v = attr(gregexpr(needle, haystack, fixed = T)[[1]], "match.length")
    if (identical(v, -1L)) 0 else length(v)}

print(count("hello", "l"))
