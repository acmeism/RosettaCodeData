s := "abc"             # create a string (immutable if its a literal constant in the program)
s := #[16r01 16r02 16r00 16r03] asString # strings can contain any value, even nulls
s := String new:3.     # a mutable string
v := s                 # assignment
s = t                  # same contents
s < t                  # less
s <= t                 # less or equal
s = ''                 # equal empty string
s isEmpty              # ditto
s size                 # string length
t := s copy            # a copy
t := s copyFrom:2 to:3 # a substring
t := s copyReplaceFrom:2 to:3 with:'**'  # a copy with some replacements
s replaceFrom:2 to:3 with:'**'           # inplace replace (must be mutable)
s replaceAll:$x with:$y                  # destructive replace of characters
s copyReplaceAll:$x with:$y              # non-destructive replace
s replaceString:s1 withString:s2         # substring replace
s3 := s1 , s2          # concatenation of strings
s2 := s1 , $x          # append a character
s2 := s1 , 123 asCharacter # append an arbitrary byte
s := 'Hello / 今日は'   # they support unicode (at least up to 16rFFFF, some more)
