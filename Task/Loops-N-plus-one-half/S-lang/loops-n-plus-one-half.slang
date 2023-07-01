variable more = 0, i;
foreach i ([1:10]) {
  if (more) () = printf(", ");
  printf("%d", i);
  more = 1;
}
