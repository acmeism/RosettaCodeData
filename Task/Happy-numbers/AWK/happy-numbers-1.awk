function is_happy(n)
{
  if ( n in happy ) return 1;
  if ( n in unhappy ) return 0;
  cycle[""] = 0
  while( (n!=1) && !(n in cycle) ) {
    cycle[n] = n
    new_n = 0
    while(n>0) {
      d = n % 10
      new_n += d*d
      n = int(n/10)
    }
    n = new_n
  }
  if ( n == 1 ) {
    for (i_ in cycle) {
      happy[cycle[i_]] = 1
      delete cycle[i_]
    }
    return 1
  } else {
    for (i_ in cycle) {
      unhappy[cycle[i_]] = 1
      delete cycle[i_]
    }
    return 0
  }
}

BEGIN {
  cnt = 0
  happy[""] = 0
  unhappy[""] = 0
  for(j=1; (cnt < 8); j++) {
    if ( is_happy(j) == 1 ) {
      cnt++
      print j
    }
  }
}
