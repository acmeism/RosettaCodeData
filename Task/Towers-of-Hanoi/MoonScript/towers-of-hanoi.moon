hanoi = (n, src, dest, via) ->
  if n > 1
    hanoi n-1, src, via, dest
  print "#{src} -> #{dest}"
  if n > 1
    hanoi n-1, via, dest, src

hanoi 4,1,3,2
