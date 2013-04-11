assert 'a' instanceof String
assert ('a' as char) instanceof Character
assert ((char)'a') instanceof Character

char x = 'a'
assert x instanceof Character
Character y = 'b'
assert y instanceof Character && (x+1 == y)
