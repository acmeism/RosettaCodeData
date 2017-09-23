def neatly:
  . as $in
  | range(0;length)
  | "\(.): \($in[.])";

def rjust(n): tostring | (n-length)*" " + .;

# The task:
"  i   : [MDR, MP]",
((123321, 7739, 893, 899998) as $i
 | "\($i|rjust(6)): \(mdroot($i))"),
"",
"Tabulation",
"MDR: [n0..n4]",
(tabulate(5) | neatly)
