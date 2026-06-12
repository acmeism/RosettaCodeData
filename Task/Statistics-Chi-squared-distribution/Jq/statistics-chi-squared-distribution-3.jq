def tables:
  def r: round(6) | lpad(10);
  "    Values of the χ2 probability distribution function",
  " x/k    1         2         3         4         5",
  (range(0;11) as $x
   | "\($x|lpad(2)) \(reduce range(1; 6) as $k (""; . + (Chi2_pdf($x; $k) | r) ))" ),

  "\n    Values for χ2 with 3 degrees of freedom",
  "χ2     cum pdf   p-value",
  ( (1, 2, 4, 8, 16, 32) as $x
   | Chi2_cdf($x; 3) as $cdf
   | "\($x|lpad(2)) \($cdf|r)\(1-$cdf|r)"
  );

def airport:  [[77, 23], [88, 12], [79, 21], [81, 19]];
def expected: [81.25, 18.75];

def airport($airport; $expected):
  def dof: ($airport|length - 1) / ($airport[0]|length - 1);

  reduce range(0; $airport|length) as $i (0;
    reduce range(0; $airport[0]|length) as $j (.;
      . + (($airport[$i][$j] - $expected[$j]) | .*.) / $expected[$j] ) )
  | ("\nFor airport data table:",
     "  diff sum : \(.)",
     "  d.o.f.   : \(dof)",
     "  χ2 value : \(Chi2_pdf(.; dof))",
     "  p-value  : \(Chi2_cdf(.; dof)|round(4))" ) ;

tables,
 airport(airport; expected)
