s1 = "This is a double-quoted 'string' with embedded single-quotes."
s2 = 'This is a single-quoted "string" with embedded double-quotes.'
s3 = "this is a double-quoted \"string\" with escaped double-quotes."
s4 = 'this is a single-quoted \'string\' with escaped single-quotes.'
s5 = [[This is a long-bracket "'string'" with embedded single- and double-quotes.]]
s6 = [=[This is a level 1 long-bracket ]]string[[ with [[embedded]] long-brackets.]=]
s7 = [==[This is a level 2 long-bracket ]=]string[=[ with [=[embedded]=] level 1 long-brackets, etc.]==]
s8 = [[This is
a long-bracket string
with embedded
line feeds]]
s9 = "any \0 form \1 of \2 string \3 may \4 contain \5 raw \6 binary \7 data \xDB"
print(s1)
print(s2)
print(s3)
print(s4)
print(s5)
print(s6)
print(s7)
print(s8)
print(s9) -- with audible "bell" from \7 if supported by os
print("some raw binary:", #s9, s9:byte(5), s9:byte(12), s9:byte(17))
