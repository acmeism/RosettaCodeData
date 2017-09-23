def demo(n):
  "ss:           \( [range(0;n)] | ss )",
  "ss(S):        \( ss( range(0;n) ) )",
  "SIGMA(.*.):   \( [range(0;n)] | SIGMA(.*.) )",
  "SIGMA(.*.;S): \( SIGMA( .*.; range(0;n) ) )",
  "mapreduce(.*.; add; 0): \( [range(0;n)] | mapreduce(.*.; add; 0) )"
;

demo(3) # 0^2 + 1^2 + 2^2
