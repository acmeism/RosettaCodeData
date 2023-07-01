.sub fib
  .param int n
  .local int nt
  .local int ft
  if n < 2 goto RETURNN
  nt = n - 1
  ft = fib( nt )
  dec nt
  nt = fib(nt)
  ft = ft + nt
  .return( ft )
RETURNN:
  .return( n )
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
