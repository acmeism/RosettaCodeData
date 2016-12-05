# for reals, but easily extended to complex values
def gamma_by_lanczos:
  def pow(x): if x == 0 then 1 elif x == 1 then . else x * log | exp end;
  . as $x
  | ((1|atan) * 4) as $pi
  | if $x < 0.5 then $pi / ((($pi * $x) | sin) * ((1-$x)|gamma_by_lanczos ))
    else
      [   0.99999999999980993, 676.5203681218851,     -1259.1392167224028,
        771.32342877765313,   -176.61502916214059,       12.507343278686905,
         -0.13857109526572012,   9.9843695780195716e-6,   1.5056327351493116e-7] as $p
    | ($x - 1) as $x
    | ($x + 7.5) as $t
    |  reduce range(1; $p|length) as $i
          ($p[0]; . + ($p[$i]/($x + $i) ))
       * ((2*$pi) | sqrt) * ($t | pow($x+0.5)) * ((-$t)|exp)
    end;
