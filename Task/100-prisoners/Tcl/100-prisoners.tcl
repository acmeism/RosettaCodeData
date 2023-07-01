set Samples 10000
set Prisoners 100
set MaxGuesses 50
set Strategies {random optimal}

# returns a random number between 0 and N-1.
proc random {n} {
  expr int(rand()*$n)
}

# Returns a list from 0 to N-1.
proc range {n} {
  set res {}
  for {set i 0} {$i < $n} {incr i} {
    lappend res $i
  }
  return $res
}

# Returns shuffled LIST.
proc nshuffle {list} {
    set len [llength $list]
    while {$len} {
        set n [expr {int($len * rand())}]
        set tmp [lindex $list $n]
        lset list $n [lindex $list [incr len -1]]
        lset list $len $tmp
    }
    return $list
}

# Returns a list of shuffled drawers.
proc buildDrawers {} {
  global Prisoners
  nshuffle [range $Prisoners]
}

# Returns true if P is found in DRAWERS within $MaxGuesses attempts using a
# random strategy.
proc randomStrategy {drawers p} {
  global Prisoners MaxGuesses
  foreach i [range $MaxGuesses] {
    if {$p == [lindex $drawers [random $Prisoners]]} {
      return 1
    }
  }
  return 0
}

# Returns true if P is found in DRAWERS within $MaxGuesses attempts using an
# optimal strategy.
proc optimalStrategy {drawers p} {
  global Prisoners MaxGuesses
  set j $p
  foreach i [range $MaxGuesses] {
    set k [lindex $drawers $j]
    if {$k == $p} {
      return 1
    }
    set j $k
  }
  return 0
}

# Returns true if all prisoners find their number using the given STRATEGY.
proc run100prisonersProblem {strategy} {
  global Prisoners
  set drawers [buildDrawers]
  foreach p [range $Prisoners] {
    if {![$strategy $drawers $p]} {
      return 0
    }
  }
  return 1
}

# Runs the given STRATEGY $Samples times and returns the number of times all
# prisoners succeed.
proc sampling {strategy} {
  global Samples
  set successes 0
  foreach s [range $Samples] {
    if {[run100prisonersProblem $strategy]} {
      incr successes
    }
  }
  return $successes
}

# Returns true if the given STRING starts with a vowel.
proc startsWithVowel {string} {
  expr [lsearch -exact {a e i o u} [string index $string 0]] >= 0
}

# Runs each of the STRATEGIES and prints a report on how well they
# worked.
proc compareStrategies {strategies} {
  global Samples
  set fmt "Using %s %s strategy, the prisoners were freed in %5.2f%% of the cases."
  foreach strategy $strategies {
    set article [expr [startsWithVowel $strategy] ? {"an"} : {"a"}]
    set pct [expr [sampling ${strategy}Strategy] / $Samples.0 * 100]
    puts [format $fmt $article $strategy $pct]
  }
}

compareStrategies $Strategies
