mp =: $:~ :(+/ .*)  NB. matrix product
f =: (mp 0 = [: */ 3 5 |/ ])@:i.
assert 233168 -: f 1000   NB.  ******************  THIS IS THE ANSWER FOR 1000
