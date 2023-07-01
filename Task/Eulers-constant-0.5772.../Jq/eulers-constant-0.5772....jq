# Bailey, 1988
def bailey($n; $eps):
  pow(2; $n) as $n2
  | {a :1, b: 0, h: 1, r: 1, k: 1}
  | until( (.b - .a)|fabs <= $eps;
      .k += 1
      | .r *= ($n2 / .k)
      | .h += (1.0 / .k)
      | .b = .a
      | .a += (.r * .h) )
  | (.a * $n2 / ($n2|exp) ) - ($n * (2|log)) ;
