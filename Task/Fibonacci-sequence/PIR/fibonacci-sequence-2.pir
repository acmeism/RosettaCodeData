.sub fib
  .param int n
  .local int counter
  .local int f
  .local pmc fibs
  .local int nmo
  .local int nmt

  fibs = new 'ResizableIntegerArray'
  if n == 0 goto RETURN0
  if n == 1 goto RETURN1
  push fibs, 0
  push fibs, 1
  counter = 2
FIBLOOP:
  if counter > n goto DONE
  nmo = pop fibs
  nmt = pop fibs
  f = nmo + nmt
  push fibs, nmt
  push fibs, nmo
  push fibs, f
  inc counter
  goto FIBLOOP
RETURN0:
  .return( 0 )
  end
RETURN1:
  .return( 1 )
  end
DONE:
  f = pop fibs
  .return( f )
  end
.end

.sub main :main
  .local int counter
  .local int f
  counter=0
LOOP:
  if counter > 20 goto DONE
  f = fib(counter)
  print f
  print "\n"
  inc counter
  goto LOOP
DONE:
  end
.end
