function reverse(s)
{
  p = ""
  for(i=length(s); i > 0; i--) { p = p substr(s, i, 1) }
  return p
}

BEGIN {
  print reverse("edoCattesoR")
}
