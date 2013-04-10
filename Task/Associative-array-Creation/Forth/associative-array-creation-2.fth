include ffl/hct.fs

\ Create a hash table 'table' in the dictionary with a starting size of 10

10 hct-create htable

\ Insert entries

 5 s" foo" htable hct-insert
10 s" bar" htable hct-insert
15 s" baz" htable hct-insert

\ Get entry from the table

s" bar" htable hct-get [IF]
  .( Value:) . cr
[ELSE]
  .( Entry not present.) cr
[THEN]
