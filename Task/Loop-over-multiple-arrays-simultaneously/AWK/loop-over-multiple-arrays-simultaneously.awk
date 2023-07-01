BEGIN {
  split("a,b,c", a, ",");
  split("A,B,C", b, ",");
  split("1,2,3", c, ",");

  for(i = 1; i <= length(a); i++) {
    print a[i] b[i] c[i];
  }
}
