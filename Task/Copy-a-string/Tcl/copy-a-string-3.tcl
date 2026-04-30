# replace substrings in a string

set rep [string map {"apple" "orange"} "I like apples."]
puts stdout $rep
