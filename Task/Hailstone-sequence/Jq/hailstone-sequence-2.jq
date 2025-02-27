[27|hailstone] as $h
| "[27|hailstone]|length is \($h|length)",
  "The first four numbers: \($h[0:4])",
  "The last four numbers:  \($h|.[length-4:length])",
  "",
  (max_hailstone(100000) as $m
   | "Maximum length for n|hailstone for n in 1..100000 is \($m[1]) (n == \($m[0]))")
