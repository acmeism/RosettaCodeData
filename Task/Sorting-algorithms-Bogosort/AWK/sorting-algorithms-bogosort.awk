function randint(n)
{
  return int(n * rand())
}

function sorted(sa, sn)
{
  for(si=1; si < sn; si++) {
    if ( sa[si] > sa[si+1] ) return 0;
  }
  return 1
}

{
  line[NR] = $0
}
END { # sort it with bogo sort
  while ( sorted(line, NR) == 0 ) {
    for(i=1; i <= NR; i++) {
      r = randint(NR) + 1
      t = line[i]
      line[i] = line[r]
      line[r] = t
    }
  }
  #print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
