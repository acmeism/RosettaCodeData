# Solution: {"quotient", "remainder"}
def extendedSyntheticDivision($dividend; $divisor):
  { out: $dividend,
    normalizer: $divisor[0],
    separator: (($dividend|length) - ($divisor|length) + 1) }
  | reduce range(0; .separator) as $i (.;
      .out[$i] = ((.out[$i] / .normalizer)|trunc)
      | .out[$i] as $coef
      | if $coef != 0
        then reduce range(1; $divisor|length) as $j (.;
          .out[$i + $j] -=  $divisor[$j] * $coef )
        else .
        end )
  | {quotient: .out[0:.separator], remainder: .out[.separator:]} ;

def task($n; $d):
  def r: if length==1 then first else . end;
  extendedSyntheticDivision($n; $d)
  | "\($n) / \($d)  =  \(.quotient), remainder \(.remainder|r)" ;

task([1, -12, 0, -42]; [1, -3]),
task([1, 0, 0, 0, -2];[1, 1, 1, 1])
