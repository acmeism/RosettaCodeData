case x
of 0:
  foo()
of 2,5,9:
  baz()
of 10..20, 40..50:
  baz()
else: # All cases must be covered
  boz()
