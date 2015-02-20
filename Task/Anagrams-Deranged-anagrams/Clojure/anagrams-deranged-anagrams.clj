(->> (slurp "unixdict.txt") ; words
     (re-seq #"\w+")        ; |
     (group-by sort)        ; anagrams
     vals                   ; |
     (filter second)        ; |
     (remove #(some true? (apply map = %))) ; deranged
     (sort-by #(count (first %)))
     last
     prn)
