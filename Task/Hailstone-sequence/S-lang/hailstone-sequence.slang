% lst=1, return list of elements; lst=0 just return length
define hailstone(n, lst)
{
  variable l;
  if (lst) l = {n};
  else l = 1;

  while (n > 1) {
    if (n mod 2)
      n = 3 * n + 1;
    else
      n /= 2;
    if (lst)
      list_append(l, n);
    else
      l++;
    % if (prn) () = printf("%d, ", n);
  }
  % if (prn) () = printf("\n");
  return l;
}

variable har = list_to_array(hailstone(27, 1)), more = 0;
() = printf("Hailstone(27) has %d elements starting with:\n\t", length(har));

foreach $1 (har[[0:3]])
  () = printf("%d, ", $1);

() = printf("\nand ending with:\n\t");
foreach $1 (har[[length(har)-4:]]) {
  if (more) () = printf(", ");
  more = printf("%d", $1);
}

() = printf("\ncalculating...\r");
variable longest, longlen = 0, h;
_for $1 (2, 99999, 1) {
  $2 = hailstone($1, 0);
  if ($2 > longlen) {
    longest = $1;
    longlen = $2;
    () = printf("longest sequence started w/%d and had %d elements  \r", longest, longlen);
  }
}
() = printf("\n");
