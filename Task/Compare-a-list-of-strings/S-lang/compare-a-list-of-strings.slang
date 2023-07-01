define equal_sl(sarr)
{
  variable n = length(sarr), a0, i;
  if (n < 2) return 1;

  a0 = sarr[0];
  _for i (1, length(sarr)-1, 1)
    if (sarr[i] != a0) return 0;

  return 1;
}
define ascending_sl(sarr) {
  variable n = length(sarr), a0, i;
  if (n < 2) return 1;

  _for i (0, length(sarr)-2, 1)
    if (sarr[i] >= sarr[i+1]) return 0;

  return 1;
}


define equal_ai(sarr) {
  if (length(sarr) < 2) return 1;
  variable s0 = sarr[0];
  return all(sarr[[1:]] == s0);
}

define ascending_ai(sarr) {
  variable la = length(sarr);
  if (la < 2) return 1;
  return all(sarr[[0:la-2]] < sarr[[1:la-1]]);
}

define atest(a) {
  () = printf("\n");
  print(a);

  () = printf("equal_sl=%d, ascending_sl=%d\n",
              equal_sl(a), ascending_sl(a));
  () = printf("equal_ai=%d, ascending_ai=%d\n",
              equal_ai(a), ascending_ai(a));
}

atest(["AA","BB","CC"]);
atest(["AA","AA","AA"]);
atest(["AA","CC","BB"]);
atest(["AA","ACB","BB","CC"]);
atest(["single_element"]);
atest(NULL);
