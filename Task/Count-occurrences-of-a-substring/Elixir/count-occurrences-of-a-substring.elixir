countSubstring = fn(_, "") -> 0
                   (str, sub) -> length(String.split(str, sub)) - 1 end

data = [ {"the three truths", "th"},
         {"ababababab", "abab"},
         {"abaabba*bbaba*bbab", "a*b"},
         {"abaabba*bbaba*bbab", "a"},
         {"abaabba*bbaba*bbab", " "},
         {"abaabba*bbaba*bbab", ""},
         {"", "a"},
         {"", ""} ]

Enum.each(data, fn{str, sub} ->
  IO.puts countSubstring.(str, sub)
end)
