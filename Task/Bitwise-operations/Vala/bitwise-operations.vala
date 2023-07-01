void testbit(int a, int b) {
  print(@"input: a = $a, b = $b\n");
  print(@"AND:  $a  & $b = $(a & b)\n");
  print(@"OR:   $a  | $b = $(a | b)\n");
  print(@"XOR:  $a  ^ $b = $(a ^ b)\n");
  print(@"LSH:  $a << $b = $(a << b)\n");
  print(@"RSH:  $a >> $b = $(a >> b)\n");
  print(@"NOT:  ~$a = $(~a)\n");
  /* there are no rotation operators in vala, but you could define your own
     function to do what is required. */
}

void main() {
  int a = 255;
  int b = 2;
  testbit(a,b);
}
