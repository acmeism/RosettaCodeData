a: []  repeat i 100 [append a i] ; Build and load array.

evens: []  repeat element a [if even? element [append evens element]]

print mold evens
