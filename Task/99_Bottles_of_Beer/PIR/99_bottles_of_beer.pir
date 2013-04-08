.sub sounding_smart_is_hard_after_drinking_this_many
  .param int b
  if b == 1 goto ONE
  .return(" bottles ")
ONE:
  .return(" bottle ")
  end
.end

.sub main :main
  .local int bottles
  .local string b
  bottles = 99
LUSH:
  if bottles == 0 goto DRUNK
  b = sounding_smart_is_hard_after_drinking_this_many( bottles )
  print bottles
  print b
  print "of beer on the wall\n"
  print bottles
  print b
  print "of beer\nTake one down, pass it around\n"
  dec bottles
  b = sounding_smart_is_hard_after_drinking_this_many( bottles )
  print bottles
  print b
  print "of beer on the wall\n\n"
  goto LUSH
DRUNK:
  end
.end
