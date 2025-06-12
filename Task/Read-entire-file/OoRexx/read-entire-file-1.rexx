o=.stream~new('f:\readall.rex')
a=o~arrayin
Do x over a
  say x
  End
Do i=1 To a~items
  Say i a[i]
  End
