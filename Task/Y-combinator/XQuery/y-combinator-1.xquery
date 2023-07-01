let $Y := function($f) {
    (function($x) { ($x)($x) })( function($g) { $f( (function($a) { $g($g) ($a)})  ) } )
  }
let $fac := $Y(function($f) { function($n) { if($n <  2) then 1  else $n * $f($n - 1) } })
let $fib := $Y(function($f) { function($n) { if($n <= 1) then $n else $f($n - 1) + $f($n - 2) } })
return (
    $fac(6),
    $fib(6)
)
