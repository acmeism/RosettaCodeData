str = "abcde"
# String with first character removed
str[1..]           #=> "bcde"
str.lchop          #=> "bcde"

# String with last character removed
str[..-2]          #=> "abcd"
str.rchop          #=> "abcd"

# String with both the first and last characters removed
str[1..-2]         #=> "bcd"
