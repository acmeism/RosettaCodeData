.sub main :main
  .local int f
  .local int mf
  .local int skipnum
  f = 1
LOOP:
  if f > 100 goto DONE
  skipnum = 0
  mf = f % 3
  if mf == 0 goto FIZZ
FIZZRET:
  mf = f % 5
  if mf == 0 goto BUZZ
BUZZRET:
  if skipnum > 0 goto SKIPNUM
  print f
SKIPNUM:
  print "\n"
  inc f
  goto LOOP
  end
FIZZ:
  print "Fizz"
  inc skipnum
  goto FIZZRET
  end
BUZZ:
  print "Buzz"
  inc skipnum
  goto BUZZRET
  end
DONE:
  end
.end
