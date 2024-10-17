strs = ~w[this is a set of strings to sort This Is A Set Of Strings To Sort]

comparator = fn s1,s2 -> if String.length(s1)==String.length(s2),
                           do:   String.downcase(s1) <= String.downcase(s2),
                           else: String.length(s1) >= String.length(s2) end
IO.inspect Enum.sort(strs, comparator)

# or
IO.inspect Enum.sort_by(strs, fn str -> {-String.length(str), String.downcase(str)} end)
