g =: #~ (0 = [: */ 3 5&(|/))
assert  0  3  5  6  9 10 12 15 18 20 21 24 25 27 30 33 35 36 39 40 42 45 48 -: g i. 50
assert 48 48 47 46 48 46 47 48 48 47 46 48 46 47 48 48 47 46 48 46 47 48 48 -: (+ |.)g i. 50  NB. the pattern

assert (f -: -:@:(+/)@:(+|.)@:g@:i.) 50  NB. half sum of the pattern.

NB. continue...
