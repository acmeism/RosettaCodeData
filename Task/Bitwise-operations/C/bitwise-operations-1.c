void bitwise(int a, int b)
{
  printf("a and b: %d\n", a & b);
  printf("a or b: %d\n", a | b);
  printf("a xor b: %d\n", a ^ b);
  printf("not a: %d\n", ~a);
  printf("a << n: %d\n", a << b); /* left shift */
  printf("a >> n: %d\n", a >> b); /* on most platforms: arithmetic right shift */
  /* convert the signed integer into unsigned, so it will perform logical shift */
  unsigned int c = a;
  printf("c >> b: %d\n", c >> b); /* logical right shift */
  /* there are no rotation operators in C */
  return 0;
}
