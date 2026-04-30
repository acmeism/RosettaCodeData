data: [] evens: []
repeat i 20 [append data i] ; Build and load array.

foreach element data [if even? element [append evens element]]
probe evens
remove-each element evens [zero? element % 10]
probe evens
