function ord(c)
{
  return chmap[c]
}
BEGIN {
  for(i=0; i < 256; i++) {
    chmap[sprintf("%c", i)] = i
  }
  print ord("a"), ord("b")
  printf "%c %c\n", 97, 98
  s = sprintf("%c%c", 97, 98)
  print s
}
