iex(1)> str = "abcdefg"
"abcdefg"
iex(2)> String.slice(str, 1..-1)
"bcdefg"
iex(3)> String.slice(str, 0..-2)
"abcdef"
iex(4)> String.slice(str, 1..-2)
"bcdef"
