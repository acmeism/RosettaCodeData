"Test"
|c|
c := OrderedCollection new.
c addAll: #( 1 2 3 4 5 6 7 8 9 ).
Shuffler Knuth: c.
c display.
