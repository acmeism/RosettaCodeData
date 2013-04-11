function lookandsay(a)
{
  s = ""
  c = 1
  p = substr(a, 1, 1)
  for(i=2; i <= length(a); i++) {
    if ( p == substr(a, i, 1) ) {
      c++
    } else {
      s = s sprintf("%d%s", c, p)
      p = substr(a, i, 1)
      c = 1
    }
  }
  s = s sprintf("%d%s", c, p)
  return s
}

BEGIN {
  b = "1"
  print b
  for(k=1; k <= 10; k++) {
    b = lookandsay(b)
    print b
  }
}
