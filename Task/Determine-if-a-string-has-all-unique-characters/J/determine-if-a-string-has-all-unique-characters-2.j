NB. unique_index answers "Do the left and right indexes match?"
unique_index=: (i. -: i:)~
assert 0 1 -: 2 unique_index\0 0 1

NB. unique_set answers "Are lengths of the nub and original equal?"
unique_set=: -:&# ~.
assert 0 1 -: _2 unique_set\'aab'

NB. unique_nubsieve answers "Are the items unique?"
unique_nubsieve=: 0 -.@:e. ~:
assert 0 1 -: _2 unique_nubsieve\'aab'

Note'compared to nubsieve'
  the index method takes 131% longer and 15 times additional memory
  the set formation method 15% longer and uses 7 times additional memory.
)
