# quotient and remainder
def quotient($a; $b; f; g): f = (($a/$b)|floor) | g = $a % $b;

def tasks:
    [2, 1000, true],
    [1000, 4000, true],
    (1e4, 1e5, 1e6, 1e7, 1e8 | [2, ., false]) ;

def task:
  def update(f): if (f >= 30 and f <= 66) then f %= 10 else . end;

  tasks as $rg
  | if $rg[0] == 2
    then "eban numbers up to and including \($rg[1]):"
    else "eban numbers between \($rg[0]) and \($rg[1]) (inclusive):"
    end,
    ( foreach (range( $rg[0]; 1 + $rg[1]; 2), null) as $i ( { count: 0 };
        .emit = false
        | if $i == null then .total = .count
          else quotient($i; 1e9; .b; .r)
          |    quotient(.r; 1e6; .m; .r)
          |    quotient(.r; 1e3; .t; .r)
          | update(.m) | update(.t) | update(.r)
          | if all(.b, .m, .t, .r; IN(0, 2, 4, 6))
            then .count += 1
            | if ($rg[2]) then .emit=$i else . end
            else .
  	    end
  	  end;
  	  if .emit then .emit else empty end,
  	  if .total then "count = \(.count)\n" else empty end) );

task
