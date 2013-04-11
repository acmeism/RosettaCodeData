function reverse(s   ,l)
{
  l = length(s)
  return l < 2 ? s:( substr(s,l,1) reverse(substr(s,1,l-1)) )
}

BEGIN {
  print reverse("edoCattesoR")
}
