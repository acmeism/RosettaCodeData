c: charset [#"A" - #"F"]
n: 0 repeat i 500 [
    if find enbase to binary! i 16 c [prin i prin SP ++ n]
]
assert [n == 301]
print  ["^/Integers when displayed in hex require an A-F:" n]
