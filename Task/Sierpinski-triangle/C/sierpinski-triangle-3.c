void sierpinski_triangle(int n)
{
  int i;
  int l = 1<<(n+1);
  char *b = malloc(l+1);

  memset(b, ' ', l);
  b[l] = 0;
  b[l>>1] = '*';

  printf("%s\n", b);
  for(i=0; i < l/2-1;i++) {
    rule_90(b);
    printf("%s\n", b);
  }

  free(b);
}
