def Y [f] {
  {|x| do $f {|y| do (do $x $x) $y } } | do $in $in
}

let factorial = Y {|rec|
  {|n| if $n < 2 { 1 } else { (do $rec ($n - 1)) * $n } }
}

let fibonacci = Y {|rec|
  {|n| if $n < 2 { $n } else { (do $rec ($n - 1)) + (do $rec ($n - 2)) } }
}


..9 | each { {fac: (do $factorial $in) fib: (do $fibonacci $in)} }
