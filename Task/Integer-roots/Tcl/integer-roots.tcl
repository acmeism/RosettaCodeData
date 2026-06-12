proc root {this n} {
  if {$this < 2} {return $this}
  set n1 [expr $n - 1]
  set n2 $n
  set n3 $n1
  set c 1
  set d [expr ($n3 + $this) / $n2]
  set e [expr ($n3 * $d + $this / ($d ** $n1)) / $n2]
  while {$c != $d && $c != $e} {
    set c $d
    set d $e
    set e [expr ($n3 * $e + $this / ($e ** $n1)) / $n2]
  }
  return [expr min($d, $e)]
}

puts [root 8 3]
puts [root 9 3]
puts [root [expr 2* (100**2000)] 2]
