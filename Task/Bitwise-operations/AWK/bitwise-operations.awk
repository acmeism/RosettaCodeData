BEGIN {
  n = 11
  p = 1
  print n " or  " p " = " or(n,p)
  print n " and " p " = " and(n,p)
  print n " xor " p " = " xor(n,p)
  print n " <<  " p " = " lshift(n, p)   # left shift
  print n " >>  " p " = " rshift(n, p)   # right shift
  printf "not %d = 0x%x\n", n, compl(n)  # bitwise complement
}
